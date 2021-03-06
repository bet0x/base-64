#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

PKG_NAME="gawk"
PKG_VERSION="4.1.3"

TARBALL="${PKG_NAME}-${PKG_VERSION}.tar.xz"
SRC_DIR="${PKG_NAME}-${PKG_VERSION}"

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "Description: The Gawk package contains programs for manipulating text files."
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
}

function prepare() {
    ln -sv /sources/${TARBALL} ${TARBALL}
}

function unpack() {
    tar xf ${TARBALL}
}

function build() {
    ./configure --prefix=/usr   \
                --libexecdir=/usr/lib

    make ${MAKE_PARALLEL}
}

function runTest() {
    make ${MAKE_PARALLEL} check || true
}

function instal() {
    make ${MAKE_PARALLEL} install
}

function clean() {
    rm -rf ${SRC_DIR} ${TARBALL}
}

# Run the installation procedure
time { showHelp;clean;prepare;unpack;pushd ${SRC_DIR};build;[[ ${MAKE_TESTS} = TRUE ]] && runTest;instal;popd;clean; }
# Verify installation
if [ -f /usr/bin/gawk ]; then
    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
fi