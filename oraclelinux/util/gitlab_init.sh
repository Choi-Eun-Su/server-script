#!/bin/bash

# 사용자 입력 받기
read -p "이름을 입력하세요: " NAME
read -p "이메일을 입력하세요: " EMAIL
read -p "비밀번호를 입력하세요: " PASSOWRD
read -p "비밀번호를 한번 더 입력하세요: " CONFIRMED_PASSOWRD

# 비밀번호와 확인 비밀번호 비교
if [ "$PASSWORD" != "$CONFIRMED_PASSWORD" ]; then
    echo "비밀번호와 확인 비밀번호가 일치하지 않습니다."
    exit 1
fi

# Step 1: Docker GitLab 컨테이너에 접속
docker exec -it gitlab /bin/bash

# Step 2: GitLab Rails 콘솔에 접속
gitlab-rails console

# Step 3: 명령어 입력
u = User.new({ username: '$NAME', email: '$EMAIL', name: '$NAME', admin: true, password: '$PASSOWRD', password_confirmation: '$CONFIRMED_PASSOWRD' })
u.skip_confirmation!
u.save!

# Step 4: GitLab 콘솔에서 나오기
exit

# Step 5: 서버 재시작
sudo gitlab-ctl restart