# Load rbw only if command not already available
if command -v rbw &> /dev/null && [[ "$(uname -r)" != *icrosoft* ]]; then
    FOUND_RBW=1
else
    FOUND_RBW=0
fi

if [[ $FOUND_RBW -ne 1 ]]; then
    rbwdirs=("${HOME}/.rbw" "/usr/local/rbw" "/opt/rbw" "/usr/local/opt/rbw")
    for dir in ${rbwdirs}; do
        if [[ -d ${dir}/bin ]]; then
            export PATH="${dir}/bin:${PATH}"
            FOUND_RBW=1
            break
        fi
    done
fi

if [[ $FOUND_RBW -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix rbw 2>/dev/null); then
        if [[ -d ${dir}/bin ]]; then
            export PATH="${dir}/bin:${PATH}"
            FOUND_RBW=1
        fi
    fi
fi

if [[ $FOUND_RBW -eq 1 ]]; then
    function set_rbw_config() {
        [[ -n "${RBW_EMAIL}" ]] && rbw config set email ${RBW_EMAIL}
        [[ -n "${RBW_BASE_URL}" ]] && rbw config set base_url ${RBW_BASE_URL}
        [[ -n "${RBW_IDENTITY_URL}" ]] && rbw config set identity_url ${RBW_IDENTITY_URL}
        [[ -n "${RBW_LOCK_TIMEOUT}" ]] && rbw config set lock_timeout ${RBW_LOCK_TIMEOUT}
        [[ -n "${RBW_PINENTRY}" ]] && rbw config set pinentry ${RBW_PINENTRY}
    }

    rbw config show &> /dev/null || set_rbw_config
fi

unset FOUND_RBW rbwdirs dir
