#!/usr/bin/env bash

errors=0

function checkCommand () {
    local COMMAND=$1 ; shift
    if command -v $COMMAND &> /dev/null
    then
        echo "ok - Command ${COMMAND} is installed."
        return 0
    else
        echo "not ok - Command ${COMMAND} could not be found"
        ((errors+=1))
        return 1
    fi 	
}

function helpCpanminus () {
    if [ -f /etc/pacman.conf ] ; then
        echo "# Maybe you can install missing command with 'pacman -S cpanminus'."
    else
        echo "# Maybe you can install missing command with 'cpan -i App::cpanminus'"
    fi 
}

checkCommand perl
checkCommand cpanm || helpCpanminus
checkCommand git
checkCommand make

if [ $errors == 0 ] ; then
    echo "# Success - environment has the required commands."
    true
else
    echo "Found $errors errrors."
    false
fi


