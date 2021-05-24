# This plugin loads plenv into the current shell and provides prompt info via
# the 'plenv_prompt_info' function.

# Load plenv only if command not already available
# FOUND_PLENV=$+commands[plenv]
if command -v plenv &> /dev/null && [[ "$(uname -r)" != *icrosoft* ]]; then
    FOUND_PLENV=1
else
    FOUND_PLENV=0
fi

if [[ $FOUND_PLENV -ne 1 ]]; then
    plenvdirs=("$HOME/.plenv" "/usr/local/plenv" "/opt/plenv" "/usr/local/opt/plenv")
    for dir in $plenvdirs; do
        if [[ -d $dir/bin ]]; then
            export PATH="$dir/bin:$PATH"
            FOUND_PLENV=1
            break
        fi
    done
fi

if [[ $FOUND_PLENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix plenv 2>/dev/null); then
        if [[ -d $dir/bin ]]; then
            export PATH="$dir/bin:$PATH"
            FOUND_PLENV=1
        fi
    fi
fi

if [[ $FOUND_PLENV -eq 1 ]]; then
    eval "$(plenv init --no-rehash - zsh)"

    function current_perl() {
        echo "$(plenv version-name)"
    }

    function plenv_prompt_info() {
        local perl=$(current_perl)
        echo -n "${ZSH_THEME_PERL_PROMPT_PREFIX}"
        echo -n "${perl}"
        echo "${ZSH_THEME_PERL_PROMPT_SUFFIX}"
    }
else
    function current_perl() { echo "not supported" }

    # fallback to system perl
    function plenv_prompt_info() {
        echo -n "${ZSH_THEME_PERL_PROMPT_PREFIX}"
        echo -n "system: $(perl -Mversion -e 'print version->parse($])->normal' 2>&1 )"
        echo "${ZSH_THEME_PERL_PROMPT_SUFFIX}"
    }
fi

unset FOUND_PLENV plenvdirs dir
