grep 'INFO: Request URI:' $1 | awk '{print $5, $4}' | sed -E 's/getContent=([0-9]+)/\1/g' | sort -rn
