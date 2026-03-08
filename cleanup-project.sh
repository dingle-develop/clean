#!/bin/bash

__DIR__=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

cd $__DIR__

if [ -z "$DINGLE_DEV_START" ] ; then
    source ENV.sh
fi

[ -L bin/dingle ] && rm -f bin/dingle

rm -rf sitelib
