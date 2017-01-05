#!/usr/bin/env bash

STRING="tes.t.php"
declare -i POS
declare -i LEN
POS=`expr index "${STRING}" '.'`
LEN=`expr length "${STRING}"` 
echo `expr substr ${STRING} ${POS} ${LEN}`



