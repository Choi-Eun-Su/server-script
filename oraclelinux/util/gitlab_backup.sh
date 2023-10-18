#!/bin/bash

# 현재 날짜를 가져옴 (예: 20231017)
BACKUP_DESTINATION=/storage/gitlab/backups

# GitLab 컨테이너 내에서 백업 명령 실행
docker exec -t gitlab gitlab-backup create

# 설정파일도 백업
docker cp gitlab:/etc/gitlab/gitlab-secrets.json $BACKUP_DESTINATION/gitlab-secrets.json
docker cp gitlab:/etc/gitlab/gitlab.rb $BACKUP_DESTINATION/gitlab.rb



# 백업 파일이 4개 이상이면, 가장 오래된 tar 파일 삭제함

# .tar 파일 목록 가져오기
tar_files=("$BACKUP_DESTINATION"/*.tar)

# .tar 파일 수 확인
file_count=${#tar_files[@]}

if [ $file_count -le 3 ]; then
    echo "해당 폴더에 .tar 파일이 3개 이하로 존재합니다. 아무 파일도 삭제하지 않습니다."
else
    # .tar 파일을 파일 수정 시간을 기준으로 정렬
    sorted_tar_files=($(ls -t "$BACKUP_DESTINATION"/*.tar))

    # 가장 오래된 파일 선택
    oldest_tar_file="${sorted_tar_files[-1]}"

    # 선택된 파일 삭제
    rm "$oldest_tar_file"
    echo "가장 오래된 .tar 파일 \"$oldest_tar_file\"가 삭제되었습니다."
fi
~
~
