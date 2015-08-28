cat $1 \
    | grep 'INFO: Request URI:' \
    | awk '{print $5, $4}' \
    | sed -E 's/getContent=([0-9]+)/\1/g' \
    | q "select sum(c1), c2 from - group by c2" \
    | sort -rn
