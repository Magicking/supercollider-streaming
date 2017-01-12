FROM debian:jessie

# Add configuration files
ADD Add-zoom-to-non-ide-Help-Browser.patch /tmp
ADD Change-default-jack-output-to-ffmpeg.patch /tmp
ADD supercollider /src

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libjack-jackd2-dev \
    libcwiid-dev \
    libicu-dev \
    libasound2-dev \
    libsamplerate0-dev \
    libsndfile1-dev \
    libreadline-dev \
    libxt-dev \
    libudev-dev \
    libavahi-client-dev \
    libfftw3-dev \
    cmake \
    build-essential \
    qt5-default \
    qt5-qmake \
    qttools5-dev \
    qttools5-dev-tools \
    qtdeclarative5-dev \
    libqt5webkit5-dev \
    qtpositioning5-dev \
    libqt5sensors5-dev \
    ruby \
    vim \
    emacs \
    tmux \
    openssh-server \
    curl patch iproute2 \
    supervisor xvfb jackd2 
# Remove default nginx configs.
#    pacman -Syu --noconfirm binutils git sudo mesa-libgl \
#                            fontconfig vim tmux jack2 \
#                            openssh xorg-xauth ffmpeg \
#                            supervisor xorg-server-xvfb npm iproute2 && \
#    useradd -m sc && \
#    echo 'sc ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
#    cd /tmp && \
#    chown sc:sc PKGBUILD supercollider.install && \
#    pacman -Sy && sudo -u sc -- /bin/sh -c \
#    "cd /tmp; makepkg -i -s --noconfirm" && \
#    pacman -Scc --noconfirm && \
#    rm -Rvf /tmp/* /var/cache/packman/pkg/*
WORKDIR /src
RUN cmake -DSC_IDE:BOOL=OFF -DCMAKE_BUILD_TYPE=Release && make

ADD Change-bin-login-to-usr-bin-bash.patch /tmp
RUN make install
RUN groupadd -r sc && useradd -r -g sc sc && \
    /usr/bin/ssh-keygen -A && \
    mkdir -p /home/sc/.ssh && \
    touch /home/sc/.ssh/authorized_keys2 && \
    chmod -R 700 /home/sc/.ssh && \
    echo '[ -z ${DISPLAY+x} ] && export DISPLAY=:0' >> /home/sc/.bash_login && \
    echo '[ -z ${TMUX+x} ] && tmux' >> /home/sc/.bash_login && \
    echo 'while [ -z ${TMUX+x} ]; do tmux attach || exit ; done' >> /home/sc/.bash_login && \
    chmod +x /home/sc/.bash_login && \
    chown -R sc:sc /home/sc && \
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config

ADD wetty /tmp/wetty
RUN echo deb http://ftp.debian.org/debian jessie-backports main > /etc/apt/sources.list.d/jessie-bp.list && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs ffmpeg && cd /tmp/wetty && \
    patch -p1 < /tmp/Change-bin-login-to-usr-bin-bash.patch && \
    npm install && \
    cd / && \
    mv /tmp/wetty /usr/local && \
    chown -R root:root /usr/local/wetty && \
    rm -Rvf /tmp/*

RUN apt-get --assume-yes install -y ffmpeg
ADD supervisord.ini /etc/supervisor.d/supervisord.ini
ADD run.sh /run.sh

EXPOSE 22 80 3000

ENTRYPOINT ["/run.sh"]
