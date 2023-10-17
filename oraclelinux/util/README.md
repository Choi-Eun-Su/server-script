Util용 서버 생성용...
1. oraclelinux 설치
2. server-setup.sh 스크립트 실행       bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/server_setup.sh)"
	- dnf update
	- docker install
	- gitlab container 생성
	- 서버 시작 후, docker & gitlab 등 자동으로 실행
3. gitlab root 계정 패스워드 확인        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_init.sh)"
4. storage 백업 설정
	4-1. 외장하드 마운트
	4-2. 백업 스크림드 내려받기 curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/storage_backup.sh > /storage/backup/storage_backup.sh
	4-3. 스케줄러 설정
	- crontab -e 설정 
		. 0 2 * * 3 /storage/backup/storage_backup.sh >> /storage/backup/log/$(date +\%Y\%m\%d).out

