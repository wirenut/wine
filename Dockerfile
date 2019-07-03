FROM node:12-stretch
ARG USER=112
ARG GROUP=118
RUN groupadd -g ${GROUP} jenkins
RUN useradd -u ${USER} -g jenkins jenkins
RUN apt-get update
RUN dpkg --add-architecture i386
RUN apt-get install -y ca-certificates libcurl3-gnutls apt-transport-https libatomic1 libbsd0 libcurl3 libxml2 tzdata
RUN rm -r /var/lib/apt/lists/*
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key

RUN echo 'deb https://dl.winehq.org/wine-builds/debian/ stretch main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --install-recommends winehq-stable -y
RUN mkdir /home/jenkins
RUN chown -R jenkins:jenkins /home/jenkins

ARG SWIFT_PLATFORM=ubuntu18.04
ARG SWIFT_BRANCH=swift-5.0.1-release
ARG SWIFT_VERSION=swift-5.0.1-RELEASE

ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION

RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && apt-get update \
    && apt-get install -y curl gpg \
    && curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && curl -fSsL $SWIFT_URL.sig -o swift.tar.gz.sig \
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; \
        for key in \
      # pub   4096R/ED3D1561 2019-03-22 [expires: 2021-03-21]
      #       Key fingerprint = A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561
      # uid                  Swift 5.x Release Signing Key <swift-infrastructure@swift.org>
          A62AE125BBBFBB96A6E042EC925CC1CCED3D1561 \
        ; do \
          gpg --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
    && gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 $SWIFT_VERSION-$SWIFT_PLATFORM/usr/lib/swift/linux \
    && apt-get purge -y curl gpg \
    && apt-get -y autoremove \
    && rm -r /var/lib/apt/lists/* \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz \
    && chmod -R o+r /usr/lib/swift
