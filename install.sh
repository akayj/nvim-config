#!/usr/bin/env bash

set -euo pipefail

echo '----------------------------------------'
echo '--------- Install nvim binary ----------'
echo '----------------------------------------'

readonly RELEASE_URL='https://github.com/neovim/neovim/releases/download/nightly/'

readonly WHITE='37' # white
# readonly Red='31'       # Red
readonly Purple='35'    # Purple
readonly BRed='1;31'    # Red
readonly BGreen='32'    # Green
readonly BYellow='0;33' # Yellow
readonly BBlue='1;34'   # Blue

function expand_color() {
  local colors="${1:-${WHITE}}"

  echo "${colors}" | awk -F ';' '{ if ($2 == "") print 0";"$1; else print $1";"$2; }'
}

function color_message() {
  local color
  color=$(expand_color "$1")
  shift

  local template="$1"
  shift

  if [ -t 1 ]; then
    printf "\e[%sm$template\e[0m" "${color}" "$@"
  else
    printf "$template" "$@"
  fi
}

function log::log() { color_message '' "$@"; }

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

declare curl_version=""

function set_curl_version() {
  if [ -z "${curl_version}" ]; then
    curl_version="$(curl -V | head -n 1 | cut -d ' ' -f 2)"
    readonly curl_version
  fi
}

function https_curl() {
  set_curl_version

  if [[ $(echo "${curl_version} 7.20.0" | awk '{print ($1 > $2)}') -eq 1 ]]; then
    curl --proto '=https' --tlsv1.2 "$@"
  else
    curl --tlsv1.2 "$@"
  fi
}

function retrive_file() {
  local url="${1:-}"

  if [ -z "${url}" ]; then
    log::error 'url is empty'
    return 1
  fi

  https_curl --progress-bar -fLO "${url}"
}

function nvim_version() {
  local home_dir="${1:-}"
  local nvim_bin
  if [ -z "${home_dir}" ]; then
    nvim_bin="nvim"
  else
    nvim_bin="${home_dir}/bin/nvim"
  fi

  if command -v "${nvim_bin}" >/dev/null || [ -x "${nvim_bin}" ]; then
    "${nvim_bin}" -v | head -n 1 | awk '{print $2}'
    # "$nvim_bin" -v | awk '/^NVIM/{v=$2} /^Lua/{print v, "(" $0 ")"}'
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

  local filename
  filename=$(basename "${url}")

  if [ ! -f "${filename}" ]; then
    log::log 'downlading %s...' "${filename}"
    retrive_file "${url}" >/dev/null || return 1
    log::success 'OK'
  else
    log::debug "Found local tarball"
    log::info "  %s" $(realpath ${filename})
    read -rp "use it ? [Y/n]: " -s -n1 Yn
    case "${Yn}" in
    [Nn]*)
      log::error "${Yn}"
      log::debug 'download new tarball...'
      # retrive_file "${url}" >/dev/null 2>&1 || {
      retrive_file "${url}" || {
        log::error 'Fail'
        return 2
      }
      log::success 'OK'
      ;;

    *)
      log::success "${Yn}"
      log::info 'Use local tarball'
      ;;
    esac
  fi

  if [ "${check}" == 'y' ]; then
    log::log 'Fetching latest sha256sum file...'
    retrive_file "${url}.sha256sum" >/dev/null 2>&1 || { log::error 'failed'; return 1; }
    log::success 'done'

    log::log 'Checking sha256sum...'
    if check_file "${filename}" >/dev/null; then
      log::success 'ok'
      return
    fi
    log::error 'fail'
    return 1
  fi
}

function relink() {
  local top_dir="${1}"
  local nvim_home="${2:-${HOME}}"
  local old_version

  if [ -z "${top_dir}" ]; then
    log::error 'top_dir is required'
    return 1
  fi

  old_version=$(nvim_version "${nvim_home}/nvim_home")
  if [ -d "${nvim_home}/${top_dir}" ]; then
    rm -rf "${nvim_home:?}/${top_dir}" || log::fatal 'remove old dir failed'
  fi

  log::log 'untar...'
  tar -C "${nvim_home}" -xf "${top_dir}.tar.gz" >/dev/null
  log::success 'done'

  log::log 'linking...'
  ln -s -f "${nvim_home}/${top_dir}" "${nvim_home}/nvim_home"
  log::success 'done'

  local new_version=$(nvim_version "${nvim_home}/nvim_home")
  if [ -z "${old_version}" ]; then
    log::success "new nvim %s installed" "${new_version}"
  elif [ "${old_version}" != "${new_version}" ]; then
    log::success "nvim upgraded, %s -> %s" "${old_version}" "${new_version}"
  else
    log::success "nvim %s reinstalled" "${new_version}"
  fi
}

function current_shell_rc() {
  local current_shell
  current_shell=$(basename "$SHELL")

  case ${current_shell} in
  "zsh")
    echo "${HOME}/.zshrc"
    ;;

  "bash")
    echo "${HOME}/.bashrc"
    ;;
  esac
}

function install_nvim() {
  local force="${1:-}"
  local old_version

  old_version=$(nvim_version)

  if [ "${old_version}" != "" ]; then
    log::success "nvim %s was installed" "${old_version}"
    if [ "${force}" != "-f" ]; then
      return
    fi
  fi

  local os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
  local file_url

  case "${os_name}" in
  "darwin")
    file_url=$(printf "${RELEASE_URL}/nvim-%s-%s.%s" "macos" "$(uname -m)" "tar.gz")

    download_and_check "${file_url}" || exit 1
    xattr -c ./nvim-macos.tar.gz && relink 'nvim-macos'
    ;;

  "linux")
    file_url=$(printf "${RELEASE_URL}/nvim-%s.%s" "linux64" "tar.gz")

    download_and_check "${file_url}" || exit 1
    relink 'nvim-linux64'
    ;;

  *)
    log::error "unknown os ${os_name}"
    return 1
    ;;
  esac
}

[ -d "${HOME}/.config/nvim" ] || {
  git clone https://github.com/NvChad/NvChad.git ~/.config/nvim --depth=1
}

[ -d "${HOME}/.config/nvim/lua/custom" ] || {
  git clone https://github.com/akayj/nvim-config.git ~/.config/nvim/lua/custom --depth=1
}

install_nvim "$@" || log::fatal "failed"

if [ -z "$(nvim_version)" ]; then
  log::info 'If this is your first time to install, update PATH for nvim, or else ignore this:'
  log::success '  echo "export PATH=$PATH:%s" >> %s' "${HOME}/nvim_home/bin" "$(current_shell_rc)"
fi
