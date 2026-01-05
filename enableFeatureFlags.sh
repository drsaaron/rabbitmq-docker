#! /bin/sh

while getopts :c: OPTION
do
    case $OPTION in
	c)
	    containerName=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -z "$containerName" ]
then
    echo "container name required" 1>&2
    exit 1
fi

docker exec -it $containerName rabbitmqctl enable_feature_flag all
docker exec -it $containerName rabbitmq-plugins enable rabbitmq_stomp
