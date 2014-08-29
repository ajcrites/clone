#!/bin/bash
if [ ! -f $HOME/.ssh/id_rsa ]; then
    echo "Please set up your SSH keys with Github before cloning"
    exit
fi

git clone $@

if [ -n "$2" ]; then
    cd $2
else
    DIR=${1##*/}
    cd ${DIR%.git}
fi

if [ -f .fire/pre-install ]; then
    echo
    /bin/bash .fire/pre-install
    echo
fi

# npm install recursively
for f in $(find . -name package.json | grep -v node_modules | sed 's@/package.json@@'); do
    npm install --prefix $f
done

if [ -f .fire/post-install ]; then
    echo
    /bin/bash .fire/post-install
    echo
fi
