```sh
docker network create -d bridge gluu-master

docker run --net=gluu-master --name nginx_sfs -p 9001:80 gluunginxsfs
docker run --net=gluu-master --name=prometheus gluuprometheus
docker run --net=gluu-master --name=api -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v /etc/docker:/etc/docker/ gluuapi
```

```
HOSTNAME=$(docker exec api hostname -f)
DOCKER_HOST_IP=$(docker-machine ip)
ADMIN_PASSWORD=$(date |md5 | head -c8; echo)
echo "The admin password is $ADMIN_PASSWORD"
CLUSTER_ID=$(curl -XPOST --silent http://$DOCKER_HOST_IP:8080/clusters \
    -d name=goodfoot-io \
    -d org_name=goodfoot-io \
    -d org_short_name=goodfoot-io \
    -d city=New\ York \
    -d state=NY \
    -d country_code=US \
    -d admin_email='hello@goodfoot.io' \
    -d ox_cluster_hostname=localhost \
    -d weave_ip_network=10.32.0.0/12 \
    -d admin_pw=$ADMIN_PASSWORD | grep "\"id\"" | sed -e 's/^.*"id"[ ]*:[ ]*"//' -e 's/".*//')
MASTER_PROVIDER_ID=$(curl -XPOST --silent http://$DOCKER_HOST_IP:8080/providers \
    -d hostname=$HOSTNAME \
    -d docker_base_url=https://$DOCKER_HOST_IP:2376 \
    -d type=master \
    -d cluster_id=$CLUSTER_ID | grep "\"id\"" | sed -e 's/^.*"id"[ ]*:[ ]*"//' -e 's/".*//')
```

```
curl http://$DOCKER_HOST_IP:8080/nodes \
    -d provider_id=$MASTER_PROVIDER_ID \
    -d cluster_id=$CLUSTER_ID \
    -d node_type=oxtrust
```

```
curl -XPOST http://$DOCKER_HOST_IP:8080/nodes \
    -d provider_id=$MASTER_PROVIDER_ID \
    -d cluster_id=$CLUSTER_ID \
    -d node_type=oxauth
```