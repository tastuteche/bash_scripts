ymdhms_start=`date +%Y-%m-%d_%H_%M_%S`
md5=$(echo "$choice" |md5sum)
bn=$(basename "$choice")
needDelete=0
echo "$ymdhms_start==============================================================================================="
#
pgrep -af "/bash\s+$choice"

#
num=$(pgrep -cf "/bash\s+$choice")
echo "num:$num"
if [[ $num == 0 ]]; then
echo '/bash -c'
pgrep -af "/bash\s+(-c)\s+$choice"
num=$(pgrep -cf "/bash\s+(-c)\s+$choice")
echo "num:$num"
echo "remove blank from ' #!/bin/bash' sh to bash"
exit 1
fi

[[ $num == 1 ]] && needDelete=1
[[ $num == 2 ]] && needDelete=1
echo "needDelete:$needDelete"

if [[ -f "/home/sabayonuser/slib/host/lock/$md5" ]]; then
    echo "lock file exists:/home/sabayonuser/slib/host/lock/$md5"
    if [[ $needDelete == 1 ]]; then
        echo "lock del"
        rm "/home/sabayonuser/slib/host/lock/$md5"
        touch "/home/sabayonuser/slib/host/lock/$md5"
    else
	echo "rm \"/home/sabayonuser/slib/host/lock/$md5\""
    fi 
else
    touch "/home/sabayonuser/slib/host/lock/$md5"
fi
exec 9> "/home/sabayonuser/slib/host/lock/$md5"
if ! flock -n 9  ; then
    echo "another instance is running";
    exit 1
fi
echo "-----------------------------------------------------------------------------------------------"
