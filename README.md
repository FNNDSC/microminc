# microminc

[![build](https://github.com/FNNDSC/microminc/actions/workflows/build.yml/badge.svg)](https://github.com/FNNDSC/microminc/actions/workflows/build.yml)
[![MIT License](https://img.shields.io/github/license/fnndsc/pypx-listener)](https://github.com/FNNDSC/pypx-listener/blob/main/LICENSE)

`microminc.sh` is a simple script which copies binary executables and their dynamically linked libraries to a new directory.
It is hard-coded to work with MNI software. It is useful for minimizing OCI images of CIVET + MINC tools.

## Examples

- https://github.com/FNNDSC/pl-nii2mnc/tree/main/base
- https://github.com/FNNDSC/pl-bichamfer/tree/main/base
- https://github.com/FNNDSC/pl-fetal-surface-extract/tree/main/base (includes Perl scripts and data models)
