#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ "${build_platform}" == linux-* ]]; then
    export LIBCLANG_PATH="$BUILD_PREFIX/lib"
fi

if [[ "${target_platform}" == linux-* ]]; then
    # unrar-ng-sys's build script unconditionally adds `-stdlib=libc++`, which our
    # clang accepts but cannot satisfy (no libc++ headers on linux). Appending the
    # libstdc++ selection after it wins, since clang honours the last `-stdlib`.
    export CXXFLAGS="${CXXFLAGS} -stdlib=libstdc++"
fi

# build binary with Cargo
cargo auditable install --no-track --locked --root "$PREFIX" --path .

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
