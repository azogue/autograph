#!/usr/bin/env bash
# Usage:
# ./autograph.sh file_to_sign.pdf new_signed_file.pdf

ALIAS="apellido1 apellido2 nombre - 123456789a"
PATH_JAR=/Applications/AutoFirma.app/Contents/Resources/JAR/AutoFirma.jar

echo "* SIGNING: ${@:1}"
IN="${@:1}"
DIR="${IN%/*}"
FILE="${IN##*/}"
FILE_WO_EXT="${FILE%.*}"
EXTENSION="${IN##*.}"
OUT="${DIR}/FIRMADOS/${FILE_WO_EXT}__signed.${EXTENSION}"

echo "**** Firmando digitalmente ${IN} ==> ${OUT}: **"
RES=`(java -jar ${PATH_JAR} sign -i "${IN}" -o "${OUT}" -alias "${ALIAS}"   \
   -store mac -xml | grep "result>true" | wc -l | sed -e 's/^[[:space:]]*//')`

if [ "$RES" == "1" ]
then
    echo " >>> ${OUT} FIRMADO SATISFACTORIAMENTE."
else
    echo " <<< ERROR EN FIRMA DIGITAL, no se ha podido firmar ${IN} en ${OUT}"
fi
echo "DONE"

exit 0
