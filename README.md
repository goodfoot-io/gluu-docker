docker stop nginx_sfs; docker rm nginx_sfs;
docker stop prometheus; docker rm prometheus;

docker build -t gluuprometheus ~/Projects/gluu/gluu-cluster/gluuprometheus
docker build -t nginx_sfs ~/Projects/gluu/gluu-cluster/gluunginxsfs

docker network create -d bridge gluu-master
docker run --name nginx_sfs -p 9001:80 --net=gluu-master gluunginxsfs
docker run --net=gluu-master --name=prometheus gluuprometheus
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /etc/docker:/etc/docker/ --net=gluu-master --name=api -p 8080:8080 -t gluuapi
