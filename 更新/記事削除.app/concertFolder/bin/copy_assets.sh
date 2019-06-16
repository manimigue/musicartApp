#! /bin/bash

file=$1
changerPath=$2
articlesPath=$3

cd $changerPath

predata=$(sed -e 's/.*!\[\([^(]*\)\](\([^)]*assets[^)]*\)).*/((([[[\1]]]{{{\2}}})))/g' $file | grep '(((\[\[\[')

if [ -z "$predata"]
then
  copied=""
  log="アップロードされた写真はありませんでした"
  imports=""
  replaces="\`"
else
  beforeVars=$(echo -e "$predata" | sed -e 's/(((\[\[\[\(.*\)\]\]\].*)))/i\1/g')
  beforePathes=$(echo -e "$predata" | sed -e 's/(((.*{{{\(.*\)}}})))/\1/g')

  vars=$(bash bin/var.sh "$beforeVars")
  pathes=$(bash bin/path.sh "$beforePathes")


  n=$(echo "$beforeVars" | wc -l )

  copied=""
  used=""
  missed=""
  imports=""
  replaces="\`\n"

  for i in $(seq 1 $n)
  do
    beforePath=$(sed "${i}q;d" <<< "$beforePathes")
    var=$(sed "${i}q;d" <<< "$vars")
    path=$(sed "${i}q;d" <<< "$pathes")

    imports+="import ${var} from '${path}'\n"
    replaces+=".replace('${beforePath}',${var})\n"

    if test -a $articlesPath/articles/assets/$(sed -e 's/[\.\/]*assets\///g' <<< "$path")
    then
      used+="${path}\n"
    else
      if cp $beforePath $articlesPath/articles/assets/$(sed -e 's/[\.\/]*assets\///g' <<< "$path")
      then
        copied+="${path}\n"
      else
        missed+="${path}\n"
      fi
    fi
  done

  replaces=$(echo -e "$replaces")
  imports=$(echo -e "$imports")

  log="アップロードが完了しました。\n"
  if [ ! -z $copied ]
  then
    log+="以下の写真がアップロードされました。\n${copied}"
  fi

  if [ ! -z $used ]
  then
    log+="以下の写真は他の記事で既にアップロード済みです。アップロードした記事を消すと消えてしまうので気をつけてください。\n${used}"
  fi

  if [ ! -z $missed ]
  then
    log+="以下の写真はassetsフォルダに存在しなかったためアップロードできませんでした。\n${missed}"
  fi
fi

export copied
export log
export imports
export replaces
