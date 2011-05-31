#!/bin/sh

# INTER-Mediator Distribution File Builder by Masayuki Nii
#    Execute for current directory as the root of repository.

echo "Enter version number (don't include ver. or VER. etc) --> "
read version

dt=`date "+%Y-%m-%d"`

curpath=`dirname "$0"`
echo "Working Directory is:", ${curpath}
cd "${curpath}"

cat << EOF > "${curpath}"/sedrule
s/@@@@1@@@@/${dt}/
s/@@@@2@@@@/${version}/
EOF

rm -r ../temp
mkdir ../temp
cd ../temp
#cp -r "${curpath}"/develop-im .
cp "${curpath}"/dist-docs/*.txt .
cp "${curpath}"/dist-docs/TestDB.fp7 .

mkdir develop-im
for FILE in `ls "${curpath}"/develop-im`
do
	if [ -f "${curpath}"/develop-im/"${FILE}" ]; then 
	sed -f "${curpath}"/sedrule "${curpath}"/develop-im/"${FILE}" > develop-im/"${FILE}"
	fi
done

cp -r "${curpath}"/develop-im/images develop-im/

mkdir develop-im/INTER-Mediator
for FILE in `ls "${curpath}"/develop-im/INTER-Mediator`
do
	if [ -f "${curpath}"/develop-im/INTER-Mediator/"${FILE}" ]; then 
	sed -f "${curpath}"/sedrule "${curpath}"/develop-im/INTER-Mediator/"${FILE}" > develop-im/INTER-Mediator/"${FILE}"
	fi
done

mkdir develop-im/WebSite
for FILE in `ls "${curpath}"/develop-im/WebSite`
do
	if [ -f "${curpath}"/develop-im/WebSite/"${FILE}" ]; then
	sed -f "${curpath}"/sedrule "${curpath}"/develop-im/WebSite/"${FILE}" > develop-im/WebSite/"${FILE}"
	fi
done

#java -jar ../yuicompressor-2.4.2.jar -o temp.js develop-im/INTER-Mediator/INTER-Mediator.js
#mv -f temp.js develop-im/INTER-Mediator/INTER-Mediator.js

rm -rf develop-im/INTER-Mediator/FX
zip -r INTER-Mediator-${version}.zip *.txt TestDB.fp7 develop-im
rm "${curpath}"/sedrule
