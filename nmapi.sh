#!/bin/bash
#
# File:      nmapi
#
# Purpose:   Continuous monitoring of open TCP port
#            Based on pingi https://gist.github.com/brunobraga/7259197
#            Requires nmap and bc
#
# Author:    BBK <beanbagking@gmail.com>
#
# Copyright:
#
#            Licensed under the Apache License, Version 2.0 (the "License");
#            you may not use this file except in compliance with the License.
#            You may obtain a copy of the License at
#
#            http://www.apache.org/licenses/LICENSE-2.0
#
#            Unless required by applicable law or agreed to in writing, software
#            distributed under the License is distributed on an "AS IS" BASIS,
#            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#            implied. See the License for the specific language governing
#            permissions and limitations under the License.
#

host=$1
port=$2

if [ -z $host ]; then
    echo "Usage: `basename $0` [HOST] [PORT]"
    exit 1
fi

if [ -z $host ]; then
    echo "Usage: `basename $0` [HOST] [PORT]"
    exit 1
fi

while :; do
    start_time=$(date +%s.%3N)
    result=`nmap -PR -Pn -n -T5 --reason -p $port $host | grep 'open '`
    if [ $? -gt 0 ]; then
        echo -e "`date +'%Y/%m/%d %H:%M:%S'` - service $host:$port is \033[0;31mdown\033[0m"
    else
        echo -e "`date +'%Y/%m/%d %H:%M:%S'` - service $host:$port is \033[0;32mok\033[0m - `echo $result | cut -d ':' -f 2`"
    fi
    end_time=$(date +%s.%3N)
    elapsed=$(echo "$end_time - $start_time" | bc -l )
    time_diff=$(echo "1 - $elapsed" | bc -l )
    sleep $time_diff
done
