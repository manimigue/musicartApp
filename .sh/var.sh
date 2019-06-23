#!/bin/bash

#必要なもの : $1=copy_assets.shの$beforeVars

LANG=C
replace=$(
  sed -e 's/[-\/\:\.[:space:]]//g' -e 's/[^[:alnum:]]//g' <<< "$1"
)
previous="n$replace"

let i=1
while [ "${#previous}" -ne "${#replace}" ]
do
  previous=$replace
  replace=$(
    sed -e "/^i/{s//I${i}/;:a" -e '$!N;$!ba' -e '}' <<< "$previous"
  )
  let i=i+1
done

echo -e "$replace"
