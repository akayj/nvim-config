#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly RELEASE_URL='https://github.com/neovim/neovim/releases/download/nightly/nvim-%s.%s'

[ -f "./lib/colors.sh" ] && source "./lib/colors.sh"

function expand_color() {
	local colors="${1:-}"
	if [ "$colors" == "" ]; then
		exit 2
	fi

	echo "${colors}" | awk -F ',' '{
    if ($2 == "") print 0";"$1;
    else print $1";"$2;
  }'
}

function color_message() {
	local color="$(expand_color $1)"
	shift
	local template="$1"
	shift

	printf "\e[%sm$template\e[0m" "${color}" "$@"
	printf "\n"
}

# log::debug() { color_message '35' "$@"; }
function log::debug() { color_message '1,35' "$@"; }
function log::success() { color_message 32 "$@"; }
# shellcheck disable=SC2317
function log::warn() { color_message 33 "$@"; }
function log::info() { color_message 34 "$@"; }
# shellcheck disable=SC2317
function log::error() { color_message 31 "$@" >&2; }

function log::fatal() {
	local message=${1:-}
	local exit_code=${2:-1}

	[[ -z ${1-} ]] || {
		log::error "$message" >&2
	}

	exit "$exit_code"
}

function https_curl() {
	local url="${1:-}"

	if [ "${url}" == "" ]; then
		return 1
	fi

	curl --progress-bar -fLO "${url}"
}

function install_nvim() {
	local arg="${1:-}"

	command -v nvim >/dev/null && {
		log::success "nvim %s is already installed" $(nvim -v | head -n 1 | awk '{print $2}')
		if [ "${arg}" != '-f' ]; then
			return
		fi
		log::warn 'force to install'
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
		log::error "unknown os ${os_name}"
		return 1
		;;
	esac
}

install_nvim "$@" || log::fatal "failed"
