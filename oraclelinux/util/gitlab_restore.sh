#!/bin/bash

# 변수 설정
CONTAINER_NAME="gitlab"
BACKUP_VOLUME="/storage/gitlab"
BACKUP_SOURCE="/storage_backup01/YYYY-MM-DD" # 백업 디렉토리를 적절한 날짜로 업데이트

# GitLab 컨테이너를 정지합니다.
docker stop $CONTAINER_NAME

# 백업 디렉토리를 볼륨에 복사합니다.
docker run --rm -v $BACKUP_VOLUME:/destination -v $BACKUP_SOURCE:/source alpine cp -r /source /destination

# GitLab 컨테이너를 다시 시작합니다.
docker start $CONTAINER_NAME

# 복원 완료 메시지
echo "GitLab 복원이 완료되었습니다."
