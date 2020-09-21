SHELL := /bin/bash # bash syntax is used in packer target
MACHINE_NAME:=dev-desktop
SHA:=$(shell git rev-parse --short HEAD)
FS_LABEL:=$(MACHINE_NAME)-$(SHA)
ISO_FILE:=$(FS_LABEL).iso
UPSTREAM_VERSION:=f33
UPSTREAM_URL:=https://pagure.io/fedora-kickstarts/raw/$(UPSTREAM_VERSION)/f
UPSTREAM_KS_FILES:=fedora-live-workstation.ks fedora-workstation-common.ks fedora-live-base.ks fedora-repo.ks fedora-repo-rawhide.ks

all: install_build_deps $(ISO_FILE) upload

# targets for running on the build, local or on remote instance via build.sh
# target to download the ks files from the fedora repo, forms the base for my build
.PHONY: refresh_upstream_kickstarts
refresh_upstream_kickstarts:
	@for file in $(UPSTREAM_KS_FILES) ; do \
		echo -e "# Sourced from $(UPSTREAM_URL)/$$file\n" > $$file; \
		curl --silent -L $(UPSTREAM_URL)/$$file >> $$file; \
	done

# builds the iso when in a fedora environment
$(ISO_FILE):
	echo Building $(ISO_FILE) # to show the name is set right before building
	livecd-creator --verbose \
		--config=$(MACHINE_NAME).ks \
		--fslabel=$(FS_LABEL)  \
		--cache=/var/cache/live

# upload the image to dropbox
.PHONY: upload
upload:
	rclone --config=rclone.conf \
		copy ./$(ISO_FILE) dropbox:/Archive

.PHONY: install_build_debs
install_build_deps:
	# - livecd-tools in order to build the iso
	# - rclone to upload the image
	dnf install --assumeyes livecd-tools rclone

# targets for GH actions, used to run on the remote instance
# runs the build on a VM
.PHONY: packer
packer: install_packer
	packer validate packer.json
	packer build packer.json || true
	if [[ -f .packer_success ]]; then exit 0; else echo "packer failed" && exit 235; fi

# installs packer for CD runner
.PHONY: install_packer
install_packer:
	cd $$(mktemp -d)
	curl -LO https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip
	unzip *.zip
	sudo mv packer /usr/local/bin/packer
