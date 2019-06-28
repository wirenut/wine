FROM node:12-stretch
ARG USER=112
ARG GROUP=118
RUN groupadd -g ${GROUP} jenkins
RUN useradd -u ${USER} -g jenkins jenkins
RUN apt-get update
RUN dpkg --add-architecture i386
RUN apt-get install -y ca-certificates libcurl3-gnutls apt-transport-https
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key

RUN echo 'deb https://dl.winehq.org/wine-builds/debian/ stretch main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --install-recommends winehq-stable -y
RUN mkdir /home/jenkins
RUN chown -R jenkins:jenkins /home/jenkins
