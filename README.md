# Firma electrónica de documentos en _batch_ en macOS

Para firmar documentalmente cualquier tipo de archivo, con objeto de automatizar esa tediosa tarea, creando una carpeta con una acción asociada que crea versiones firmadas digitalmente de los archivos arrastrados, usando la firma digital de la FNMT.

Consiste en un simple _shell script_ para usar el CLI de la aplicación oficial de firma electrónica en España, **[AutoFirma v.1.5](http://firmaelectronica.gob.es/Home/Ciudadanos/Aplicaciones-Firma.html)**, del Ministerio de Hacienda.

### Uso simple por fichero:

```bash
./autograph.sh path/to/file_to_sign.pdf
```
Genera el fichero firmado **`path/to/FIRMADOS/file_to_sign__signed.pdf`**.

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
# ./autograph.sh path/to/file_to_sign.pdf
# Generates:
# path/to/FIRMADOS/file_to_sign__signed.pdf

ALIAS="apellido1 apellido2 nombre - 123456789a"
SUBDIR_OUT="FIRMADOS"
PATH_JAR=/Applications/AutoFirma.app/Contents/Resources/JAR/AutoFirma.jar

echo "* SIGNING: ${@:1}"
IN="${@:1}"
DIR="${IN%/*}"
FILE="${IN##*/}"
FILE_WO_EXT="${FILE%.*}"
EXTENSION="${IN##*.}"
OUT="${DIR}/${SUBDIR_OUT}/${FILE_WO_EXT}__signed.${EXTENSION}"

mkdir ${DIR}/${SUBDIR_OUT}
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

Acudir a **[valide.redsara.es](https://valide.redsara.es/valide/validarFirma/ejecutar.html)**, cargar el fichero, rellenar el _captcha_, y comprobar los resultados.

## Demo visual

![Demo](https://github.com/azogue/autograph/blob/master/docs/demo.gif)

El _gif_ está generado a partir de una grabación de pantalla realizada con Quicktime Player (parte de macOS), que da lugar a un fichero `.mov`, y de ahí a gif vía `ffmpeg` con el comando: `ffmpeg -i video.mov -pix_fmt rgb24 -r 5 demo.gif`.


# Comprobación/visualización de firmas digitales

Se incluye otro shell script y otro _workflow_ de _Automator_, de tipo 'Servicio', para disponer de un nuevo menú en el _Finder_ para mostrar las firmas digitales de uno o más archivos haciendo click derecho y seleccionando: `Servicios -> Muestra firma digital`.
Este _workflow_ llama al script de visualización con cada archivo seleccionado:

```text
for f in "$@"
do
    echo "* SHOW: $f"
    /path/to/script/show_autograph.sh $f
done
```

Y el contenido de este script es:

**_show_autograph.sh_**
```bash
#!/usr/bin/env bash
# Usage:
# ./show_autograph.sh path/to/file_to_sign.pdf
# Opens a panel showing the digital signature of the file

PATH_JAR=/Applications/AutoFirma.app/Contents/Resources/JAR/AutoFirma.jar

IN="${@:1}"
echo "* CHECK SIGN IN: ${IN}"
RES=`(java -jar ${PATH_JAR} verify -i "${IN}")`

exit 0
```

## Demo visual

![Demo](https://github.com/azogue/autograph/blob/master/docs/demo_show.gif)
