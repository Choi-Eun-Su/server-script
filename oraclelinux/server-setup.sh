TOTAL_STEP="10"
SLEEP_TIME=10

echo '유틸 서버 셋업 시작...'

echo '2.도커 사용자 이름을 입력 : '
read DOCKER_USER

echo '3-1. gitlab 볼륨 폴더 경로 : '
read GITLAB_VOLUME_DIR
echo '3-2. GITLAB HOSTNAME : '
read GITLAB_HOSTNAME

echo '(1/${TOTAL_STEP}) dnf 업데이트 시작'
if dnf list installed &> /dev/null; then
    echo "시스템 업데이트를 이미 수행했습니다. 업데이트를 건너뜁니다."
else
	dnf update -y
echo '(1/${TOTAL_STEP}) dnf 업데이트 완료!'





echo '(2/${TOTAL_STEP}) 도커 설치 시작'

if ! command -v docker &> /dev/null; then
    echo "Docker가 이미 설치되어 있습니다. 도커 설치를 건너뜁니다."
else
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




echo '(3/${TOTAL_STEP}) gitalb 설치 시작'

GITLAB_CONTAINER_NAME=gitlab
if docker ps -a --format '{{.Names}}' | grep -q "^$GITLAB_CONTAINER_NAME\$"; then
    echo "GitLab 컨테이너가 이미 설치되어 있습니다. GitLab 설치를 건너뜁니다."
else
	# GitLab 컨테이너를 실행하기 위한 변수 설정
	GITLAB_PORT=80
	GITLAB_HTTPS_PORT=443
	GITLAB_SSH_PORT=22
	# GITLAB_VOLUME_DIR=/storage/gitlab
	# GITLAB_HOSTNAME=gitlab.example.com
	GITLAB_IMAGE=gitlab/gitlab-ce:latest
	
	# Docker를 설치
	echo "Docker 설치 중..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	sudo usermod -aG docker $USER
	rm get-docker.sh
	
	# Docker 서비스 시작 및 활성화
	sudo systemctl start docker
	sudo systemctl enable docker
	
	# GitLab 컨테이너 실행
	echo "GitLab 컨테이너 실행 중..."
	docker run --detach \
	  --hostname $GITLAB_HOSTNAME \
	  --publish $GITLAB_HTTPS_PORT:443 --publish $GITLAB_PORT:80 --publish $GITLAB_SSH_PORT:22 \
	  --name $GITLAB_CONTAINER_NAME \
	  --restart always \
	  --volume $GITLAB_VOLUME_DIR/config:/etc/gitlab \
	  --volume $GITLAB_VOLUME_DIR/logs:/var/log/gitlab \
	  --volume $GITLAB_VOLUME_DIR/data:/var/opt/gitlab \
	  $GITLAB_IMAGE
	
	# GitLab 초기 설정을 위한 대기
	echo "GitLab 컨테이너가 실행 중입니다. 초기 설정을 위해 잠시 기다려주세요..."
	sleep 60
	
	# GitLab 초기 설정
	docker exec -it $GITLAB_CONTAINER_NAME gitlab-ctl reconfigure
	
	# GitLab 컨테이너 다시 시작
	docker restart $GITLAB_CONTAINER_NAME
	
	echo "GitLab이 설정되었습니다. 웹 브라우저에서 http://$GITLAB_HOSTNAME 에서 액세스하세요."
	
echo '(3/${TOTAL_STEP}) gitalb 설치 완료'