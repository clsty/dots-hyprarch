#!/usr/bin/env bash

cd $(dirname $0)
base=$(pwd)

export TEXTDOMAINDIR=$base/mo
gettext -s 'Greeting'
