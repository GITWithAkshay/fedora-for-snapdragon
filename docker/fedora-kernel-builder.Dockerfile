FROM fedora:43

RUN dnf -y upgrade --refresh \
    && dnf -y install \
        bc \
        bison \
        diffutils \
        dtc \
        dwarves \
        elfutils-libelf-devel \
        file \
        findutils \
        flex \
        gawk \
        gcc \
        git \
        grep \
        gzip \
        hostname \
        make \
        ncurses-devel \
        openssl-devel \
        patch \
        perl \
        python3 \
        rsync \
        tar \
        which \
        xz \
    && dnf clean all

WORKDIR /workspace
