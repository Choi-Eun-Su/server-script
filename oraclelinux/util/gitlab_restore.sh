#!/bin/bash

BACKUP_DESTINATION=/storage/gitlab/backups
echo "백업 파일 이름을 입력해주세요"
read FILE_NAME

# gitlab 컨테이너 내부에 있는 psql 셋팅 해줘야함. restore 시, 아래 에러를 없애기 위함임
# ERROR:  must be owner of extension pg_trgm
# ERROR:  must be owner of extension btree_gist
# ERROR:  must be owner of extension btree_gist
# ERROR:  must be owner of extension pg_trgm


# 복원할 백업 파일 경로 지정
# GitLab 컨테이너 내에서 복원 명령 실행
docker exec -it gitlab sh -c "gitlab-ctl stop unicorn"
docker exec -it gitlab sh -c "gitlab-ctl stop puma"
docker exec -it gitlab sh -c "gitlab-ctl stop sidekiq"


docker exec -it gitlab gitlab-backup restore BACKUP=$FILE_NAME  # YYYYMMDD를 복원할 백업 파일의 날짜로 대체
docker cp $BACKUP_DESTINATION/gitlab-secrets.json gitlab:/etc/gitlab/gitlab-secrets.json
docker cp $BACKUP_DESTINATION/gitlab.rb gitlab:/etc/gitlab/gitlab.rb

# 복원 후 GitLab 컨테이너 재시작
docker restart gitlab
