#!/bin/bash

# 변수 설정
CONTAINER_NAME="gitlab"
BACKUP_VOLUME="/storage/gitlab"
BACKUP_DESTINATION="/storage_backup01/$(date +\%Y-\%m-\%d)"

# GitLab 컨테이너를 정지합니다.
docker stop $CONTAINER_NAME

# 볼륨을 백업 디렉토리로 복사합니다.
docker run --rm -v $BACKUP_VOLUME:/source -v $BACKUP_DESTINATION:/destination alpine cp -r /source /destination

# GitLab 컨테이너를 다시 시작합니다.
docker start $CONTAINER_NAME

# 백업 완료 메시지
echo "GitLab 백업이 완료되었습니다. 백업 디렉토리: $BACKUP_DESTINATION"