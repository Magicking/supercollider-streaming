FROM debian:jessie

# Add configuration files
ADD Add-zoom-to-non-ide-Help-Browser.patch /tmp
ADD Change-default-jack-output-to-ffmpeg.patch /tmp
ADD supercollider /src

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install -y \
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
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && cd /tmp/wetty && \
    patch -p1 < /tmp/Change-bin-login-to-usr-bin-bash.patch && \
    npm install && \
    cd / && \
    mv /tmp/wetty /usr/local && \
    chown -R root:root /usr/local/wetty && \
    rm -Rvf /tmp/*

ENV         FFMPEG_VERSION=3.2.2 \
            FDKAAC_VERSION=0.1.4 \
            LAME_VERSION=3.99.5  \
            OGG_VERSION=1.3.2    \
            OPUS_VERSION=1.1.1   \
            YASM_VERSION=1.3.0   \
            VORBIS_VERSION=1.3.5 \
            PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
            SRC=/usr

RUN      buildDeps="autoconf \
                    automake \
                    cmake \
                    curl \
                    bzip2 \
                    g++ \
                    gcc \
                    git \
                    libtool \
                    make \
                    nasm \
                    perl \
                    pkg-config \
                    python \
                    libssl-dev \
                    yasm \
                    zlib1g-dev" && \
        export MAKEFLAGS="-j$(($(nproc) + 1))" && \
        apt-get -yqq update && \
        apt-get install -yq --no-install-recommends ${buildDeps} ca-certificates && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libogg https://www.xiph.org/ogg/
        curl -sL http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --datarootdir=${DIR} && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libopus https://www.opus-codec.org/
        curl -sL http://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libvorbis https://xiph.org/vorbis/
        curl -sL http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
        --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libmp3lame http://lame.sourceforge.net/
        curl -sL https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --enable-nasm --datarootdir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## fdk-aac https://github.com/mstorsjo/fdk-aac
        curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## ffmpeg https://ffmpeg.org/
        curl -sL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --bindir="${SRC}/bin" \
        --disable-doc \
	--disable-static \
	--enable-shared \
	--disable-ffplay \
        --extra-libs=-ldl \
        --enable-version3 \
        --enable-libfdk_aac \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvorbis \
	--enable-gpl \
        --enable-avresample \
        --enable-postproc \
        --enable-nonfree \
        --disable-debug \
        --enable-small \
        --enable-openssl && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR}

EXPOSE 22 80 3000

ENV SC_JACK_DEFAULT_OUTPUTS=ffmpeg
RUN  chsh -s /bin/bash sc
ADD supervisord.ini /etc/supervisor.d/supervisord.ini
RUN mkdir -p /home/sc/.config/SuperCollider/
RUN echo '"SC_JACK_DEFAULT_OUTPUTS".setenv("ffmpeg");' > /home/sc/.config/SuperCollider/startup.scd
ADD run.sh /run.sh

ENTRYPOINT ["/run.sh"]
