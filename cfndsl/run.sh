#!/bin/bash
if [ "$1" = "" ]; then
    echo -e "\e[91mPlease pass the stack name. e.g: vpc\e[0m"
    exit 1
fi
touch temp
bundle install --quiet

cfndsl cfndsl/$1.rb -y config/config.yml -y config/dev.yml -p -v -f yaml -o output/$1-dev.yaml

cat temp
rm temp