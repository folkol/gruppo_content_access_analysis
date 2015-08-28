#!/bin/sh

if [ -z "$1" ]
then
    printf "usage: $0 catalina.out\n"
    exit -1
fi

LOG_FILE=$1
digest() {
    cat $LOG_FILE \
        | grep 'INFO: Request URI:' \
        | awk "$1" \
        | sed -E "$2" \
        | q "$3" \
        | sort -rn
}

hits_sum() {
    digest '{print $5, $4}' 's/getContent=([0-9]+)/\1/g' 'select sum(c1), c2 from - group by c2'
}

misses_sum() {
    digest '{print $6, $4}' "s/\(([0-9]+)\),/\1/g" "select sum(c1), c2 from - group by c2"
}

lu_hits_sum() {
    digest '{print $7, $4}' 's/lookups=([0-9]+)/\1/g' "select sum(c1), c2 from - group by c2"
}

lu_misses_sum() {
    digest '{print $8, $4}' "s/\(([0-9]+)\)/\1/g" "select sum(c1), c2 from - group by c2"
}

hits_max() {
    digest '{print $5, $4}' 's/getContent=([0-9]+)/\1/g' 'select max(c1), c2 from - group by c2'
}

misses_max() {
    digest '{print $6, $4}' "s/\(([0-9]+)\),/\1/g" "select max(c1), c2 from - group by c2"
}

lu_hits_max() {
    digest '{print $7, $4}' 's/lookups=([0-9]+)/\1/g' "select max(c1), c2 from - group by c2"
}

lu_misses_max() {
    digest '{print $8, $4}' "s/\(([0-9]+)\)/\1/g" "select max(c1), c2 from - group by c2"
}

TASKS="hits_sum misses_sum lu_hits_sum lu_misses_sum hits_max misses_max lu_hits_max lu_misses_max"
for TASK in $TASKS
do
    printf "\n=== Running task: '%s' ===\n" "$TASK"
    ${TASK} $1 > ${TASK}.out
    head -3 ${TASK}.out
done
