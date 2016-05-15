#!/usr/bin/env bash

set +h		# disable hashall
shopt -s -o pipefail
set -e 		# Exit on error

PKG_NAME="tcl"
PKG_VERSION="8.6.1"

TARBALL="${PKG_NAME}${PKG_VERSION}-src.tar.gz"
SRC_DIR="${PKG_NAME}${PKG_VERSION}"

function help() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "Description: The Tcl package contains the Tool Command Language."
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
}

function prepare() {
    ln -sv "/sources/$TARBALL" "$TARBALL"
}

function unpack() {
    tar xf "${TARBALL}"
}

function build() {
    sed -i s/500/5000/ generic/regc_nfa.c
    cd unix
    ./configure --prefix="${HOST_TOOLS_DIR}"

    make "${MAKE_PARALLEL}"
}

function test() {
    echo ""
}

function instal() {
    make "${MAKE_PARALLEL}" install
    make "${MAKE_PARALLEL}" install-private-headers

    ln -sv tclsh8.6 "${HOST_TOOLS_DIR}/bin/tclsh"
}

function clean() {
    rm -rf "${SRC_DIR}" "${TARBALL}"
}

# Run the installation procedure
time { help;clean;prepare;unpack;pushd "${SRC_DIR}";build;[[ "${MAKE_TESTS}" = TRUE ]] && test;instal;popd;clean; }
# Verify installation
if [ -f "${HOST_TOOLS_DIR}/bin/tclsh" ]; then
    touch DONE
fi