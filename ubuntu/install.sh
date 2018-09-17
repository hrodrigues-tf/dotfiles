#!/bin/bash

for package in `cat inc/ubuntu/apt-packages.list`; do
    running $package
    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" >/dev/null; then
        apt install $package &>>$LOG
        if [ $? != 0 ]; then
            error "failed to install $package! aborting..."
            exit
        fi
    fi
    ok
done

source ubuntu/other-packages.sh

for package in `cat inc/ubuntu/other-packages.list`; do
    running "$package"
    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" >/dev/null; then
        $package
    fi
    ok
done

running "source lists"
apt update -y &>>$LOG
ok

running "dependencies"
apt install -fy &>>$LOG
ok
