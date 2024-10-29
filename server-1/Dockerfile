# Ubuntu 기반 이미지 사용
FROM ubuntu:latest
 
# 환경 업데이트 및 필요한 패키지 설치
RUN apt -y upgrade
RUN apt -y update && apt install -y sudo
RUN apt install -y openssh-server locales 
RUN rm -rf /var/lib/apt/lists/* 
 
# 로케일 설정
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
 
# SSH 서버 설정
RUN mkdir /var/run/sshd
 
# SSH 로그인을 위한 사용자 추가 (예: 사용자명 user, 비밀번호 userpassword)
RUN useradd -rm -d /home/user1 -s /bin/bash -g root -G sudo -u 1001 user1
RUN echo 'user1:df159357' | chpasswd
 
# SSH 서버 설정 변경: 비밀번호 인증 허용
RUN sed -i 's/#\?PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
 
# Sudo 설정
RUN chmod 640 /etc/sudoers
RUN sed -i '47iuser1 ALL=(ALL:ALL) ALL' /etc/sudoers
 
# SSH 서비스 포트 (기본: 22)
EXPOSE 22
 
# 컨테이너 시작 시 SSH 서비스 실행
CMD ["/usr/sbin/sshd", "-D"]