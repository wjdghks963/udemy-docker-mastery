#! /bin/sh

# backend용 overlay 생성
docker network create -d overlay backend

# frontend용 overlay 생성
docker network create -d overlay frontend

# vote service 80:80 네트워크 생성하고 fontend overlay에 부착, bretfisher/examplevotingapp_vote 이미지로 2개의 복제본 생성
docker service create --name vote -p 80:80 --network frontend --replicas 2 bretfisher/examplevotingapp_vote

# redis service fontend overlay에 부착, redis:3.2 이미지로 생성
docker service create --name redis --network frontend redis:3.2

# db service backend overlay에 부착, env 설정, 타입과 경로를 지정하고 mount하고 postgres:9.4 이미지로 생성
docker service create --name db --network backend -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4

# worker service fontend,backend overlay에 부착, bretfisher/examplevotingapp_worker 이미지로 생성
docker service create --name worker --network frontend --network backend bretfisher/examplevotingapp_worker

# result service backend overlay에 부착, 5001:80로 포트연결 후 bretfisher/examplevotingapp_result 이미지로 생성
docker service create --name result --network backend -p 5001:80 bretfisher/examplevotingapp_result
