#!/usr/bin/env bash

set -o pipefail

RED='\033[31m'
CYAN='\033[36m'
YELLOW='\033[33m'
RESET='\033[0m'

__exec() {
    local cmd=$1
    shift
    echo -e "${CYAN}> $cmd $@${RESET}"
    set +e
    $cmd $@
    local exit_code=$?
    set -e
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Failed with exit code $exit_code${RESET}"
        exit 1
    fi
}

_download() {
    curl -sSL https://raw.githubusercontent.com/dotnet/cli/rel/1.0.1/scripts/obtain/dotnet-install.sh \
        | bash -s -- -i $dir -v $version
}

ensure_dotnet() {
    dir=$1
    shift
    version=$1
    shift
    export PATH="$dir:$PATH"
    if ! which dotnet >/dev/null ; then
        _download $dir $version
    else
        current_version="$(dotnet --version || echo '')"
        if [[ "$current_version" != "$version" ]]; then
            _download $dir $version
        fi
    fi
}
