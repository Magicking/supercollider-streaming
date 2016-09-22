FROM rafaelsoares/archlinux

# Add configuration files
ADD PKGBUILD /
ADD supercollider.install /
ADD authorized_keys /

# Remove default nginx configs.
RUN echo 'Server = http://mirror.archlinux.ikoula.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm binutils git sudo mesa-libgl \
                            fontconfig vim tmux jack2 \
                            openssh xorg-xauth ffmpeg \
                            supervisor && \
    useradd -m makepkg-user && \
    echo 'makepkg-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp PKGBUILD supercollider.install /home/makepkg-user && \
    cd /home/makepkg-user && \
    chown makepkg-user:makepkg-user PKGBUILD supercollider.install && \
    pacman -Sy && sudo -u makepkg-user -- makepkg -i -s --noconfirm && \
    pacman -Scc --noconfirm && \
    rm -Rvf /home/makepkg-user/* /var/cache/packman/pkg/*

RUN /usr/bin/ssh-keygen -A && \
    echo 'X11Forwarding yes' >> /etc/ssh/sshd_config && \
    mkdir /home/makepkg-user/.ssh && \
    cp -v /authorized_keys /home/makepkg-user/.ssh && \
    chown -R makepkg-user:makepkg-user /home/makepkg-user/.ssh

COPY supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 22 80

ENTRYPOINT ["/usr/bin/supervisord"]
