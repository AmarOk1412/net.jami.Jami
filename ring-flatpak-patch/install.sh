#!/usr/bin/env bash

# Build and install to a local prefix under this repository.
export OSTYPE

set -ex

make_install() {
    make install
}

TOP=`pwd`
INSTALL="/app"
BUILDDIR="build"
client="client-gnome"
proc=`grep -m 1 'cpu cores' /proc/cpuinfo | awk '{split($0,a,": "); print(a[2]);}'`

cd "${TOP}/daemon"
DAEMON="$(pwd)"
cd contrib
mkdir -p native
cd native
../bootstrap --prefix="/app"
make
cd "${DAEMON}"
./autogen.sh

./configure $sharedLib $CONFIGURE_FLAGS --prefix="/app"
make -j${proc}
make_install

cd "${TOP}/lrc"
mkdir -p ${BUILDDIR}
cd ${BUILDDIR}
cmake .. -DCMAKE_INSTALL_PREFIX="/app" -DCMAKE_BUILD_TYPE=Release $static
make -j${proc}
make_install

cd "${TOP}/${client}"
mkdir -p ${BUILDDIR}
cd ${BUILDDIR}
cmake .. -DCMAKE_INSTALL_PREFIX="/app" $static
make -j${proc}
make_install