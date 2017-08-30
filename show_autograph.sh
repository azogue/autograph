#!/usr/bin/env bash
# Usage:
# ./show_autograph.sh path/to/file_to_sign.pdf
# Opens a panel showing the digital signature of the file

PATH_JAR=/Applications/AutoFirma.app/Contents/Resources/JAR/AutoFirma.jar

IN="${@:1}"
echo "* CHECK SIGN IN: ${IN}"
RES=`(java -jar ${PATH_JAR} verify -i "${IN}")`

exit 0
