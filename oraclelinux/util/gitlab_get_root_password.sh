#!/bin/bash

# Step 1: Docker GitLab 컨테이너에 접속

# 도커 컨테이너 내부의 파일 경로
container_path="/etc/gitlab/initial_root_password"
container_name="gitlab"

# Step 2: GitLab Rails 콘솔에 접속
PASSWORD_INFO=$(docker exec -it $container_name /bin/bash -c "cat $container_path" | grep ^Password)

echo "ID는 root입니다."
echo "$PASSWORD_INFO"

