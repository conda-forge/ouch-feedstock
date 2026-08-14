#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"

    export CC_x86_64_unknown_linux_gnu="${CC}"
    export CXX_x86_64_unknown_linux_gnu="${CXX}"
    export AR_x86_64_unknown_linux_gnu="${AR}"
    export CXXFLAGS_x86_64_unknown_linux_gnu="${CXXFLAGS}"

    export CC_aarch64_unknown_linux_gnu="${CC}"
    export CXX_aarch64_unknown_linux_gnu="${CXX}"
    export AR_aarch64_unknown_linux_gnu="${AR}"
    export CXXFLAGS_aarch64_unknown_linux_gnu="${CXXFLAGS}"
fi

# Build binary with cargo-auditable
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
