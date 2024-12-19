# Color Definitions
RESET="%{$reset_color%}"
RED="%F{203}"             # #E07A5F
GREEN="%F{108}"           # #81B29A
YELLOW="%F{227}"          # #F2CC8F
PEACH_YELLOW="%F{223}"    # #EED18D
CADET_GRAY="%F{110}"      # #8DB4C3
ONYX="%F{238}"            # #414141
BEIGE="%F{229}"           # #EFF0CD
PLATINUM="%F{254}"        # #E8E8E8
TIFFANY_BLUE="%F{152}"    # #ACD1C9
POWDER_BLUE="%F{109}"     # #93B0C5
SILVER="%F{250}"          # #C3C3C3
EERIE_BLACK="%F{232}"     # #202020

# Background Colors
BG_ONYX="%K{238}"         # #414141
BG_BEIGE="%K{229}"        # #EFF0CD
BG_EERIE_BLACK="%K{232}"  # #202020
BG_PLATINUM="%K{254}"     # #E8E8E8
BG_RED="%K{203}"          # #E07A5F
BG_GREEN="%K{108}"        # #81B29A
BG_YELLOW="%K{227}"       # #F2CC8F
BG_PEACH_YELLOW="%K{223}" # #EED18D

# Colors for runtimes
BG_RUBY="$BG_RED"        
BG_NODE="$BG_GREEN"     
BG_PYTHON="$BG_YELLOW"      
BG_JAVA="$BG_PEACH_YELLOW"        

# Utils
 os_icon() {
    case "$(uname -s)" in
        Darwin)
            echo 
            ;;
        Linux)
            echo 
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo 
            ;;
        *)
            echo 
            ;;
    esac
}

get_shell_type() {
    local shell_name=$(echo ${$(ps -p $$ -o comm=)/-/})
    echo $shell_name;
}

format_path() {
    local formatted_path=$(echo "$PWD" | sed -e "s|^$HOME| $PLATINUM$RESET |" -e "s|/| $POWDER_BLUE»$RESET |g")
    echo "${POWDER_BLUE}[$formatted_path ${POWDER_BLUE}]${RESET}"
}

# Function to calculate the length of a prompt string
prompt_length() {
  emulate -L zsh
  local -i COLUMNS=${2:-COLUMNS}
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g REPLY=$x
}

# Function to fill the line dynamically
fill_line() {
    emulate -L zsh
    prompt_length $1
    local -i left_len=REPLY
    prompt_length $2 9999
    local -i right_len=REPLY
    local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
    if (( pad_len < 1 )); then
        typeset -g REPLY=$1  # Drop right-side content if insufficient space
    else
        local pad=${(pl.$pad_len.. .)}  # pad_len spaces
        typeset -g REPLY=${1}${pad}${2}
    fi
}

# Prompt Components
os_icon_block() {
  echo "${BG_EERIE_BLACK}${PLATINUM} $(os_icon) ${RESET}"
}

shell_type_block() {
  echo "${BG_PLATINUM} ${ONYX} $(get_shell_type) ${RESET}"
}
git_block() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
        local git_status=$(git status --porcelain=v2 2>/dev/null)
        local branch_status=""
        
        if echo "$git_status" | grep -q "^1 "; then
            branch_status="${BG_RED}${ONYX} ! " # Changes in working directory
        fi
        if echo "$git_status" | grep -q "^2 "; then
            branch_status="${branch_status}${BG_GREEN}${ONYX} + " # Changes staged for commit
        fi
        if git stash list | grep -q "stash@"; then
            branch_status="${branch_status}${BG_YELLOW}${ONYX} S " # Stashed changes
        fi

        echo "${BG_BEIGE}${EERIE_BLACK}  ${branch} ${branch_status}${RESET}"
    else
        echo ""
    fi
}

current_user_block() {
    local user_icon=" "
    local user=$(whoami)
    local host=$(hostname)

    echo "${BG_PEACH_YELLOW}${EERIE_BLACK} ${user_icon}${user}@${host} ${RESET}"
}

runtime_block() {
    local tool_versions_file=".tool-versions"
    local runtime_line=""
    local output=""

    # Cache the file path to avoid repeated 'find' calls
    if [[ -z $RUNTIME_FILE_PATH || ! -f $RUNTIME_FILE_PATH ]]; then
        RUNTIME_FILE_PATH=$(find . -maxdepth 5 -name "$tool_versions_file" -print -quit 2>/dev/null)
    fi

    if [[ -f "$RUNTIME_FILE_PATH" ]]; then
        while read -r runtime version; do
            version=$(echo "$version" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
            [[ -z "$version" ]] && continue
            case "$runtime" in
                nodejs) runtime_line="${BG_NODE}${EERIE_BLACK}  ${version} ${RESET}" ;;
                ruby) runtime_line="${BG_RUBY}${EERIE_BLACK}   ${version} ${RESET}" ;;
                python) runtime_line="${BG_PYTHON}${EERIE_BLACK}  ${version} ${RESET}" ;;
                java) runtime_line="${BG_JAVA}${EERIE_BLACK}  ${version} ${RESET}" ;;
                *) continue ;;
            esac
            output+="${runtime_line}"
        done < "$RUNTIME_FILE_PATH"
    fi

    [[ -n "$output" ]] && echo -n "${output}┐" || echo ""
}

cursor_block() {
  echo "${TIFFANY_BLUE}› ${RESET}"
}

precmd() {
    local top_left="┌$(os_icon_block)$(shell_type_block)$(current_user_block)$(git_block)"
    local top_right="$(runtime_block)"

    local left_middle="└$(format_path)"
    local right_middle=""
    [[ -n "$top_right" ]] && right_middle=" ─┘"

    local bottom_left="$(cursor_block)"

    local top_line middle_line
    fill_line "$top_left" "$top_right"
    top_line=$REPLY

    fill_line "$left_middle" "$right_middle"
    middle_line=$REPLY

    PROMPT=$'%{\n%}'"${top_line}"$'%{\n%}'"${middle_line}"$'\n'${bottom_left}
}

# Redraw the prompt when the terminal is resized
TRAPWINCH() {
    zle && zle reset-prompt
}
