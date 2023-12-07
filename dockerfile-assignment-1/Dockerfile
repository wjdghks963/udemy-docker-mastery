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