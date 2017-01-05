#!/usr/bin/env bash


# File	      : judge_adapter.sh
# Description : An adapter is triggered by judge daemon to execute specific judge script for each submission.
# Creator     : Yu Tzu Wu <abby8050@gmail.com>
# License     : MIT


# Constant
declare -r JA_MYSQL_LOGINPATH="gate_ghassho"
declare -r JA_MYSQL_DATABASE="TAFreeDB"
declare -r JA_MYSQL_OPTS="--login-path=${JA_MYSQL_LOGINPATH} --database=${JA_MYSQL_DATABASE}"
declare -r JA_CLIENT_HOSTNAME=$(hostname)
declare -r JA_CLIENT_UNIQUE="$(uuidgen)"
declare -r JA_CLIENT_SIGNATURE="${JA_CLIENT_UNIQUE}\n(${JA_CLIENT_HOSTNAME})"


# Variable
ITEM=""
SUBITEM=""
STUDENT_ACCOUNT=""
JUDGESCRIPT=""
CONTENT=""
CMD=""
EXT=""


# SQL
JA_QUERY_SUBMISSION="\
UPDATE process SET judger='${JA_CLIENT_SIGNATURE}' WHERE judger IS NULL ORDER BY id LIMIT 1;\
SELECT student_account, item, subitem FROM process WHERE judger='${JA_CLIENT_SIGNATURE}';"

JA_QUERY_JUDGESCRIPT="\
SELECT judgescript, content FROM ${ITEM} WHERE subitem='${SUBITEM}';"

JA_QUERY_SUPPORT="\
SELECT cmd FROM support WHERE ext='${EXT}';"


# Function
function __mysql_query () {
	$(mysql ${JA_MYSQL_OPTS} -e ${JA_QUERY_SUBMISSION})
}


# Main
JUDGEFILE="${JA_CLIENT_UNIQUE}_${JUDGESCRIPT}"
echo ${CONTENT} > ${JUDGEFILE}
exec ${CMD} ${JUDGESCRIPT}





