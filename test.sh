#!/bin/bash -ex

microminc.sh create_tetra adapt_object_mesh /tmp/o1
test -x /tmp/o1/bin/create_tetra
test -x /tmp/o1/bin/adapt_object_mesh
test -f /tmp/o1/lib/libminc2.so.*
test -f /tmp/o1/lib/libvolume_io2.so.*
! test -e /tmp/o2/perl

microminc.sh -p '&do_cmd' vertstats_math bestsurfreg.pl /tmp/o2
test -x /tmp/o2/bin/vertstats_math
test -x /tmp/o2/bin/bestsurfreg.pl
test -x /tmp/o2/bin/create_tetra
test -x /tmp/o2/bin/depth_potential
test -f /tmp/o2/lib/libbicpl.so.*
test -f /tmp/o2/perl/MNI/FileUtilities.pm

rm -rf /tmp/o1 /tmp/o2
