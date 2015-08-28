#!/bin/sh

set -e

if [ -z "$1" ]
then
    printf "usage: $0 catalina.out\n"
    exit -1
fi

TASKS="hits misses lu_hits lu_misses"
for TASK in $TASKS
do
    printf "Running task: '%s'\n" "$TASK"
    ./${TASK}.sh $1 > ${TASK}.out
    head -3 ${TASK}.out
done
