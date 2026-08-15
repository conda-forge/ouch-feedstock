#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"

    CXX_INCLUDE_DIR=$(find "${BUILD_PREFIX}/${HOST}/sysroot/usr/include/c++" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n1)
    if [[ -z "${CXX_INCLUDE_DIR}" ]]; then
        echo "ERROR: could not locate libstdc++ headers under ${BUILD_PREFIX}/${HOST}/sysroot/usr/include/c++" >&2
        exit 1
    fi

    export CXXFLAGS="${CXXFLAGS} -I${CXX_INCLUDE_DIR} -I${CXX_INCLUDE_DIR}/${HOST} -I${BUILD_PREFIX}/${HOST}/sysroot/usr/include"
    export CXX="${CXX}"
fi

# Build binary with cargo-auditable
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml