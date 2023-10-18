#!/bin/bash

# 현재 날짜를 가져옴 (예: 20231017)
BACKUP_DESTINATION=/storage/gitlab/backups

# GitLab 컨테이너 내에서 백업 명령 실행
docker exec -t gitlab gitlab-backup create

# 설정파일도 백업
docker cp gitlab:/etc/gitlab/gitlab-secrets.json $BACKUP_DESTINATION/gitlab-secrets.json
docker cp gitlab:/etc/gitlab/gitlab.rb $BACKUP_DESTINATION/gitlab.rb

# 백업 파일을 일정 기간 이상 보관하려면 추가 작업 필요
# 예를 들어, 일주일 이상된 백업 파일을 삭제하는 로직을 추가할 수 있음
~
~
~
~
