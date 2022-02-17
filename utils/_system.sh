#!/bin/bash
# 
# system management

get_first_folder() {

  dir=$1

sudo su - deploy << EOF
  cd $dir
  files=(*);

  echo ${files[0]}
EOF

  sleep 2
}

get_oldest_file() {

  dir=$1

  unset -v oldest
  for file in "$dir"/*; do
      [[ -z $oldest || $file -ot $oldest ]] && oldest=$file
  done

  echo $oldest
}

get_oldest_folder() {

  local dir=$1

  IFS= read -r -d $'\0' line < <(find $dir -maxdepth 1 -type d -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
  local file="${line#* }"

  if [ "$dir" == "$file" ]; then
    echo false
  else
    echo $file
  fi

}
