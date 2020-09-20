FROM fedora:32

WORKDIR /build

# needed to run the livecd creator command in the container using make
RUN dnf install --assumeyes livecd-tools make
