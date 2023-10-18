#!/bin/bash

# 1. gnome-disks 활용하여 MOUNT_NAME 체크 후, ... ㄱㄱ
echo -n "MOUNT_NAME : "
read MOUNT_NAME # ex : /dev/sdb1

# 2. 폴더 생성
mkdir -p /storage/backup/log

# 3.마운트 로직은 생략함. 왜냐하면, gitlab 생성 시 볼륨 설정을 위해서 마운트를 미리하였음. 
# bash -c "$(...)"

# 4. 백업 스크립드 내려받기
curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_backup.sh > /storage/backup/gitlab_backup.sh

# 5. 스케줄러 설정
# 원하는 crontab 항목
cron_entry="0 2 * * 3 /storage/backup/gitlab_backup.sh >> /storage/backup/log/$(date +\%Y\%m\%d).out"

# crontab 파일로부터 현재 항목을 읽어옵니다.
existing_cron=$(crontab -l)

# crontab 파일에 항목이 이미 존재하는지 확인
if [[ $existing_cron != *"$cron_entry"* ]]; then
    # 해당 항목이 존재하지 않으면 추가
    (crontab -l; echo "$cron_entry") | crontab -
    echo "Crontab 항목이 추가되었습니다."
else
    echo "Crontab 항목이 이미 존재합니다."
fi

# 6. 복원 스크립트 내려받기 & 테스트
curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_backup.sh > /storage/backup/gitlab_restore.sh
		
# 7. 권한 부여
chmod 777 /storage/backup/*