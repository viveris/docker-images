#!/bin/bash -x
export USER=root
rm -f *.tar.xz
cd src

GIT_REVISION=$( git show --pretty=format:%H | head -n1 )
GIT_TAGS=$( git tag --points-at ${GIT_REVISION} 2>/dev/null || true )
TAG=$( echo "${GIT_TAGS}" | grep -E "^${BRANCH}$" || echo "" )

if [ -z "${GIT_TAGS}" -o -z "${TAG}" ] ; then
    # Integration branches shall match the following regexp
    INT_REGEX="^xcb[0-9]+\.[0-9]+$"

    # Not a tag, we are building a (dynamic) branch and we're suffixing the package's version
    if [[ ${BRANCH} =~ ${INT_REGEX} ]]; then
        # Integration branch, suffix is for a PRE-release
        SUFFIX="~${BRANCH}"
    else
        # Suffix packaging if for a feature branch
        SUFFIX="+${BRANCH}"
    fi

    sed -ri "0,/\(([^~]*)(~.*)?\)/s//\(\1${SUFFIX}\)/" debian/changelog
fi

package=$( head -n1 debian/changelog | \
        sed -r 's/^([^ ]+) \((.+)\).*$/\1_\2/g' | \
        sed -r 's/-[^-]+$//g' | \
        sed -r 's/_[0-9]+:/_/g' )

echo "Executing dh_make ..."
dh_make --createorig -p ${package} -dya

echo "Executing debuild ..."
debuild -uc -us
