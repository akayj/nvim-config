#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly RELEASE_URL='https://github.com/neovim/neovim/releases/download/nightly/nvim-%s.%s'

# [ -f "./lib/colors.sh" ] && source "./lib/colors.sh"
readonly Red='31'       # Red
readonly Purple='35'    # Purple
readonly BRed='1;31'    # Red
readonly BGreen='1;32'  # Green
readonly BYellow='1;33' # Yellow
readonly BBlue='1;34'   # Blue

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
function log::debug() { color_message "$BBlue" "$@"; }
function log::success() { color_message "$BGreen" "$@"; }
# shellcheck disable=SC2317
function log::warn() { color_message "$BYellow" "$@"; }
function log::info() { color_message "$Purple" "$@"; }
# shellcheck disable=SC2317
function log::error() { color_message "$BRed" "$@" >&2; }

function log::fatal() {
	local message=${1:-}
	local exit_code=${2:-1}

	[[ -z ${1-} ]] || {
		log::error "$message" >&2
	}

	exit "$exit_code"
}

declare curl_version
curl_version="$(curl -V | head -n 1 | cut -d ' ' -f 2)"
readonly curl_version

function https_curl() {
	if [[ $(echo "${curl_version} 7.20.0" | awk '{print ($1 > $2)}') -eq 1 ]]; then
		curl --proto '=https' --tlsv1.2 $@
	else
		curl --tlsv1.2 $@
	fi
}

readonly https_curl

function download_url() {
	local url="${1:-}"

	if [ "${url}" == "" ]; then
		return 1
	fi

	https_curl --progress-bar -fLO "${url}"
}

readonly download_url

function nvim_version() {
	if command -v nvim >/dev/null; then
		echo $(nvim -v | head -n 1 | awk '{print $2}')
	fi
}

function install_nvim() {
	local force="${1:-}"
	local old_version=$(nvim_version)

	if [ "${old_version}" != "" ]; then
		log::info "nvim %s was installed" "${old_version}"
		if [ "${force}" != "-f" ]; then
			return
		else
			log::warn 'force to install'
		fi
	fi

	local os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
	local file_url=''

	case "${os_name}" in
	"darwin")
		file_url=$(printf "${RELEASE_URL}" "macos" "tar.gz")
		download_url "$file_url"
		xattr -c ./nvim-macos.tar.gz
		;;

	"linux")
		checksum_url=$(printf "${RELEASE_URL}" "linux64" "tar.gz.sha256sum")
		download_url "$checksum_url"

		file_url=$(printf "${RELEASE_URL}" "linux64" "tar.gz")
		if [ -f 'nvim-linux64.tar.gz' ]; then
			if ! sha256sum -c "nvim-linux64.tar.gz.sha256sum"; then
				log::error "invalid tarball, download..."
				download_url "$file_url"
				if ! sha256sum -c "nvim-linux64.tar.gz.sha256sum"; then
					log::fatal "invalid tarball"
				fi
			fi
		else
			download_url "$file_url"
			if ! sha256sum -c "nvim-linux64.tar.gz.sha256sum"; then
				log::fatal "invalid tarball"
			fi
		fi

		if [ -d "${HOME}/nvim-linux64" ]; then
			rm -rf "${HOME}/nvim-linux64" || log::fatal 'remove old dir failed'
		fi

		log::info 'untar...'
		tar -C "${HOME}" -xvf nvim-linux64.tar.gz >/dev/null

		log::info 'linking...'
		ln -s -f "${HOME}/nvim-linux64" "${HOME}/nvim_home"

		local new_version=$(nvim_version)
		if [ "${old_version}" == '' ]; then
			log::success "new nvim %s installed" "${new_version}"
		elif [ "${old_version}" != "${new_version}" ]; then
			log::success "nvim upgraded, %s -> %s" "${old_version}" "${new_version}"
		else
			log::success "nvim %s reinstalled" "${new_version}"
		fi
		;;

	*)
		log::error "unknown os ${os_name}"
		return 1
		;;
	esac
}

readonly install_nvim

install_nvim "$@" || log::fatal "failed"
