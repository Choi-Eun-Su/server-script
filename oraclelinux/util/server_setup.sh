#!/bin/bash

TOTAL_STEP="5"
SLEEP_TIME=10

echo '5초 뒤, 유틸 서버 셋업 시작...'
sleep 5






echo "(1/$TOTAL_STEP) dnf 업데이트 시작"
if dnf list installed &> /dev/null; then
    echo "시스템 업데이트를 이미 수행했습니다. 업데이트를 건너뜁니다."
else
	dnf update -y
fi

echo "(1/$TOTAL_STEP) dnf 업데이트 완료!"








echo "(2/$TOTAL_STEP) 도커 설치 시작"
# Check if Docker is already installed
if ! command -v docker &> /dev/null; then
    dnf install -y dnf-utils zip unzip
	dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
	
	dnf remove -y runc
	dnf install -y docker-ce --nobest
	
    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker
    
    echo "Docker has been installed and started."
else
    echo "Docker is already installed. Skipping installation."
fi

echo "(2/$TOTAL_STEP) 도커 설치 완료!"







echo "(3/$TOTAL_STEP) GitLab 설치 시작"

GITLAB_CONTAINER_NAME=gitlab
GITLAB_VOLUME_DIR=/storage/gitlab
GITLAB_IMAGE=gitlab/gitlab-ce:latest

# 폴더가 존재하지 않는 경우 생성
if [ ! -d "$GITLAB_VOLUME_DIR" ]; then
    mkdir -p "$GITLAB_VOLUME_DIR/logs"
    mkdir -p "$GITLAB_VOLUME_DIR/config"
    mkdir -p "$GITLAB_VOLUME_DIR/data"
    echo "GITLAB 폴더가 생성되었습니다."
else
    echo "GITLAB 폴더는 이미 존재합니다."
fi

if docker ps -a --format '{{.Names}}' | grep -q "^$GITLAB_CONTAINER_NAME\$"; then
    echo "GitLab 컨테이너가 이미 설치되어 있습니다. GitLab 설치를 건너뜁니다."
else
    # GitLab 컨테이너 실행하기 위한 변수 설정
    GITLAB_PORT=80
    GITLAB_HTTPS_PORT=443
    GITLAB_SSH_PORT=23

    # GitLab 컨테이너 실행
    echo "GitLab 컨테이너 실행 중..."
    docker run --detach \
        --publish $GITLAB_HTTPS_PORT:443 --publish $GITLAB_PORT:80 --publish $GITLAB_SSH_PORT:22 \
        --name $GITLAB_CONTAINER_NAME \
        --volume $GITLAB_VOLUME_DIR/config:/etc/gitlab \
        --volume $GITLAB_VOLUME_DIR/logs:/var/log/gitlab \
        --volume $GITLAB_VOLUME_DIR/data:/var/opt/gitlab \
        $GITLAB_IMAGE

    # GitLab 초기 설정을 위한 대기
    echo "GitLab 컨테이너가 실행 중입니다. 초기 설정을 위해 60초를 기다려주세요..."
    sleep 60

    # GitLab 초기 설정
    sudo -u $DOCKER_USER docker exec -it $GITLAB_CONTAINER_NAME gitlab-ctl reconfigure

    echo "GitLab이 설정되었습니다."
fi

echo "(3/$TOTAL_STEP) GitLab 설치 완료"





echo "(4/$TOTAL_STEP) 방화벽 stop 및 자동 실행 제거"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask firewalld
echo "(4/$TOTAL_STEP) 방화벽 stop 및 자동 실행 제거 완료"





echo "(5/$TOTAL_STEP) 방화벽 stop 및 자동 실행 제거"
file_name="/etc/systemd/system/docker-gitlab.service"
new_content=$(cat <<EOF
[Unit]
Description=Docker and GitLab Service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/docker start -a gitlab

[Install]
WantedBy=multi-user.target
EOF
)

echo "$new_content" > "$file_name"
sudo systemctl enable docker-gitlab
echo "(5/$TOTAL_STEP) 방화벽 stop 및 자동 실행 제거 완료"


echo "(6/$TOTAL_STEP) 백업 디렉토리 생성 시작"
mkdir -p /storage/backup/log
echo "(6/$TOTAL_STEP) 백업 디렉토리 생성 완료"





echo "설치가 완료되었습니다"
echo "1. 스토리지 백업 정책을 셋팅해주세요"
echo "2. 재부팅후 정상 동작하는지 확인해주세요"
