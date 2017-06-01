#!/bin/bash
export USER=root
rm -f ../*.tar.xz

package=$( head -n1 debian/changelog | \
        sed -r 's/^([^ ]+) \((.+)\).*$/\1_\2/g' | \
        sed -r 's/-[^-]+$//g' | \
        sed -r 's/_[0-9]+:/_/g' )

echo "Executing dh_make ..."
dh_make --createorig -p ${package} -dya

echo "Executing debuild ..."
debuild -uc -us
