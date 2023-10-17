Util용 서버 생성용...
1. oraclelinux 설치

2. server-setup.sh 스크립트 실행 (dnf update, docker, gitlab, 기타 설정... 포함)
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/server_setup.sh)"
	
3. gitlab root 계정 패스워드 확인       
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_init.sh)"
	
4. storage 백업 설정
	4-1. 하드디스크를 gnome-disks를 활용하여 마운트해서 filesystem 이름 확인. (예 : /dev/sdb1)
		gnome-disks
	4-2. 재부팅후 자동으로 마운트 되도록 하기 위하여 다음 스크립트를 실행한다  
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/storage_mount.sh /dev/sdb1 /storage_backup01/ )"
	4-3. 백업 스크림드 내려받기
		curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_backup.sh > /storage/backup/gitlab_backup.sh
	4-4. 스케줄러 설정
	- crontab -e 설정 
		. 0 2 * * 3 /storage/backup/gitlab_backup.sh >> /storage/backup/log/$(date +\%Y\%m\%d).out
	4-5. 복원 스크립트 내려받기 & 테스트
		curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/util/gitlab_backup.sh > /storage/backup/gitlab_restore.sh