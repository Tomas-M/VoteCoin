#!/usr/bin/env bash

# tested

cd "$(dirname "$(readlink -f "$0")")"    #'"%#@!

sudo dnf install \
      git pkgconfig automake autoconf ncurses-devel python \
      python-zmq wget gtest-devel gcc gcc-c++ libtool patch \
      glibc-static libstdc++-static make cmake git pkgconfig


./fetch-params.sh || exit 1

./build.sh --disable-tests --disable-mining -j$(nproc) || exit 1

if [ ! -r ~/.votecoin/votecoin.conf ]; then
   mkdir -p ~/.votecoin
   echo "addnode=mainnet.votecoin.site" >~/.votecoin/votecoin.conf
   echo "rpcuser=username" >>~/.votecoin/votecoin.conf
   echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.votecoin/votecoin.conf
fi

cd ../src/
strip --strip-unneeded zcashd
strip --strip-unneeded zcash-cli
strip --strip-unneeded zcash-tx

cp -f zcashd votecoind
cp -f zcash-cli votecoin-cli
cp -f zcash-tx votecoin-tx

printf "\n"
printf "--------------------------------------------------------------------------\n"
printf "Compilation complete. Now you can run ../src/votecoind to start the daemon.\n"
printf "It will use configuration file from ~/.votecoin/votecoin.conf\n"
printf "\n"
