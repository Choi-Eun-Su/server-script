#!/bin/bash

# 추가할 텍스트를 정의합니다.
# echo -n "입력: "
# read STORAGE_NAME

STORAGE_NAME=/dev/sdb1
new_content="$STORAGE_NAME /storage_backup01/ ext4 defaults 0 0"

# 기존 파일의 내용을 변수에 저장합니다.
existing_content=$(cat /etc/fstab)

# 추가할 내용이 이미 파일에 존재하는지 확인합니다.
if [[ $existing_content == *"$new_content"* ]]; then
    echo "추가할 내용이 이미 파일에 존재합니다. 추가하지 않습니다."
else
    # 기존 내용에 추가할 내용을 더하고 파일에 덮어씁니다.
    echo -e "$existing_content\n$new_content" > /etc/fstab
    echo "새로운 내용을 추가했습니다."
fi

mount -a

echo "마운트 완료!!"
echo -e "명령어를 활용하여 정상적으로 마운트 되었는지 확인해주세요\n\n"