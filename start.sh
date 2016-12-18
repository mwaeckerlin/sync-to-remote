#!/bin/bash

if test -z "${FROM}" -o -z "${TO}"; then
    echo "**** ERROR: please specify source an target as FROM and TO" 1>&2
    exit 1
fi

if ! test -f ~/.ssh/id_rsa.pub; then
    if test -n "${SSH_PUBKEY}" -a -n "${SSH_PRIVKEY}"; then
        test -d ~/.ssh || mkdir ~/.ssh
        echo "${SSH_PUBKEY}" > ~/.ssh/id_rsa.pub
        echo "${SSH_PRIVKEY}" > ~/.ssh/id_rsa
        chmod go= ~/.ssh/id_rsa
    else
        echo | ssh-keygen -qb ${KEYSIZE} -N ""; echo;
    fi
    echo "*** SSH-Public-Key:"
    cat ~/.ssh/id_rsa.pub
    sleep 120
fi

echo "==== synchronize"
rsync -aq --delete "${FROM}" "${TO}"

echo "==== starting service"
while true; do
    inotifywait -r --format='%w%f' -e modify,attrib,move,create,delete ${FROM} |
        while read p; do
            if test -f "$p"; then
                scp -r "$p" "${p//${FROM//\//\\/}/${TO}}"
            else
                rsync -aq --delete "${FROM}" "${TO}"
            fi
        done
done
