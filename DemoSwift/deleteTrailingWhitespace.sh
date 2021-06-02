#!/bin/sh
set -x

# 删除行尾空格
swiftFiles=`find . -name "*.swift"`
for file in $swiftFiles
do
	/usr/bin/sed -i "" 's/[ ]*$//g' $file
done

set +x
