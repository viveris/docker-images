#!/bin/sh -x

REPOSITORY="$1"
DISTRIBUTION="$2"
COMPONENT="$3"
PACKAGES="$4"
BUILD_NUMBER="$5"
OS="$6"

if [ -z "${REPOSITORY}" -o \
     -z "${DISTRIBUTION}" -o \
     -z "${COMPONENT}" -o \
     -z "${BUILD_NUMBER}" -o \
     -z "${PACKAGES}" ] ; then
    echo "Please give all parameters."
    exit 1
fi

if [ -z "${OS}" ]
	then OS="ubuntu"
fi

REPO_USER="root"
REPO_PASS="toor"
REPO_BASE_PATH="/var/www/repos/apt/${OS}"
REPO_INCOMING_PATH="/tmp/incoming/${BUILD_NUMBER}"
SSH_OPTIONS="-o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o StrictHostKeyChecking=no"
SSH="sshpass -p${REPO_PASS} ssh ${SSH_OPTIONS}"
SCP="sshpass -p${REPO_PASS} scp ${SSH_OPTIONS}"
REMOTE_CMD="${SSH} ${REPO_USER}@${REPOSITORY}"

for PACKAGE in ${PACKAGES} ; do
    if [ ! -f "${PACKAGE}" ] ; then
        echo "'${PACKAGE}' does not exist on Builder."
        exit 1
    fi

    PACKAGE_FILE="$( basename ${PACKAGE} )"
    PACKAGE_NAME="$( echo ${PACKAGE_FILE} | cut -d'_' -f1 )"

    # Upload package to the incoming remote directory
    ${REMOTE_CMD} "mkdir -p ${REPO_INCOMING_PATH}"
    ${SCP} "${PACKAGE}" ${REPO_USER}@${REPOSITORY}:${REPO_INCOMING_PATH}/
    if [ "$?" != "0" ] ; then
        exit 1
    fi

    # Remove existing old package in the same repository (because reprepro
    # does not allow overwritting file)
    ${REMOTE_CMD} "reprepro --component ${COMPONENT} -b ${REPO_BASE_PATH} remove ${DISTRIBUTION} ${PACKAGE_NAME}"

    # Put package in the Distribution/Component
    ${REMOTE_CMD} "reprepro --component ${COMPONENT} -b ${REPO_BASE_PATH} includedeb ${DISTRIBUTION} ${REPO_INCOMING_PATH}/${PACKAGE_FILE}" 2>&1 | tee $$.log

    # Clean incoming directory
    ${REMOTE_CMD} "rm -rf ${REPO_INCOMING_PATH}"

    grep -qi "error" $$.log
    if [ "$?" = "0" ] ; then
        rm $$.log
        exit 1
    fi
    rm -f $$.log
done
