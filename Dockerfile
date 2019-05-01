FROM ubuntu:16.04

MAINTAINER tenten

# デフォルトのshellを変更
SHELL ["/bin/bash", "-c"]

# packageのupdate
RUN apt-get update

# packageのupgrage
RUN apt-get -y upgrade && \
apt-get -f install

# 言語を日本仕様に
RUN apt-get install -y language-pack-ja-base language-pack-ja && \
update-locale LANG=ja_JP.utf8 LANGUAGE=ja_JP.utf8 LC_ALL=ja_JP.utf8 && \
source /etc/default/locale && \
apt-get install -y man manpages-ja manpages-ja-dev
ENV LANG=ja_JP.UTF-8

# 必要なモジュールをインストール
## apt-get編
RUN apt-get install -y make vim bash-completion git git-flow tmux curl wget\
    nkf ctags openssh-server xorg openbox python3 python3-pip python-opencv uvccapture guvcview cheese

## pip編（pipだとPython2に入っちゃうぽい）
RUN pip3 install numpy opencv-python

## curlとかwgetで頑張る編（不要なのでコメントアウト）
#RUN echo '==========composerのインストール==========' && \
#curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin && \
#echo '==========nodebrewのインストール==========' && \
#curl -L git.io/nodebrew | perl - setup && \
#export PATH=$HOME/.nodebrew/current/bin:$PATH && \
#nodebrew -v && \
#export NODEBREW_ROOT=$HOME/.nodebrew && \
#echo '==========nodeのインストール==========' && \
#nodebrew install-binary stable && \
#nodebrew use stable && \
#node -v

## 設定ファイルの作成
RUN cp /usr/share/bash-completion/completions/git-flow /etc/bash_completion.d

## .bashrcに色々書いてく...（不要箇所が多そうなのでコメントアウト）
#RUN echo "export GOROOT=~/go" >> ~/.bashrc
#RUN echo "export NODEBREW_ROOT=~/.nodebrew" >> ~/.bashrc
#RUN echo "export PATH=$PATH:/usr/local/bin/go/bin:$GOROOT/bin:~/.nodebrew/current/bin" >> ~/.bashrc
#RUN echo "export PS1='[\[\033[0;34m\]\u@\h \W\[\033[0m\]]$ '" >> ~/.bashrc
#RUN echo "if [ -f /etc/bash_completion ] && ! shopt -oq posix; then" >> ~/.bashrc
#RUN echo "    . /etc/bash_completion" >> ~/.bashrc
#RUN echo "fi" >> ~/.bashrc
#RUN source ~/.bashrc

# 環境変数の指定
ENV DISPLAY 192.168.11.57:10.0

# sshの設定（https://qiita.com/YumaInaura/items/1d5c18a9e55484ccad89）

RUN mkdir /var/run/sshd
RUN echo 'root:hoge' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# 参考（https://qiita.com/sey323/items/8cb10f90889a6d911cd4）
#
#FROM python:3.6
#
#RUN pip3 install numpy opencv-python
#
# ここまで

#ipは192.168.11.57:10.0

# 使い方
#
## buildコマンド
### docker build -t my-env:1.0 [Dockerfile-DirPath]
## もしくは
### docker-compose up -d --build
## コンテナ起動コマンドサンプル
### docker run -itd -p 2022:22 -v [source-dir]:/source --name my-env my-env:1.0 