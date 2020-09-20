MACHINE_NAME:=dev-machine
UPSTREAM_VERSION:=f33
UPSTREAM_URL:=https://pagure.io/fedora-kickstarts/raw/$(UPSTREAM_VERSION)/f
UPSTREAM_KS_FILES:=fedora-live-workstation.ks fedora-workstation-common.ks fedora-live-base.ks fedora-repo.ks fedora-repo-not-rawhide.ks
DOCKER_TAG:=build-$(shell git rev-parse --short HEAD)

# target to download the ks files from the fedora repo, forms the base for my build
.PHONY: refresh_upstream_kickstarts
refresh_upstream_kickstarts:
	@for file in $(UPSTREAM_KS_FILES) ; do \
		echo -e "# Sourced from $(UPSTREAM_URL)/$$file\n" > $$file; \
		curl --silent -L $(UPSTREAM_URL)/$$file >> $$file; \
	done

$(MACHINE_NAME).iso:
	livecd-creator --verbose \
		--config=fedora-live-workstation.ks \
		--fslabel=$(MACHINE_NAME)  \
		--cache=/var/cache/live

docker:
	docker build -t $(DOCKER_TAG) .
	container=$$(docker create --privileged $(DOCKER_TAG) make $(MACHINE_NAME).iso) && \
		docker cp $(CURDIR)/. $$container:/build/. && \
		docker start -a $$container
