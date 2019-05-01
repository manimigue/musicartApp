#! /bin/bash

replace=$(
sed -e 's/[[:space:]]//g' -e 's/^assets/\.\/assets/g' <<< "$1"
)
previous="n$modifiedPath"

while [ "${#previous}" -ne "${#replace}" ]
do
  previous=$replace
  replace=$(sed -e 's/\.\/\([^\.]*\)\.\([^\.]*\)\./.\/\1\2./g' <<< "$previous")
done

echo -e "$replace"
