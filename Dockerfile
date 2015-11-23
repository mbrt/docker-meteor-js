FROM debian:jessie
MAINTAINER Michele Bertasi

ADD fs/ /

# install pagkages
RUN apt-get update                                                      && \
    apt-get install -y curl locales                                     && \
# fix locale
    locale-gen en_US en_US.UTF-8                                        && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen                         && \
    dpkg-reconfigure -f noninteractive locales                          && \
# add meteor user
    adduser meteor --disabled-password --gecos ""                       && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers     && \
    chown -R meteor:meteor /home/meteor                                 && \
# cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER meteor
ENV HOME=/home/meteor                                                      \
    PATH=$PATH:/home/meteor/.meteor                                        \
    USER=meteor

# install meteor
RUN cd ~                                                                && \
    curl https://install.meteor.com/ | sh                               && \
    mkdir app

VOLUME ["/home/meteor/app"]
WORKDIR /home/meteor/app
EXPOSE 3000
CMD ["meteor"]
