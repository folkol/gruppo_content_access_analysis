./hits.sh $1 > hits.txt
./misses.sh $1 > misses.txt
./lu_hits.sh $1 > lu_hits.txt
./lu_misses.sh $1 > lu_misses.txt

head -4 *.txt
