#! /bin/sh 

while getopts :f OPTION
do
    case $OPTION in
	f)
	    doForce=1
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

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

if pullLatestDocker.sh -i $imageName || [ -n "$doForce" ]
then
    docker stop $containerName
    docker rm $containerName
    
    docker run -d --hostname $vhostName --name $containerName -p 8080:15672 -p 5672:5672 -p 61613:61613 -v `pwd`/$DATA_DIR:/var/lib/rabbitmq/mnesia/rabbit@$vhostName --network $network $imageName

    # turn on feature flags.  Not sure why this is needed but avoids warnings messages in the UI
    sleep 15
    ./enableFeatureFlags.sh -c $containerName
else
    echo "image already latest, so no update"
fi

