# Gruppo get content analysis

Usage: ./analyze.sh catalina.out

    cat $LOG_FILE \
      | grep 'INFO: Request URI:' \
      | awk "{ print \$$1, \$4 }" \
      | sed -E "s/$2/\1/g" \
      | q "select $3(c1), c2 from - group by c2" \
      | sort -rn
