#!/bin/sh

# INTER-Mediator Deployment File Set Builder
# Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
# This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
#
# INTER-Mediator is supplied under MIT License.
# Please see the full license for details:
# https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

version="6-dev"

# The file of minify <http://www.minifier.org> can be downloaded from below.
# git clone https://github.com/matthiasmullie/minify
#
MINIFYJS="minify"
buildRootName="im_build"
imRootName="INTER-Mediator"
receipt="receipt.txt"

param=""

# $1: file path, $2: appending file
function readFileUntilMark () {
    sed -ne '/@@IM@@IgnoringRestOfFile/q;P' < "$1" > "__temp1"
    sed -ne '/@@IM@@IgnoringNextLine/{n;d;};P' < "__temp1" > "__temp2"
    sed -ne '/@@IM@@IgnoringNextLine/d;P' < "__temp2" >> "$2"
    rm "__temp1" "__temp2"
}

if [ $# -gt 1 ]; then
    echo "*** No parameter of just 1 parameter is allowed. ***" 1>&2
    exit 1
fi

for opt in "$@"
do
	case "$opt" in
		-a | --all)
			param=1
			;;
		-c | --core)
			param=2
			;;
		-d | --deploy)
		    param=3
			;;
		* )
			echo "invalid option -- $opt"
			exit 1
	esac
done

/bin/echo "================================================="
/bin/echo " Start to build the INTER-Mediator Ver.${version}"
/bin/echo "-------------------------------------------------"

dt=$(date "+%Y-%m-%d")
distDocDir=$(cd $(dirname "$0"); pwd)
originalPath=$(dirname "${distDocDir}")

# printf '{"version":"%s","releasedate":"%s"}' "${version}" "${dt}" > "${originalPath}/metadata.json"

topOfDir=$(dirname "${originalPath}")
buildDir="${topOfDir}/${buildRootName}"
buildPath="${buildDir}/${imRootName}"
/bin/echo " Original: ${originalPath}"
/bin/echo " Build to: ${buildPath}"

minifyjsDir="${originalPath}/vendor/matthiasmullie/${MINIFYJS}"
minifyjsBin="${originalPath}/vendor/bin/${MINIFYJS}js"
if [ -e "${minifyjsDir}" -a -e "${minifyjsBin}" ]; then
    /bin/echo " Path of minifyer (installed by composer): ${minifyjsDir}"
else
    minifyjsDir="${topOfDir}/${MINIFYJS}"
    minifyjsBin="${topOfDir}/${MINIFYJS}/bin/${MINIFYJS}js"
    if [ -e "${minifyjsDir}" -a -e "${minifyjsBin}" ]; then
        /bin/echo " Path of minifyer: ${minifyjsDir}"
    else
        /bin/echo "*** Minifyer isn't exist. ***"
        /bin/echo -n "Y or y: clone the minify, others: nothing to do----> "
        read choice
        if [ "$choice" = "Y" -o "$choice" = "y" ]; then
            git clone https://github.com/matthiasmullie/minify "${minifyjsDir}"
        else
            /bin/echo "*** JaveScript code won't minify, i.e. stay as original. ***"
        fi
    fi
fi

