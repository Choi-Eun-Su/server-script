Util용 서버 생성용...
1. oraclelinux 설치
2. server-setup.sh 스크립트 실행       bash -c "$(curl -fsSL https://raw.githubusercontent.com/Choi-Eun-Su/server-script/master/oraclelinux/server-setup.sh)"
	- dnf update
	- docker install
	- gitlab container 생성
	- 서버 시작 후, docker & gitlab 등 자동으로 실행
3. gitlab 계정생성. 아이디 및 ... 여러 값은 직접 입력해야함...
4. storage 백업을 위한 script 실행