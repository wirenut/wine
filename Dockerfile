FROM node:12-alpine
ARG USER
ARG GROUP
RUN addgroup -g ${GROUP} jenkins
RUN adduser -D -u ${USER} -G jenkins jenkins
RUN apk update
RUN apk add wine
RUN apk add sudo
