FROM node:12-stretch
ARG USER=112
ARG GROUP=118
RUN addgroup -g ${GROUP} jenkins
RUN adduser -D -u ${USER} -G jenkins jenkins
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN sudo apt-key add winehq.key
RUN sudo echo 'deb https://dl.winehq.org/wine-builds/debian/ stretch main' >> /etc/apt/sources.list
RUN sudo apt-get update
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default; \
    chmod 0440 /etc/sudoers.d/default
RUN sudo apt install --install-recommends winehq-stable
