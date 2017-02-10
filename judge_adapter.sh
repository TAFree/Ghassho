#!/usr/bin/env bash


##
# File	      : judge_adapter.sh
# Description : An adapter is triggered by judge daemon to execute specific judge script for each submission.
# Creator     : Yu Tzu Wu <abby8050@gmail.com>
# License     : MIT
declare -r JA_MYSQL_LOGINPATH="gate_ghassho"
declare -r JA_MYSQL_DATABASE="TAFreeDB"
declare -r JA_MYSQL_OPTS="--login-path=${JA_MYSQL_LOGINPATH} --database=${JA_MYSQL_DATABASE}"
declare -r JA_CLIENT_HOSTNAME=$(hostname)
declare -r JA_CLIENT_UNIQUE="$(uuidgen)"
declare -r JA_CLIENT_SIGNATURE="${JA_CLIENT_UNIQUE}\n(${JA_CLIENT_HOSTNAME})"
declare -r JA_CLIENT_DIR=".process"
declare -r JA_CLIENT_UNIQUE_DIR="${JA_CLIENT_DIR}/${JA_CLIENT_UNIQUE}/script" 


##
# Perform a query on the database and return result
# @param string $1 mysql command options
# @param string $2 sql statements
# @return string raw query result
# @returnStatus 1 database's host is unknown
# @returnStatus 1 query failed
function mysqlQuery () {
	
	local options="$1"
	local query="$2"
	local result
	
	result=$(mysql ${options} -e "$query")
	
	if [[ $? -ne 0 ]]; then
		echo "MySQL query failed" >&2
	else
		echo "$result"
	fi
}


## 
# Fetch associated value from a SQL query result
# @param string query result
# @param string column name
# @return string column value
function fetchAssoc () {

	local result="$1"
	local key="$2"
	declare -i index=0
	declare -i line=0
	
	read -a names <<< "${result}"
	for name in "${names[@]}"; do
		if [[ "$name" == "$key" ]]; then
			break
		fi
		index=$(($index+1))		
	done
	
	while read -a words; do
		if [[ $line -eq 1 ]]; then
			echo ${words[${index}]}
		fi
		line=$(($line+1)) 
	done <<< "${result}"
	
}


## 
# Fetch only one column value from a SQL query result
# @param string query result
# @return string column value
function fetchOneCol () {

	local result="$1"
	
	echo "${result#content[[:ascii:]]}"

}


##
# Parameters for querying
STUDENT_ACCOUNT="student_account"
ITEM="item"
SUBITEM="subitem"
ID="id"
JUDGESCRIPT="judgescript"
CONTENT="content"
CMD="cmd"
EXT=""
JUDGEFILE=""


## 
# Functions for querying
function querySubmission () {

	declare -r TEST_QUERY_SUBMISSION="\
	UPDATE process SET judger='${JA_CLIENT_SIGNATURE}' WHERE judger IS NULL ORDER BY id LIMIT 1;\
	SELECT student_account, item, subitem, id FROM process WHERE judger='${JA_CLIENT_SIGNATURE}';"

	local submission=$(mysqlQuery "${JA_MYSQL_OPTS}" "${TEST_QUERY_SUBMISSION}")

	if [[ -n $submission ]]; then
		STUDENT_ACCOUNT=$(fetchAssoc "${submission}" "${STUDENT_ACCOUNT}")
		ITEM=$(fetchAssoc "${submission}" "${ITEM}")
		SUBITEM=$(fetchAssoc "${submission}" "${SUBITEM}")	
		ID=$(fetchAssoc "${submission}" ${ID})
	else
		echo "No new submission" >&2
		exit 1
	fi

}

function queryScript () {

	declare -r TEST_QUERY_SCRIPT="\
	SELECT judgescript FROM ${ITEM} WHERE subitem='${SUBITEM}';"

	local script=$(mysqlQuery "${JA_MYSQL_OPTS}" "${TEST_QUERY_SCRIPT}")

	if [[ -n $script ]]; then
		JUDGESCRIPT=$(fetchAssoc "${script}" "${JUDGESCRIPT}")
	else
		echo "No judge script filename there" >&2
		exit 1
	fi

}

function queryContent () {

	declare -r TEST_QUERY_CONTENT="\
	SELECT content FROM ${ITEM} WHERE subitem='${SUBITEM}';"

	local content=$(mysqlQuery "${JA_MYSQL_OPTS}" "${TEST_QUERY_CONTENT}")

	if [[ -n $content ]]; then
		CONTENT=$(fetchOneCol "${content}")
	else
		echo "No judge script content there" >&2
		exit 1
	fi

}

function queryCommand () {

	EXT="${JUDGESCRIPT##*.}"

	declare -r TEST_QUERY_SUPPORT="\
	SELECT cmd FROM support WHERE ext='${EXT}';"
	
	local command=$(mysqlQuery "${JA_MYSQL_OPTS}" "${TEST_QUERY_SUPPORT}")

	if [[ -n $command ]]; then
		CMD=$(fetchAssoc "${command}" "${CMD}")
	else
		echo "Not support file (.${EXT})" >&2
		exit 1
	fi

}


##
# Launch functions and execute judge script
querySubmission
queryScript
queryContent
queryCommand
mkdir ${JA_CLIENT_DIR}/${JA_CLIENT_UNIQUE}
mkdir ${JA_CLIENT_UNIQUE_DIR}
JUDGEFILE="${JA_CLIENT_UNIQUE_DIR}/${JUDGESCRIPT}"
echo ${CONTENT} > ${JUDGEFILE}
exec ${CMD} ${JUDGEFILE} ${STUDENT_ACCOUNT} ${ITEM} ${SUBITEM} ${ID}





