#!/bin/bash

# Step 1: Docker GitLab 컨테이너에 접속
docker exec -it gitlab /bin/bash

# Step 2: GitLab Rails 콘솔에 접속
PASSWORD_INFO=$(cat /etc/gitlab/initial_root_password | grep ^Password)

echo "ID는 root입니다."
echo "$PASSWORD_INFO"

