#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"
    export BZIP3_LIB_DIR="$BUILD_PREFIX/lib"
    export BZIP3_INCLUDE_DIR="$BUILD_PREFIX/include"
fi

# build binary with Cargo
cargo install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
