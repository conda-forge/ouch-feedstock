#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"
    export CXXFLAGS="${CXXFLAGS} -I${BUILD_PREFIX}/${HOST}/include/c++/v1 -I${BUILD_PREFIX}/${HOST}/sysroot/usr/include"
    export CXX="${CXX}"
fi

# Build binary with cargo-auditable
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
