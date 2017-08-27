#!/usr/bin/env bash
# https://stackoverflow.com/questions/3970643/how-can-i-check-mysql-statements-for-syntactical-correctness
source_dir=${1};
database="mysql_test";
mysql_args="-h127.0.0.1";

mysql $mysql_args -B -e "DROP DATABASE IF EXISTS $database; CREATE DATABASE $database;";
for file in `find $source_dir -name "*.sql"`; do
    lint_result=`mysql $mysql_args $database -f -b < $file 2>&1`;
    if [ "`echo $lint_result | sed -r \"s/ERROR ([0-9]*).*/\1/g\"`" = "1064" ]; then
        echo -e "Syntax error in file ${file}:\n${lint_result}" && exit 1;
    fi;
done
