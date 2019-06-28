FROM node:12-alpine
ARG USER=112
ARG GROUP=118
RUN addgroup -g ${GROUP} jenkins
RUN adduser -D -u ${USER} -G jenkins jenkins
RUN apk update
RUN apk add wine
RUN apk add sudo
RUN npm install
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default; \
    chmod 0440 /etc/sudoers.d/default
