cat $1 \
    | grep 'INFO: Request URI:' \
    | awk '{print $7, $4}' \
    | sed -E 's/lookups=([0-9]+)/\1/g' \
    | q "select max(c1), c2 from - group by c2" \
    | sort -rn
