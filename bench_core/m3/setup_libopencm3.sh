#!/bin/bash

if [[ "$1" != "" ]]; then
    repo_clone=$1
else
    repo_clone=1
fi

if [[ "$2" != "" ]]; then
    commit_hash=$2
else
    commit_hash=9545471e4861090a77f79c4458eb19ec771e23d9
fi

if [[ $repo_clone == 1 ]]; then
    rm -rf libopencm3
    git clone https://github.com/libopencm3/libopencm3.git
elif [[ $repo_clone == 2 ]]; then
    git submodule add https://github.com/libopencm3/libopencm3.git
else
    echo "Do nothing\n"
fi

cd libopencm3
git checkout $commit_hash
cd ../

ln -s ../libopencm3 fnt/libopencm3
ln -s ../libopencm3 ntt/libopencm3
ln -s ../libopencm3 Nussbaumer/libopencm3
