#!/usr/bin/env zsh
# This script generates files with DDNet commands, so you can change entity overlay with mouse scrolling
# Set dryrun to true for not writing any files and just stdout

dryrun=false;
accuracy=5;

text="";

num=$(( 100/accuracy+1 ))
max=$(( 100 - 100 % accuracy ))

for (( current=0; current<=100; current+=$accuracy ));do
    [[ $current == $max ]] && current=100;
    p=$(printf "%03d" $current);
    text="cl_overlay_entities $current\n";
    text+="bind mousewheelup exec b/es/es";
    if [[ $(($current+$accuracy)) -gt 100 ]]; then
        text+="100";
    else
        text+="$(printf "%03d" $(($current+$accuracy)))";
    fi
    text+="\n"
    text+="bind mousewheeldown exec b/es/es";
    if [ $(($current-$accuracy)) -lt 0 ]
       then
        text+="000";
    else
        text+="$(printf "%03d" $(($current-$accuracy)))";
    fi
    text+="\n"
    if [[ $dryrun = true ]]; then
        echo "File: es$p"
        echo -e "$text"
        echo 
    else
        echo -e "$text" > es$p;
    fi
done;

echo "The number of files is $num"