TOTAL_STEP="10"
SLEEP_TIME=10

echo '유틸 서버 셋업 시작...'

echo '도커 사용자 이름을 입력 : '
read DOCKER_USER

echo '(1/${TOTAL_STEP}) dnf 업데이트'
dnf update -y

echo '(2/${TOTAL_STEP}) 도커 설치'
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $DOCKER_USER

echo '(3/${TOTAL_STEP}) gitalb 설치'