#!/bin/bash

# Constant
LOGIN_PATH=gate_ghassho
DATABASE=TAFreeDB

# Variable
HOSTNAME=$(hostname)
SIGNATURE=$(uuidgen)'\n('${HOSTNAME}')'
ITEM=""
SUBITEM=""
STUDENT_ACCOUNT=""
JUDGESCRIPT=""
CONTENT=""
CMD=""
EXT=""

while read student_account item subitem; do
	echo ${student_account}..${item}..${subitem}
done < $(mysql --login-path=$LOGIN_PATH --database=$DATABASE << EOF
UPDATE process SET judger='$SIGNATURE' WHERE judger IS NULL ORDER BY id LIMIT 1;
SELECT student_account, item, subitem FROM process WHERE judger='$SIGNATURE';
EOF)


mysql --login-path=$LOGIN_PATH --database=$DATABASE << EOF
SELECT judgescript, content FROM $ITEM WHERE subitem='$SUBITEM';
EOF

mysql --login-path=$LOGIN_PATH --database=$DATABASE << EOF
SELECT cmd FROM support WHERE ext='$EXT';
EOF

$(${CMD} ${JUDGESCRIPT})





