TOTAL_STEP="10"
SLEEP_TIME=10

echo '유틸 서버 셋업 시작...'

echo '도커 사용자 이름을 입력 : '
read DOCKER_USER

echo '(1/${TOTAL_STEP}) dnf 업데이트 시작'
dnf update -y
echo '(1/${TOTAL_STEP}) dnf 업데이트 완료!'





echo '(2/${TOTAL_STEP}) 도커 설치 시작'

if [ -z "$DOCKER_USER" ]; then
  echo "사용자명을 제공해야 합니다."
  exit 1
fi

# 도커 설치
sudo dnf install -y docker
# 도커 서비스 시작 및 활성화
sudo systemctl start docker
sudo systemctl enable docker
# Docker 그룹 생성 (이미 있는 경우에는 생략 가능)
sudo groupadd docker
# 사용자를 Docker 그룹에 추가
sudo usermod -aG docker $DOCKER_USER
# 사용자 변경 내용 적용
su - $DOCKER_USER
echo "Docker가 설치되었고, $DOCKER_USER 사용자가 Docker 그룹에 추가되었습니다."

echo '(2/${TOTAL_STEP}) 도커 설치 완료!'




echo '(3/${TOTAL_STEP}) gitalb 설치'