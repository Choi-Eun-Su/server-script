#!/bin/bash

TOTAL_STEP=2
CURRENT_STEP=1
SLEEP_TIME=3

echo "$SLEEP_TIME초 뒤, 유틸 서버 셋업 시작..."
sleep $SLEEP_TIME

MOUNT_FOLDER=/postgresql/data


echo -e "($CURRENT_STEP/$TOTAL_STEP) mount 폴더 생성 시작"

if [ ! -d "$MOUNT_FOLDER" ]; then
    mkdir -p "$MOUNT_FOLDER"
    echo "Postgresql MOUNT 폴더 생성 완료!"
else
    echo "Postgresql MOUNT 폴더는 이미 존재합니다."
fi

echo -e "($CURRENT_STEP/$TOTAL_STEP) dnf 업데이트 완료!\n"
CURRENT_STEP=$CURRENT_STEP+1






POSTGRESQL_PASSWORD=anotherone123!
POSTGRESQL_CONTAINER_NAME=postgres-container

echo -e "($CURRENT_STEP/$TOTAL_STEP) postgresql 도커 컨테이너 생성 시작"


if docker ps -a --format '{{.Names}}' | grep -q "^$POSTGRESQL_CONTAINER_NAME\$"; then
    echo "Postgresql 컨테이너가 이미 설치되어 있습니다. 설치를 건너뜁니다."
else
	docker run \
		--name $POSTGRESQL_CONTAINER_NAME \
		-e POSTGRES_PASSWORD=$POSTGRESQL_PASSWORD \
		-d -p 5432:5432 \
		-v $MOUNT_FOLDER:/var/lib/postgresql/data postgres:latest
	
	echo "postgresql 도커 컨테이너 생성 및 초기화를 위하여 1분간 대기중..."
    sleep 60

    echo "postgresql 도커 컨테이너 생성 및 초기화 완료!!"
fi


echo -e "($CURRENT_STEP/$TOTAL_STEP) postgresql 도커 컨테이너 생성 완료!\n"
CURRENT_STEP=$CURRENT_STEP+1



echo -e "($CURRENT_STEP/$TOTAL_STEP) 서버 재부팅 시 postgresql 자동 실행 설정 시작"
file_name="/etc/systemd/system/docker-postgresql.service"
new_content=$(cat <<EOF
[Unit]
Description=Docker and PostgreSQL Service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/docker start postgres-container

[Install]
WantedBy=multi-user.target
EOF
)

echo "$new_content" > "$file_name"
sudo systemctl enable docker-postgresql
echo -e "($CURRENT_STEP/$TOTAL_STEP) 서버 재부팅 시 postgresql 자동 실행 설정 완료\n"
$CURRENT_STEP=$CURRENT_STEP+1