#!/bin/bash -e
set -o pipefail

HELP="$0 [-p &CMD] prog1 prog2 ... outputdir/

$0 is a script for copying executable programs and their dynamically linked
libraries to an output directory. It specifically works on CIVET binaries only.

options:
  -h       show this help message and exit
  -p &CMD  name of Perl subroutine which is used to call subprocesses.
           Using this option enables $0 to handle Perl scripts.
"

# CHECKS
# ==========

if ! [ -d "$MNIBASEPATH" ]; then
  >&2 echo "error: MNIBASEPATH=$MNIBASEPATH is not a directory"
  exit 1
fi


# FUNCTIONS
# ==========

# (bin_name) -> list<str>
function mni_libs_of () {
  ldd $(which $1) | grep -oe "$MNIBASEPATH/lib/.* " || echo 2> /dev/null
}

# (script_name.pl &do_cmd) -> list<str>
function called_bins_of () {
  cat $(which "$1")               \
    | grep -F "$2"                \
    | sed "s/\"/'/g"              \
    | awk -F  "'" '{print $2}'    \
    | sort | uniq                 \
    | xargs -L 1 which            \
    | grep "$MNIBASEPATH/bin"
}

function is_perl_script () {
  file "$(which "$1")" | grep -q 'Perl script text executable'
}

function should_strip () {
  file "$(which "$1")" | grep -q 'ELF .* executable.*not stripped'
}

# ARGUMENTS
# ==========

while getopts ":hp:" opt; do
  case $opt in
  h   ) echo "$HELP" && exit 0 ;;
  p   ) perl_cmd_func="$OPTARG" ;;
  \?  ) printf "%s: -%s\n%s\n" "Invalid option" $OPTARG "Run $0 -h for help."
    exit 1 ;;
  esac
done

shift $((OPTIND-1))

if [ "$#" -lt "2" ]; then
  >&2 echo "usage: $0 program_name... output_dir/"
  exit 1
fi

last_arg="${@: -1}"
output_dir="$last_arg"


# SCRIPT
# ==========

mkdir -vp "$output_dir/bin"
mkdir -vp "$output_dir/lib"

bin_progs=()
perl_scripts=()

for prog in "$@"; do
  if [ "$prog" = "$last_arg" ]; then
    break
  elif is_perl_script "$prog"; then
    perl_scripts+=("$prog")
  else
    bin_progs+=("$prog")
  fi
done

for prog in "${perl_scripts[@]}"; do
  if [ -z "$perl_cmd_func" ]; then
    echo "Cannot handle Perl script '$prog', please specify value for -p."
    exit 1
  fi
  dst="$output_dir/bin/$(basename $prog)"
  cp -vu "$(which $prog)" "$dst"
  bin_progs+=( $(called_bins_of "$prog" "$perl_cmd_func") )
done

for prog in "${bin_progs[@]}"; do
  libs="$(mni_libs_of "$prog")"
  if [ -n "$libs" ]; then
    cp -vu $libs "$output_dir/lib"
  fi
  dst="$output_dir/bin/$(basename $prog)"
  cp -vu "$(which $prog)" "$dst"

  if should_strip "$dst"; then
    strip --verbose "$dst"
  fi
done

if [ -n "$(find "$output_dir/bin" -name '*.pl' | head)" ]; then
  cp -rv "$MNIBASEPATH/perl" "$output_dir/perl"
fi
