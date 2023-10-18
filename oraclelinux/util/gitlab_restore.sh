#!/bin/bash

BACKUP_DESTINATION=/storage/gitlab/backups
echo -n "백업 파일 이름 : "
read FILE_NAME
FILE_NAME_PREFIX=$(echo "$FILE_NAME" | sed 's/_gitlab_backup\.tar.*//')



# Gitlab 컨테이너 내부에 있는 psql 셋팅 해줘야함. restore 시, 아래 에러를 없애기 위함임
# ERROR:  must be owner of extension pg_trgm
# ERROR:  must be owner of extension btree_gist
# ERROR:  must be owner of extension btree_gist
# ERROR:  must be owner of extension pg_trgm

# Gitlab 관련 서비스 중지
docker exec -it gitlab sh -c "gitlab-ctl stop unicorn"
docker exec -it gitlab sh -c "gitlab-ctl stop puma"
docker exec -it gitlab sh -c "gitlab-ctl stop sidekiq"


# GitLab restore start
chmod 777 $BACKUP_DESTINATION/*
docker exec -it gitlab gitlab-backup restore BACKUP=$FILE_NAME_PREFIX
docker cp $BACKUP_DESTINATION/gitlab-secrets.json gitlab:/etc/gitlab/gitlab-secrets.json
docker cp $BACKUP_DESTINATION/gitlab.rb gitlab:/etc/gitlab/gitlab.rb

# 복원 후 GitLab 컨테이너 재시작
docker restart gitlab
