#!/bin/sh

if [ -z "$1" ]
then
    printf "usage: $0 catalina.out\n"
    exit 2
fi

LOG_FILE=$1
analyze() {
    cat $LOG_FILE \
        | grep 'INFO: Request URI:' \
        | awk "{ print \$$1, \$4 }" \
        | sed -E "s/$2/\1/g" \
        | q "select $3(c1), c2 from - group by c2" \
        | sort -rn
}

hits_sum() {
    analyze 5 'getContent=([0-9]+)' 'sum'
}

misses_sum() {
    analyze 6 '\(([0-9]+)\),' 'sum'
}

lu_hits_sum() {
    analyze 7 'lookups=([0-9]+)' 'sum'
}

lu_misses_sum() {
    analyze 8 '\(([0-9]+)\)' 'sum'
}

hits_max() {
    analyze 5 'getContent=([0-9]+)' 'max'
}

misses_max() {
    analyze 6 '\(([0-9]+)\),' 'max'
}

lu_hits_max() {
    analyze 7 'lookups=([0-9]+)' 'max'
}

lu_misses_max() {
    analyze 8 '\(([0-9]+)\)' 'max'
}

TASKS='hits_sum misses_sum lu_hits_sum lu_misses_sum hits_max misses_max lu_hits_max lu_misses_max'
for TASK in $TASKS
do
    printf "\n=== Running task: '%s' ===\n" "$TASK"
    ${TASK} $1 > ${TASK}.out
done

head -5 *out