/bin/echo "-------------------------------------------------"
/bin/echo "Choose the build result from these:"
/bin/echo ' (1) Complete (everything contains)'
/bin/echo ' (2) Core only (the least set to work web applications)'
/bin/echo ' (3) Core only, and move it to 3-up directory (the ancestor of original INTER-Mediator)'
#/bin/echo ' (4) Write just version and release date to metadata.json'
choice=${param}
if [ ${#param} = 0 ]; then
    /bin/echo -n "Type 1, 2 or 3, and then type return----> "
    read choice
    /bin/echo ""
else
    /bin/echo "Choice by command line parameter: $choice"
fi

if [ ${#choice} -lt 1 -o ${#choice} -gt 3 ]; then
    /bin/echo "*** Do nothing at all. ***"
    exit 0;
fi

if [ -d "${buildDir}" ]; then
    rm -r "${buildDir}"
fi
mkdir -p "${buildPath}/src/js/"
mkdir -p "${buildPath}/src/php/"
mkdir -p "${buildPath}/src/lib/"
mkdir -p "${buildPath}/src/lib/js_lib"

/bin/echo "PROCESSING: Copying php files"
cp -f "${originalPath}/INTER-Mediator.php" "${buildPath}/"
cp -rf "${originalPath}/src/php" "${buildPath}/src"
# cp -rf "${originalPath}/vendor" "${buildPath}"
cp -rf "${originalPath}/.git" "${buildPath}"

cp  "${originalPath}/composer.json" "${buildPath}/"
cp  "${originalPath}/params.php" "${buildPath}/"
cp  "${originalPath}/index.html" "${buildPath}/"
cp  "${originalPath}/LICENSE.md" "${buildPath}/"
sed -E -e 's|"./vendor/bin/npm install"|"./vendor/bin/npm install --only=production"|' "${originalPath}/composer.json" > "${buildPath}/composer.json"
cp  "${originalPath}/composer.lock" "${buildPath}/"
cp  "${originalPath}/package.json" "${buildPath}/"
cp  "${originalPath}/package-lock.json" "${buildPath}/"

#### Merge js files
/bin/echo "PROCESSING: Merging JS files"
touch "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Page.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-ContextPool.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Context.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-LocalContext.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Lib.js" "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Graph.js"                    "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Format.js"                 "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Element.js"                "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/lib/js_lib/js-expression-eval-parser.js"     "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Calc.js"                   "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/Adapter_DBServer.js"                      "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Parts.js"                  "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Navi.js"                   "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-UI.js"                     "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Log.js"                    "${buildPath}/src/js/temp.js"
if [ ! -e "${minifyjsDir}" ]; then
    readFileUntilMark "${originalPath}/src/lib/js_lib/tinySHA1.js"                  "${buildPath}/src/js/temp.js"
    /bin/echo ';'                                                          "${buildPath}/src/js/temp.js"
    readFileUntilMark "${originalPath}/src/lib/js_lib/sha256.js"                    "${buildPath}/src/js/temp.js"
    /bin/echo ';'                                                          "${buildPath}/src/js/temp.js"
    readFileUntilMark "${originalPath}/src/lib/js_lib/jsencrypt.min.js"             "${buildPath}/src/js/temp.js"
	/bin/echo ";"
fi
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Queuing.js"                "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-Events.js"                 "${buildPath}/src/js/temp.js"
readFileUntilMark "${originalPath}/src/js/INTER-Mediator-DoOnStart.js"              "${buildPath}/src/js/temp.js"

#cp "${buildPath}/src/js/temp.js" "${buildPath}/src/js/INTER-Mediator.js"
cp -prf "${originalPath}"/src/js/*.js "${buildPath}/src/js/"

#### Compress INTER-Mediator.js
if [ -e "${minifyjsDir}" ]; then
    sed '1s/*/*!/' "${buildPath}/src/js/temp.js" > "${buildPath}/src/js/temp2.js"

    osName=$(uname -s)
    /bin/echo "Detected OS: ${osName}"
    if [[ "${osName}" == CYGWIN* ]];  then
        temp2Path=$(cygpath -w "${buildPath}/src/js/temp2.js")
        temp3Path=$(cygpath -w "${buildPath}/src/js/temp3.js")
        temp4Path=$(cygpath -w "${buildPath}/src/js/temp4.js")
    else
        temp2Path="${buildPath}/src/js/temp2.js"
        temp3Path="${buildPath}/src/js/temp3.js"
        temp4Path="${buildPath}/src/js/temp4.js"
    fi
    /bin/echo "MINIFYING."
	"${minifyjsBin}" "${temp2Path}" > "${temp3Path}"
    #sed '1s/*!/*/' "${temp3Path}" > "${buildPath}/src/js/INTER-Mediator.js"
    head -n 9 "${originalPath}/src/js/INTER-Mediator.js"     > "${buildPath}/src/js/temp.js"
	cat "${temp3Path}"                                      >> "${buildPath}/src/js/temp.js"
	/bin/echo ";"                                           >> "${buildPath}/src/js/temp.js"
	touch "${temp4Path}"
	readFileUntilMark "${originalPath}/src/lib/js_lib/tinySHA1.js" "${temp4Path}"
	tail -n 1 "${temp4Path}"                                >> "${buildPath}/src/js/temp.js"
    /bin/echo ";"                                           >> "${buildPath}/src/js/temp.js"
    tail -n 1 "${originalPath}/src/lib/js_lib/sha256.js"    >> "${buildPath}/src/js/temp.js"
	/bin/echo ";"                                           >> "${buildPath}/src/js/temp.js"
    cat "${originalPath}/src/lib/js_lib/jsencrypt.min.js"   >> "${buildPath}/src/js/temp.js"
	/bin/echo ""                                            >> "${buildPath}/src/js/temp.js"
    mv  "${buildPath}/src/js/temp.js" "${buildPath}/src/js/INTER-Mediator.min.js"
    rm  "${temp2Path}" "${temp3Path}" "${temp4Path}"
else
    rm  "${buildPath}/src/js/temp.js"
fi

#/bin/echo "PROCESSING: ${originalPath}/src/js/INTER-Mediator-IE.js"
#targetJS="${buildPath}/src/js/INTER-Mediator.js"
#tempJS="${originalPath}/temp.js"
#temp2JS="${originalPath}/temp2.js"
#ieCode="${buildPath}/src/js/INTER-Mediator-IE.js"
#babelBin="${originalPath}/node_modules/.bin/babel"
#if [ -e "${babelBin}" ]; then
#    cp "${targetJS}" "${tempJS}"
#    ${babelBin} --out-file "${temp2JS}" --minified "${tempJS}"
#    cp "${temp2JS}" "${ieCode}"
#    rm "${tempJS}" "${temp2JS}"
#fi

# Copy "lib" path php contents.
/bin/echo "PROCESSING: ${originalPath}/src/lib"
cp -prf "${originalPath}/src/lib/CWPKit"        "${buildPath}/src/lib"
cp -prf "${originalPath}/src/lib/mailsend"      "${buildPath}/src/lib"
cp -prf "${originalPath}/src/lib/js_lib/js-expression-eval-parser.js"      "${buildPath}/src/lib/js_lib"

if [ $choice = 1 ]; then
    /bin/echo "PROCESSING: ${originalPath}/README.md"
    cp -p   "${originalPath}/README.md" "${buildPath}"

    /bin/echo "PROCESSING: ${originalPath}/dist-docs"
    cp -prf "${originalPath}/dist-docs" "${buildPath}"

    /bin/echo "PROCESSING: ${originalPath}/spec"
    cp -prf "${originalPath}/spec" "${buildPath}"

    /bin/echo "PROCESSING: ${originalPath}/samples"
    cp -pr  "${originalPath}/samples" "${buildPath}"

    /bin/echo "PROCESSING: ${originalPath}/editors"
    cp -pr  "${originalPath}/editors" "${buildPath}"

# Invalidate the definition file of the DefEditor.
#    echo "PROCESSING: Invalidate the Definition File Editor for security reason."
#    defeditdeffile="${buildPath}/INTER-Mediator-Support/defedit.php"
#    sed 's|IM_Entry|/* IM_Entry|' "${defeditdeffile}" > /tmp/defedit.php
#    cp -p /tmp/defedit.php "${defeditdeffile}"
else
    /bin/echo "PROCESSING: ${originalPath}/dist-docs/License.txt"
    cp -p   "${originalPath}/dist-docs/License.txt" "${buildPath}"
    readmeLines=`wc -l "${originalPath}/dist-docs/readme.txt" | awk '{print $1}'`
    lines=`expr $readmeLines - 8`
    /bin/echo "PROCESSING: ${originalPath}/dist-docs/readme.txt"
    head -n `/bin/echo $lines` "${originalPath}/dist-docs/readme.txt" > "${buildPath}/readme.txt"
fi

/bin/echo "PROCESSING: ${originalPath}/themes"
cp -prf "${originalPath}/themes" "${buildPath}"

/bin/echo "PROCESSING: PHP/JavaScript Libraries"
cd "${buildPath}"
composer update --no-dev

/bin/echo "Clean up dot files."
find "${buildPath}" -name "\.*" -exec rm -rf {} \; -prune

if [ $choice = 3 ]; then
    targetDir=$(dirname "${topOfDir}")
    /bin/echo "Move ${imRootName} directory to: ${targetDir}"
    if [ -e "${targetDir}/${imRootName}" ]; then
        rm -rf "${targetDir}/${imRootName}"
    fi
    mv "${buildPath}" "${targetDir}"
fi

#
/bin/echo ""
/bin/echo "=================================================" >> "${buildDir}/${receipt}"
/bin/echo " INTER-Mediator Ver.${version} was successfully Build" >> "${buildDir}/${receipt}"
/bin/echo " Check out: ${buildDir}" >> "${buildDir}/${receipt}"
/bin/echo "=================================================" >> "${buildDir}/${receipt}"
/bin/echo "Date: $(date)" >> "${buildDir}/${receipt}"
/bin/echo "OS Info: $(uname -a)" >> "${buildDir}/${receipt}"
/bin/echo "Original: ${originalPath}" >> "${buildDir}/${receipt}"
/bin/echo "Build to: ${buildPath}" >> "${buildDir}/${receipt}"
if [ $choice = 1 ]; then
    /bin/echo 'Your Choice: (1) Complete (everything contains)' >> "${buildDir}/${receipt}"
elif [ $choice = 2 ]; then
    /bin/echo 'Your Choice: (2) Core only (the least set to work web applications)' >> "${buildDir}/${receipt}"
elif [ $choice = 3 ]; then
    /bin/echo 'Your Choice: (3) Core only, and move it to 3-up directory (the ancestor of original INTER-Mediator)' >> "${buildDir}/${receipt}"
fi
/bin/echo "" >> "${buildDir}/${receipt}"
/bin/echo "You can deploy the 'INTER-Mediator' folder into your web applications. Enjoy!!" >> "${buildDir}/${receipt}"
/bin/echo "" >> "${buildDir}/${receipt}"
/bin/echo "INTER-Mediator Web Site: https://inter-mediator.com/" >> "${buildDir}/${receipt}"

/bin/echo "================================================="
/bin/echo " INTER-Mediator Ver.${version} was successfully Build"
/bin/echo " Check out: ${buildDir}"
/bin/echo "================================================="
