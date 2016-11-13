FROM ubuntu:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

# Fix "Couldn't register with accessibility bus" error message
ENV NO_AT_BRIDGE=1

ENV DEBIAN_FRONTEND noninteractive

COPY bin/* /usr/local/bin/

# basic stuff
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf     && \
    apt-get update                                               && \
    apt-get install apt-utils bash build-essential curl dbus-x11    \
      fontconfig git gzip language-pack-en-base make mosh sudo      \
      software-properties-common tar unzip wget                  && \
# su-exec
    git clone https://github.com/ncopa/su-exec.git /tmp/su-exec && \
    cd /tmp/su-exec                                             && \
    make                                                        && \
    mv ./su-exec /usr/local/bin/                                && \
# Emacs
    apt-add-repository ppa:adrozdoff/emacs  && \
    apt-get update                          && \
    apt-get install emacs25 libgl1-mesa-glx && \
# Only for sudoers
    chown root /usr/local/bin/asEnvUser /usr/local/bin/newUserFromEnv && \
    chmod 700  /usr/local/bin/asEnvUser /usr/local/bin/newUserFromEnv && \
# Cleanup
    apt-get purge software-properties-common          && \
    rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

ENV UNAME="emacser"            \
    GNAME="emacsers"           \
    UHOME="/home/emacs"        \
    UID="1000"                 \
    GID="1000"                 \
    WORKSPACE="/mnt/workspace" \
    SHELL="/bin/bash"

WORKDIR "${WORKSPACE}"

ENTRYPOINT ["asEnvUser"]
CMD ["bash", "-c", "emacs; /bin/bash"]
