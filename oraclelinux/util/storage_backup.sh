#!/bin/bash

# GitLab 데이터 디렉토리와 외장 하드 드라이브 마운트 포인트 설정
gitlab_data_dir="/storage/gitlab"
backup_dir="/storage_backup01"

# GitLab 데이터 디렉토리를 외장 하드 드라이브로 백업
rsync -av --delete "$gitlab_data_dir" "$backup_dir"

