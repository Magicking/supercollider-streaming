FROM rafaelsoares/archlinux

# Add configuration files
ADD PKGBUILD /tmp
ADD supercollider.install /tmp
ADD Add-zoom-to-non-ide-Help-Browser.patch /tmp
ADD Change-default-jack-output-to-ffmpeg.patch /tmp
ADD authorized_keys /

# Remove default nginx configs.
RUN echo 'Server = http://mirror.archlinux.ikoula.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm binutils git sudo mesa-libgl \
                            fontconfig vim tmux jack2 \
                            openssh xorg-xauth ffmpeg \
                            supervisor xorg-server-xvfb npm && \
    useradd -m sc && \
    echo 'sc ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cd /tmp && \
    chown sc:sc PKGBUILD supercollider.install && \
    pacman -Sy && sudo -u sc -- /bin/sh -c \
    "cd /tmp; makepkg -i -s --noconfirm" && \
    pacman -Scc --noconfirm && \
    rm -Rvf /tmp/* /var/cache/packman/pkg/*

ADD Change-bin-login-to-usr-bin-bash.patch /tmp

RUN /usr/bin/ssh-keygen -A && \
    echo '[ -z ${DISPLAY+x} ] && export DISPLAY=:0' >> /home/sc/.bashrc && \
    echo '[ -z ${TMUX+x} ] && tmux' >> /home/sc/.bashrc && \
    echo 'while [ -z ${TMUX+x} ]; do tmux attach || exit ; done' >> /home/sc/.bashrc && \
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config && \
    mkdir /home/sc/.ssh && \
    cp -v /authorized_keys /home/sc/.ssh && \
    chown -R sc:sc /home/sc/.ssh && \
    sudo -u sc git clone https://github.com/krishnasrinivas/wetty /tmp/wetty && \
    cd /tmp/wetty && \
    git apply /tmp/Change-bin-login-to-usr-bin-bash.patch && \
    sudo -u sc npm install && \
    cd / && \
    mv /tmp/wetty /usr/local && \
    chown -R root:root /usr/local/wetty && \
    rm -Rvf /tmp/*

ADD supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 22 80 3000

ENTRYPOINT ["/usr/bin/supervisord"]
