# microminc

[![build](https://github.com/FNNDSC/microminc/actions/workflows/build.yml/badge.svg)](https://github.com/FNNDSC/microminc/actions/workflows/build.yml)
[![MIT License](https://img.shields.io/github/license/fnndsc/pypx-listener)](https://github.com/FNNDSC/pypx-listener/blob/main/LICENSE)

`microminc.sh` is a simple script which copies binary executables and their dynamically linked libraries to a new directory.
It is hard-coded to work with MNI software. It is useful for minimizing OCI images of CIVET + MINC tools.

## Examples

- https://github.com/FNNDSC/pl-nii2mnc/tree/main/base
- https://github.com/FNNDSC/pl-bichamfer/tree/main/base
- https://github.com/FNNDSC/pl-fetal-surface-extract/tree/main/base (includes Perl scripts and data models)

## Local Development

Build

```shell
docker build -t localhost/fnndsc/microminc:latest .

```

Test

```shell
docker run --rm -it \
    -v "$PWD/microminc.sh:/usr/local/bin/microminc.sh:ro" \
    -v "$PWD/test.sh:/test.sh:ro" \
    localhost/fnndsc/microminc:latest /test.sh
```

## License

`microminc.sh` itself is MIT-licensed. CIVET is not free software, its license can be found here: https://github.com/aces/CIVET_Full_Project/blob/master/LICENSE
