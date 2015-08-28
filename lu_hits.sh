grep 'INFO: Request URI:' $1 \
    | awk '{print $7, $4}' \
    | sed -E 's/lookups=([0-9]+)/\1/g' \
    | q "select sum(c1), c2 from - group by c2" \
    | sort -rn
