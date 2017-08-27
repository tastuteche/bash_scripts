#!/usr/bin/env bash

# http://use-the-index-luke.com/blog/2013-08/its-not-about-the-star-stupid
# ./select_star_is_bad.sh test/select_star.sql
grep -iPn 'select[^*]+\*.+from' "$1"
