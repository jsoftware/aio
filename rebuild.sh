#!/bin/bash
#
# used on cdb desktop to trigger a rebuild

cd `dirname "$(realpath $0)"`

H=`git status | head -1 | cut -d " " -f 3`

if [[ $H == "work" ]]; then
  git checkout master
fi

git pull

M=`head -1 build.txt`
N=`expr $M + 1`
echo -n $N > build.txt

git commit -a -m "rebuild"
git push

git checkout work
git rebase master
