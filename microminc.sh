#!/bin/bash


# CHECKS
# ==========

if ! [ -d "$MNIBASEPATH" ]; then
  >&2 echo "error: MNIBASEPATH=$MNIBASEPATH is not a directory"
  exit 1
fi


# FUNCTIONS
# ==========

function mni_libs_of () {
  ldd $(which $1) | grep -oe "$MNIBASEPATH/lib/.* "
}

# ARGUMENTS
# ==========

if [ "$#" -lt "2" ]; then
  >&2 echo "usage: $0 program_name... output_dir"
  exit 1
fi 

last_arg="${@: -1}"
output_dir="$last_arg"



# SCRIPT
# ==========

mkdir -vp "$output_dir/bin"
mkdir -vp "$output_dir/lib"


for prog in "$@"; do
  if [ "$prog" = "$last_arg" ]; then
    break
  fi

  mni_libs_of "$prog" | xargs cp -vut "$output_dir/lib"
  cp -vu "$(which $prog)" "$output_dir/bin"
done
