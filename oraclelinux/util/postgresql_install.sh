#!/bin/bash

TOTAL_STEP="6"
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