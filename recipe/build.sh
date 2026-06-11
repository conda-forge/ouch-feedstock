#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export CC_aarch64_unknown_linux_gnu="${CC}"
export CXX_aarch64_unknown_linux_gnu="${CXX}"
export AR_aarch64_unknown_linux_gnu="${AR}"
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="${CC}"

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"
fi

# build binary with Cargo
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
