#!/bin/bash
mysqlip=$1
masterip=$2
slaveip=$3

if [ -z $slaveip ]; then
    echo "Watch and failover mysql master to this slave"
    echo "Usage:"
    echo $0 [mysql master IP] [mysql slave ip]
    exit 0
fi

lock="/tmp/takeover-mysql.lock"
exec 201> $lock

if ! flock -n 201 ; then
    echo "ERROR: script already running."
    exit 1
fi

sleep 30

#until $(mysqlrpladmin --master=root:abc123@10.211.55.9 --slaves=root:abc123@10.211.55.10 health|grep -q 'ERROR: Cannot connect to the master server.')
while $(echo "quit"|telnet $masterip 3306 2>&1 |grep -q Connected)
do
    if echo "quit"|telnet $slaveip 3306 2>&1 |grep -q Connected; then
        sleep 10
    else
        # exit if slave server stopeed
        exec 201>&-
        rm -f $lock
        echo "mysql slave $slaveip stopped"
        exit 2
    fi
done

if ping -q -c 3 $mysqlip >/dev/null; then
    echo "ERROR: Mysql cluster address $mysqlip still active on master $masterip"
else
    ifconfig eth0:0 $mysqlip netmask 255.255.255.0 up
fi

echo "stop slave;" | mysql
echo "reset slave all;" | mysql
echo "reset master;" | mysql

exec 201>&-
rm -f $lock
echo "mysql slave $slaveip now is the master database"
