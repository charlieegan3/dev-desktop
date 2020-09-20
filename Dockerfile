FROM fedora:32

WORKDIR /build

RUN dnf install --assumeyes livecd-tools
RUN dnf install --assumeyes make 
