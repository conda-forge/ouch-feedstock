#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"
fi

# Build binary with cargo-auditable
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
