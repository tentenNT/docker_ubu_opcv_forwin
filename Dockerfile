FROM ubuntu:16.04

MAINTAINER tenten

# �f�t�H���g��shell��ύX
SHELL ["/bin/bash", "-c"]

# package��update
RUN apt-get update

# package��upgrage
RUN apt-get -y upgrade && \
apt-get -f install

# �������{�d�l��
RUN apt-get install -y language-pack-ja-base language-pack-ja && \
update-locale LANG=ja_JP.utf8 LANGUAGE=ja_JP.utf8 LC_ALL=ja_JP.utf8 && \
source /etc/default/locale && \
apt-get install -y man manpages-ja manpages-ja-dev
ENV LANG=ja_JP.UTF-8

# �K�v�ȃ��W���[�����C���X�g�[��
## apt-get��
RUN apt-get install -y make vim bash-completion git git-flow tmux curl wget\
    nkf ctags openssh-server xorg openbox python3 python3-pip python-opencv uvccapture guvcview cheese

## pip�ҁipip����Python2�ɓ������Ⴄ�ۂ��j
RUN pip3 install numpy opencv-python

## curl�Ƃ�wget�Ŋ撣��ҁi�s�v�Ȃ̂ŃR�����g�A�E�g�j
#RUN echo '==========composer�̃C���X�g�[��==========' && \
#curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin && \
#echo '==========nodebrew�̃C���X�g�[��==========' && \
#curl -L git.io/nodebrew | perl - setup && \
#export PATH=$HOME/.nodebrew/current/bin:$PATH && \
#nodebrew -v && \
#export NODEBREW_ROOT=$HOME/.nodebrew && \
#echo '==========node�̃C���X�g�[��==========' && \
#nodebrew install-binary stable && \
#nodebrew use stable && \
#node -v

## �ݒ�t�@�C���̍쐬
RUN cp /usr/share/bash-completion/completions/git-flow /etc/bash_completion.d

## .bashrc�ɐF�X�����Ă�...�i�s�v�ӏ����������Ȃ̂ŃR�����g�A�E�g�j
#RUN echo "export GOROOT=~/go" >> ~/.bashrc
#RUN echo "export NODEBREW_ROOT=~/.nodebrew" >> ~/.bashrc
#RUN echo "export PATH=$PATH:/usr/local/bin/go/bin:$GOROOT/bin:~/.nodebrew/current/bin" >> ~/.bashrc
#RUN echo "export PS1='[\[\033[0;34m\]\u@\h \W\[\033[0m\]]$ '" >> ~/.bashrc
#RUN echo "if [ -f /etc/bash_completion ] && ! shopt -oq posix; then" >> ~/.bashrc
#RUN echo "    . /etc/bash_completion" >> ~/.bashrc
#RUN echo "fi" >> ~/.bashrc
#RUN source ~/.bashrc

# ���ϐ��̎w��
ENV DISPLAY 192.168.11.57:10.0

# ssh�̐ݒ�ihttps://qiita.com/YumaInaura/items/1d5c18a9e55484ccad89�j

RUN mkdir /var/run/sshd
RUN echo 'root:hoge' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# �Q�l�ihttps://qiita.com/sey323/items/8cb10f90889a6d911cd4�j
#
#FROM python:3.6
#
#RUN pip3 install numpy opencv-python
#
# �����܂�

#ip��192.168.11.57:10.0

# �g����
#
## build�R�}���h
### docker build -t my-env:1.0 [Dockerfile-DirPath]
## ��������
### docker-compose up -d --build
## �R���e�i�N���R�}���h�T���v��
### docker run -itd -p 2022:22 -v [source-dir]:/source --name my-env my-env:1.0 