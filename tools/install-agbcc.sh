#!/bin/bash

here=$(dirname "$(readlink -f "$0")")/..
temp=$(mktemp -d)

agbcc_repo="https://github.com/pret/agbcc.git"
agbcc_branch="master"

git clone $agbcc_repo $temp

cd $temp
git checkout origin/$agbcc_branch

# we need to patch this file to get the correct compiler for this
patch -u gcc/thumb.c -i $here/tools/thumbfix.patch

./build.sh
./install.sh $here

rm -fr $temp
