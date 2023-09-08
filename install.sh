#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly RELEASE_URL='https://github.com/neovim/neovim/releases/download/nightly/nvim-%s.%s'

# [ -f "./lib/colors.sh" ] && source "./lib/colors.sh"
readonly WHITE='37'     # white
readonly Red='31'       # Red
readonly Purple='35'    # Purple
readonly BRed='1;31'    # Red
readonly BGreen='32'    # Green
readonly BYellow='1;33' # Yellow
readonly BBlue='1;34'   # Blue

function expand_color() {
	local colors="${1:-${WHITE}}"

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
}

function log::log() { color_message '' "$@"; }

# log::debug() { color_message '35' "$@"; }
function log::debug() {
	color_message "$BBlue" "$@"
	echo
}
function log::success() {
	color_message "$BGreen" "$@"
	echo
}
# shellcheck disable=SC2317
function log::warn() {
	color_message "$BYellow" "$@"
	echo
}
function log::info() {
	color_message "$Purple" "$@"
	echo
}
# shellcheck disable=SC2317
function log::error() {
	color_message "$BRed" "$@" >&2
	echo
}

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

function check_file() {
	local filename="${1:-}"
	if [ -z "${filename}" ]; then
		log::error "empty filename is invalid"
		return 1
	fi

	local sumfile="${2:-${filename}.sha256sum}"
	if [ ! -f "${sumfile}" ]; then
		return 1
	fi

	if command -v sha256sum >/dev/null; then
		sha256sum -c "${sumfile}" >/dev/null 2>&1
	elif command -v shasum >/dev/null; then
		shasum -c "${sumfile}" >/dev/null 2>&1
	else
		return 1
	fi
}

function download_and_check() {
	local url="${1:-}"
	local check="${2:-y}"
	if [ -z "${url}" ]; then
		log::error 'empty url'
		return 1
	fi

	local filename=$(basename "${url}")

	if [ -f "${filename}" ]; then
		if [ "${check}" == 'y' ]; then
			# check sha256sum
			download_url "${url}.sha256sum"
			log::log 'checking local tarball...'
			if check_file "${filename}" >/dev/null; then
				log::success 'success'
				return
			fi
			log::warn 'invalid, redownload'
		fi
	fi

	download_url "${url}"
	log::log 'check new file again...'
	check_file "${filename}" || {
		log::error 'Fail'
		return 1
	}

	log::success 'OK'
}

readonly download_and_check

function relink() {
	local top_dir="${1}"
	local nvim_home="${2:-${HOME}}"

	if [ -z "${top_dir}" ]; then
		log::error 'top_dir is required'
		return 1
	fi

	if [ -d "${nvim_home}/${top_dir}" ]; then
		rm -rf "${nvim_home}/${top_dir}" || log::fatal 'remove old dir failed'
	fi

	log::log 'untar...'
	tar -C "${nvim_home}" -xf ${top_dir}.tar.gz >/dev/null
	log::success 'done'

	log::log 'linking...'
	ln -s -f "${nvim_home}/${top_dir}" "${nvim_home}/nvim_home"
	log::success 'done'

	local new_version=$(nvim_version)
	if [ -z "${old_version}" ]; then
		log::success "new nvim %s installed" "${new_version}"
	elif [ "${old_version}" != "${new_version}" ]; then
		log::success "nvim upgraded, %s -> %s" "${old_version}" "${new_version}"
	else
		log::success "nvim %s reinstalled" "${new_version}"
	fi
}

readonly relink

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
	local checksum_url=''

	case "${os_name}" in
	"darwin")
		file_url=$(printf "${RELEASE_URL}" "macos" "tar.gz")
		checksum_url="${file_url}.sha256sum"

		download_and_check "${file_url}" && xattr -c ./nvim-macos.tar.gz
		relink 'nvim-macos'
		;;

	"linux")
		file_url=$(printf "${RELEASE_URL}" "linux64" "tar.gz")
		checksum_url="${file_url}.sha256sum"

		download_and_check "${file_url}" || exit 1
		relink 'nvim-linux64'
		;;

	*)
		log::error "unknown os ${os_name}"
		return 1
		;;
	esac
}

readonly install_nvim

install_nvim "$@" || log::fatal "failed"
