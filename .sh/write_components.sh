#!/bin/bash

#必要なもの : $1=article生成ファイル $2=articleType その他 log.json in $1
cd $1
articleType=$2

exports=$(jq '[.[]|{title,url,date,author}|.component=.url]' log.json | sed -e 's/"title"/title/g' -e 's/"author"/author/g' -e 's/"url"/url/g' -e 's/"date"/date/g' -e 's/"component"/component/g' -e 's/component:[[:space:]]*"\([^"]*\)"/component: \1/g' -e "s/component: \(.*\)/component: ${articleType}_\1/g")

folder-module articles/ components.js
components=$(sed -e 's/^export/import/g' components.js)

cat > components.js <<endmsg
$components

const ${articleType} =
$exports

export default ${articleType}
endmsg
