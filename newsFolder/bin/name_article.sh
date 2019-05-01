#!/bin/bash

url=$1
folder2name=$2

sed -e "s/ARTICLE/$url/g" $folder2name
