FROM node:12-stretch
ARG USER=112
ARG GROUP=118
RUN groupadd -g ${GROUP} jenkins
RUN useradd -u ${USER} -g jenkins jenkins
RUN dpkg --add-architecture i386
RUN apt-get install -y ca-certificates libcurl3-gnutls
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN echo 'deb https://dl.winehq.org/wine-builds/debian/ stretch main' >> /etc/apt/sources.list
RUN apt-get update
RUN "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default; \
    chmod 0440 /etc/sudoers.d/default

RUN apt-get install --install-recommends winehq-stable -y
