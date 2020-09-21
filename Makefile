SHELL := /bin/bash # bash syntax is used in packer target
MACHINE_NAME:=dev-machine
ISO_FILE:=$(MACHINE_NAME).iso
UPSTREAM_VERSION:=f33
UPSTREAM_URL:=https://pagure.io/fedora-kickstarts/raw/$(UPSTREAM_VERSION)/f
UPSTREAM_KS_FILES:=fedora-live-workstation.ks fedora-workstation-common.ks fedora-live-base.ks fedora-repo.ks fedora-repo-rawhide.ks

# target to download the ks files from the fedora repo, forms the base for my build
.PHONY: refresh_upstream_kickstarts
refresh_upstream_kickstarts:
	@for file in $(UPSTREAM_KS_FILES) ; do \
		echo -e "# Sourced from $(UPSTREAM_URL)/$$file\n" > $$file; \
		curl --silent -L $(UPSTREAM_URL)/$$file >> $$file; \
	done

# builds the iso when in a fedora environment
$(ISO_FILE):
	livecd-creator --verbose \
		--config=$(MACHINE_NAME).ks \
		--fslabel=$(MACHINE_NAME)  \
		--cache=/var/cache/live

# runs the build on a VM
packer:
	packer validate packer.json
	packer build packer.json || true
	if [[ -f .packer_success ]]; then exit 0; else echo "packer failed" && exit 235; fi

# installs packer for CD runner
install_packer:
	cd $$(mktemp -d)
	curl -LO https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip
	unzip *.zip
	sudo mv packer /usr/local/bin/packer
