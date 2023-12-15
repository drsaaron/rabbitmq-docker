#! /bin/sh

imageName=rabbitmq:management
containerName=rabbit

vhostName=my-rabbit
DATA_DIR=data

case $(uname) in
    Linux)
	network=qotd
	;;
    *)
	network=blazarnetwork
esac

[ -d $DATA_DIR ] || mkdir $DATA_DIR

if pullLatestDocker.sh -i $imageName
then
    docker stop $containerName
    docker rm $containerName
    
    docker run -d --hostname $vhostName --name $containerName -p 8080:15672 -p 5672:5672 -v `pwd`/$DATA_DIR:/var/lib/rabbitmq/mnesia/rabbit@$vhostName --network $network $imageName
else
    echo "image already latest, so no update"
fi
