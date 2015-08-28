#!/bin/sh

if [ -z "$1" ]
then
    printf "usage: $0 catalina.out\n"
    exit -1
fi

TASKS="hits_sum misses_sum lu_hits_sum lu_misses_sum hits_max misses_max lu_hits_max lu_misses_max"
for TASK in $TASKS
do
    printf "=== Running task: '%s' ===\n" "$TASK"
    ./${TASK}.sh $1 > ${TASK}.out
    head -3 ${TASK}.out
done
