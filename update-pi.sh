#!/bin/bash
cd `dirname $0`
HOST=$1
if  [ "$HOST" == "" ]; then
 echo $0 version hostname
 echo  e.g. $0 10.0.1.23 will push the current release to the Pi with the IP address 10.0.1.23
 exit 1
fi 

VERSION=`cat .piversion`
if [ "$VERSION" == "" ]; then
 echo ".piversion does not exist, create the configuration first using build-config.sh"
 exit 1
fi

./create-image.sh $VERSION
IMG=`ls images/ | grep updater | grep pi$VERSION | tail -1`
echo "Updating $HOST with $IMG"
sshpass -p 'hifiberry' scp images/$IMG root@$HOST:/data/updater.tar.gz; 
sshpass -p 'hifiberry' ssh root@$HOST /opt/hifiberry/bin/extract-update --reboot

