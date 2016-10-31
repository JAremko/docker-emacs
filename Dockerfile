FROM ubuntu:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV XPRA_URL="https://www.xpra.org/dists/xenial/\
main/binary-amd64/xpra_0.17.6-r14318-1_amd64.deb"        \
    SCP_URL="https://github.com/adobe-fonts/\
source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz"      \
    NNG_URL="http://www.ffonts.net/NanumGothic.font.zip" \
    DEBIAN_FRONTEND=noninteractive

# basic stuff
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf  && \
    apt-get update                                            && \
    apt-get install apt-utils bash curl dbus-x11 fontconfig      \
      git gzip language-pack-en-base make mosh openssh-server    \
      sudo software-properties-common tar unzip wget          && \
    dpkg-reconfigure locales                                  && \
# xpra
    apt-get install libssl-dev python-dbus python-dev         \
      python-gst-1.0 python-pip python-pkg-resources          \
      xserver-xorg-video-dummy                             && \
    cd /tmp/ && curl -o /tmp/xpra.deb "${XPRA_URL}"        && \
    apt install ./xpra.deb                                 && \
    rm /tmp/xpra.deb                                       && \
    pip install cryptography pycrypto netifaces websockify && \
# fonts
    mkdir -p /usr/local/share/fonts                           && \
    wget -qO- "${SCP_URL}" | tar xz -C /usr/local/share/fonts && \
    wget -O /tmp/nngfont.zip "${NNG_URL}"                     && \
    unzip /tmp/nngfont.zip -d /usr/local/share/fonts          && \
    fc-cache -fv                                              && \
# Emacs
    apt-add-repository ppa:adrozdoff/emacs && \
    apt-get update                         && \
    apt-get install emacs25                && \
# Cleanup
    apt-get purge libssl-dev python-dev python-pip       \
    software-properties-common unzip                  && \
    rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

COPY bin/* /usr/local/bin/

ENV UNAME="root"                  \
    GNAME="root"                  \
    UHOME="/root"                 \
    UID="0"                       \
    GID="0"                       \
    WORKSPACE="/mnt/workspace"    \
    SHELL="/bin/bash"             \
    SSHD_PORT="22"                \
    MOSH_PORT_RANGE="60000-61000" \
    XPRA_DISPLAY=":14"            \
    XPRA_SHARING="yes"            \
    XPRA_ENCODING="rgb"           \
    XPRA_MMAP="yes"               \
    XPRA_KEYBOARD_SYNC="yes"      \
    XPRA_COMPRESS="0"             \
    XPRA_HTML_PORT="10000"        \
    XPRA_DPI="0"                  \
    XORG_DPI="96"                 \
    SDMODE="normal"

EXPOSE 22 8080 $XPRA_HTML_PORT $MOSH_PORT_RANGE

ENTRYPOINT ["/usr/local/bin/sdboot"]
