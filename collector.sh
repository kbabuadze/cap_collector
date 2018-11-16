#!/bin/bash

# Set time for the foldername and create Folder

t_now=$(date +"%d%m%y-%H%M")
pcapdir=/home/dumps/dumpcap/pcap_"$t_now"
mkdir $pcapdir


# Set dumpcap filter and run dumpcap

filter="not (tcp port 22 and ip host 10.10.10.10)"

/usr/local/bin/dumpcap -i eno1 -f "$filter"  -b filesize:1000 -a duration:300 -w $pcapdir"/cap".pcapng


# Compress collected traces after 5 minutes
cd $pcapdir
tar -cf dumps_"$t_now".tar *
gzip dumps_"$t_now".tar
rm -Rf cap*

# Remove last folder if dumpcap directory is more the 100 MB

size=$(du -B1 /home/dumps/dumpcap | tail -1 | cut -f1  )
if [ $size -gt 100000000 ];then
        rm -rf "/home/dumps/dumpcap/"$(ls -t /home/dumps/dumpcap/ | tail -1 | cut -f1 | grep -v .sh)
fi
