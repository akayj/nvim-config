#!/usr/bin/env bash

# shellcheck disable=SC2034

# Reset
readonly Color_Off='\033[0m' # Text Reset

# Regular Colors
readonly Black='\033[0;30m'  # Black
readonly Red="\033[0;31m"    # Red
readonly Green='\033[0;32m'  # Green
readonly Yellow="\033[0;33m" # Yellow
readonly Blue='\033[0;34m'   # Blue
readonly Purple='\033[0;35m' # Purple
readonly Cyan='\033[0;36m'   # Cyan
readonly White='\033[0;37m'  # White

# Bold
readonly BBlack='\033[1;30m'  # Black
readonly BRed='\033[1;31m'    # Red
readonly BGreen='\033[1;32m'  # Green
readonly BYellow='\033[1;33m' # Yellow
readonly BBlue='\033[1;34m'   # Blue
readonly BPurple='\033[1;35m' # Purple
readonly BCyan='\033[1;36m'   # Cyan
readonly BWhite='\033[1;37m'  # White

# Underline
readonly UBlack='\033[4;30m'  # Black
readonly URed='\033[4;31m'    # Red
readonly UGreen='\033[4;32m'  # Green
readonly UYellow='\033[4;33m' # Yellow
readonly UBlue='\033[4;34m'   # Blue
readonly UPurple='\033[4;35m' # Purple
readonly UCyan='\033[4;36m'   # Cyan
readonly UWhite='\033[4;37m'  # White

# Background
readonly On_Black='\033[40m'  # Black
readonly On_Red='\033[41m'    # Red
readonly On_Green='\033[42m'  # Green
readonly On_Yellow='\033[43m' # Yellow
readonly On_Blue='\033[44m'   # Blue
readonly On_Purple='\033[45m' # Purple
readonly On_Cyan='\033[46m'   # Cyan
readonly On_White='\033[47m'  # White

# High Intensity
readonly IBlack='\033[0;90m'  # Black
readonly IRed='\033[0;91m'    # Red
readonly IGreen='\033[0;92m'  # Green
readonly IYellow='\033[0;93m' # Yellow
readonly IBlue='\033[0;94m'   # Blue
readonly IPurple='\033[0;95m' # Purple
readonly ICyan='\033[0;96m'   # Cyan
readonly IWhite='\033[0;97m'  # White

# Bold High Intensity
readonly BIBlack='\033[1;90m'  # Black
readonly BIRed='\033[1;91m'    # Red
readonly BIGreen='\033[1;92m'  # Green
readonly BIYellow='\033[1;93m' # Yellow
readonly BIBlue='\033[1;94m'   # Blue
readonly BIPurple='\033[1;95m' # Purple
readonly BICyan='\033[1;96m'   # Cyan
readonly BIWhite='\033[1;97m'  # White

# High Intensity backgrounds
readonly On_IBlack='\033[0;100m'  # Black
readonly On_IRed='\033[0;101m'    # Red
readonly On_IGreen='\033[0;102m'  # Green
readonly On_IYellow='\033[0;103m' # Yellow
readonly On_IBlue='\033[0;104m'   # Blue
readonly On_IPurple='\033[0;105m' # Purple
readonly On_ICyan='\033[0;106m'   # Cyan
readonly On_IWhite='\033[0;107m'  # White
