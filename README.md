# Firma electrónica de documentos en _batch_ en macOS

Para firmar documentalmente cualquier tipo de archivo, con objeto de automatizar esa tediosa tarea, creando una carpeta con una acción asociada que crea versiones firmadas digitalmente de los archivos arrastrados, usando la firma digital de la FNMT.

### Uso simple por fichero:

```bash
./autograph.sh file_to_sign.pdf new_signed_file.pdf
```

## Múltiples ficheros:

### Mediante acciones de carpeta (_Automator.folderAction_)

En **Automator**, creamos una nueva 'Acción de carpeta', especificamos una carpeta del disco que actuará como receptora, para arrastrar grupos de archivos para firmar allí.

- Añadimos una acción **'Ejecutar el script Shell'**, seleccionamos `/bin/bash` y pasar datos de entrada 'como argumentos', y como contenido del script, introducimos:

```text
for f in "$@"
do
    echo "* SIGNING: $f"
    /path/to/script/autograph.sh $f
done
```

Sustituyendo `path/to/script` con el path real, o simplemente añadiendo ahí el contenido del script que llama al CLI de la app de firma digital:

**_autograph.sh_**
```bash
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
exit 0
```

### Mediante script externo

.... **_TODO_** .... si es menester.

## Check de firma digital:

Acudir a **[valide.redsara.es](https://valide.redsara.es/valide/validarFirma/ejecutar.html)**, cargar el fichero, rellenar el captcha, y comprobar los resultados.

## Demo visual

![Demo](https://github.com/azogue/autograph/blob/master/docs/demo.gif)

El _gif_ está generado a partir de una grabación de pantalla realizada con Quicktime Player (parte de macOS), que da lugar a un fichero `.mov`, y de ahí a gif vía `ffmpeg`:
```bash
ffmpeg -i video.mov -pix_fmt rgb24 -r 5 demo.gif
```