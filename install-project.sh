#!/bin/bash

__DIR__=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

cd $__DIR__

if [ -z "$DINGLE_DEV_START" ] ; then
    source ENV.sh
fi

mkdir -p bin
mkdir -p vendor

if [ -d vendor/p5-app-dingle ] ; then
    ( cd vendor/p5-app-dingle ; git pull --no-rebase)
else
    ( cd vendor; git clone https://github.com/dingle-develop/p5-app-dingle.git)
    ln -sf ../vendor/p5-app-dingle/dingle bin/dingle
fi

bin/dingle sitelib
