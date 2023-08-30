#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly RELEASE_URL='https://github.com/neovim/neovim/releases/download/nightly/nvim-%s.%s'

https_curl() {
	local url="${1:-}"

	if [ "${url}" == "" ]; then
		return 1
	fi

	curl --progress-bar -fLO "${url}"
}

readonly https_curl

install_nvim() {
	command -v nvim >/dev/null || {
		echo 'install nvim first'
	}

	local os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
	local file_url=''

	case "${os_name}" in
	"darwin")
		file_url=$(printf "${RELEASE_URL}" "macos" "tar.gz")
		https_curl "$file_url"
		xattr -c ./nvim-macos.tar.gz
		;;

	"linux")
		file_url=$(printf "${RELEASE_URL}" "linux64" "tar.gz")
		https_curl "$file_url"
		;;

	*)
		echo "unknown os ${os_name}"
		exit 1
		;;
	esac
}

readonly install_nvim

install_nvim
