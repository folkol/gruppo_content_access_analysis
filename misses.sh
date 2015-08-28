grep 'INFO: Request URI:' $1 | awk '{print $6, $4}' | sed -E 's/\(([0-9]+)\)/\1/g' | sort -rn
