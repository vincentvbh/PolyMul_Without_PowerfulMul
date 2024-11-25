
if [[ "$1" != "" ]]; then
    repo_clone=$1
else
    repo_clone=1
fi

if [[ $repo_clone == 1 ]]; then
    git clone https://github.com/libopencm3/libopencm3.git
elif [[ $repo_clone == 2 ]]; then
    git submodule add https://github.com/libopencm3/libopencm3.git
else
    echo "Do nothing\n"
fi

cd libopencm3
git checkout 9545471e4861090a77f79c4458eb19ec771e23d9
cd ../
