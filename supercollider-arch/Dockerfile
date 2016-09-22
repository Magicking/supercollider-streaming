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
                            supervisor && \
    useradd -m sc && \
    echo 'sc ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cd /tmp && \
    chown sc:sc PKGBUILD supercollider.install && \
    pacman -Sy && sudo -u sc -- /bin/sh -c \
    "cd /tmp; makepkg -i -s --noconfirm" && \
    pacman -Scc --noconfirm && \
    rm -Rvf /tmp/* /var/cache/packman/pkg/*

RUN /usr/bin/ssh-keygen -A && \
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config && \
    mkdir /home/sc/.ssh && \
    cp -v /authorized_keys /home/sc/.ssh && \
    chown -R sc:sc /home/sc/.ssh

COPY supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 22 80

ENTRYPOINT ["/usr/bin/supervisord"]
