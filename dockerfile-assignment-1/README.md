# Instructions for Assignment

[Build Your Own Dockerfile and Run Containers From It](https://www.udemy.com/course/docker-mastery/learn/lecture/6806638)

This directory contains a Node.js app, and you need to get it running in a container.

No modifications to the app should be necessary, only edits to the Dockerfile in this directory.

## Overview of this assignment

- Imagine another developer gave you the instruction below, and you'll need to interpret them into what the Dockerfile should contain.
- Once the Dockerfile builds correctly, start container locally to make sure it works on [http://localhost](http://localhost)
- Then ensure the image is named properly for your Docker Hub account with a new repository name
- Then push to Docker Hub, and go to [https://hub.docker.com](https://hub.docker.com) to verify you pushed it correctly
- Then remove local image from cache (`docker image rm <name>`)
- Then start a new container from your Hub image, and watch how it auto downloads and runs
- Test again that it works at [http://localhost](http://localhost)

## Instructions from the app developer

- you should use the `node` official image, with the alpine 6.x branch (`node:6-alpine`)
  - (Yes this is a 2-year old image of node, but all official images are always available on Docker Hub forever, to ensure even old apps still work. It is common to still need to deploy old app versions, even years later.)
- This app listens on port 3000, but the container should listen on port 80 of the Docker host, so it will respond to [http://localhost:80](http://localhost:80) on your computer
- Then it should use the alpine package manager to install tini: `apk add --no-cache tini`.
- Then it should create directory /usr/src/app for app files with `mkdir -p /usr/src/app`, or with the Dockerfile command `WORKDIR /usr/src/app`.
- Node.js uses a "package manager", so it needs to copy in package.json file.
- Then it needs to run 'npm install' to install dependencies from that file.
- To keep it clean and small, run `npm cache clean --force` after the above, in the same RUN command.
- Then it needs to copy in all files from current directory into the image.
- Then it needs to start the container with the command `/sbin/tini -- node ./bin/www`. Be sure to use JSON array syntax for CMD. (`CMD [ "something", "something" ]`)
- In the end you should be using FROM, RUN, WORKDIR, COPY, EXPOSE, and CMD commands

## Bonus Extra Credit

- This assignment will not have you setting up a complete image useful for local development, test, and prod. It's just meant to get you started with basic Dockerfile concepts and not focus too much on proper Node.js use in a container. **If you happen to be a Node.js Developer**, then after you get through more of this course, you should come back and use my [Node.js Docker Good Defaults](https://github.com/BretFisher/node-docker-good-defaults) sample project on GitHub to change this Dockerfile for better local development with more advanced topics.

```yaml
# node:6-alpine 이미지를 기반으로 새 Docker 이미지를 생성
FROM node:6-alpine

# 컨테이너가 실행될 때 3000번 포트를 외부에 노출
EXPOSE 3000

# 'tini' 설치
RUN apk add --update tini

# /usr/src/app 디렉토리를 생성합니다
RUN mkdir -p /usr/src/app

# 작업 디렉토리를 /usr/src/app으로 설정
WORKDIR /usr/src/app

# 호스트 시스템의 package.json 파일을 컨테이너의 /usr/src/app 디렉토리에 복사
COPY package.json package.json

# npm을 사용하여 의존성을 설치하고 캐시를 정리
RUN npm install && npm cache clean

# 현재 디렉토리(.)의 모든 파일을 컨테이너의 현재 작업 디렉토리(.)로 복사
COPY . .


# 컨테이너가 시작될 때 실행될 명령어
# 'tini'를 사용하여 'node ./bin/www'를 실행
CMD ["tini","--","node","./bin/www"]
```

#### COPY package.json package.json 명령의 사용 이유:

1. 캐시 최적화: package.json 파일만 복사하고 npm install을 실행함으로써, 소스 코드의 다른 부분이 변경되어도 의존성 설치 단계를 캐시에서 재사용할 수 있습니다. package.json 파일이 변경되지 않으면 npm install 단계는 다시 실행되지 않습니다.

2. 빌드 시간 단축: 이 방식은 빌드 시간을 줄이고, 불필요한 의존성 설치를 방지합니다.

#### COPY . . 명령의 사용:

전체 소스 코드 복사: 프로젝트의 나머지 파일들(소스 코드, 기타 리소스 등)이 필요한 경우, COPY . . 명령을 사용하여 전체 내용을 컨테이너에 복사합니다.

결론:
COPY package.json package.json는 의존성 관리를 위해 최적화된 단계로, COPY . .는 프로젝트의 전체 내용을 컨테이너에 복사합니다.
COPY . . 명령어 자체만으로도 package.json을 포함한 모든 파일을 복사할 수 있지만, 캐시 효율성을 높이기 위해 package.json을 먼저 복사하는 것이 일반적인 관행입니다.
