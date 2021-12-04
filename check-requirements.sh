#!/bin/bash

errors=0

function checkCommand () {
	local COMMAND=$1 ; shift
    if command -v $COMMAND &> /dev/null
    then
        echo "ok - Command ${COMMAND} is installed."
    else
        echo "not ok - Command ${COMMAND} could not be found"
        ((errors+=1))
    fi 	
}

checkCommand cpanm

if [ $errors == 0 ] ; then
    echo "# Success - environment has the required commands."
    true
else
    echo "Found $errors errrors."
    false
fi


