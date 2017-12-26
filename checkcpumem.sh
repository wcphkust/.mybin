#!/bin/bash
#
# script checking CPU and memory utilization by user
#
#

var="";

while getopts "hcm" OPTION; do
case $OPTION in

c)
     var="-k 2 -r"
     ;;

m)
     var="-k 3 -r"
     ;;

h)
     echo "Usage:"
     echo "checkcpumem.sh -h "
     echo "checkcpumem.sh -c "
     echo "checkcpumem.sh -m "
     echo ""
     echo " -h show this help"
     echo " -c order by CPU usage, default by username"
     echo " -m order by memory usage, default by username"
     exit 0
     ;;

esac
done

# first line of tab
echo ""
echo -e "user\t\tCPU\tMEM"

# main loop
for user in `ps -eo uname:20,pid,pcpu,pmem,sz,tty,stat,time,cmd | grep -v UID | awk '{print $1}'| sort | uniq`;
do
     if [ $user == "USER" ]; then
           continue
     fi
     top -b -n 1 -u $user | awk -v var="$user" 'NR>7 { sumC += $9; }; { sumM += $10; } END { print var "\t\t" sumC "\t" sumM; }';
done | sort -n `echo $var`
