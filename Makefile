UPSTREAM_VERSION:=f33
UPSTREAM_URL:=https://pagure.io/fedora-kickstarts/raw/$(UPSTREAM_VERSION)/f
UPSTREAM_KS_FILES:=fedora-live-workstation.ks fedora-workstation-common.ks fedora-live-base.ks

.PHONY: refresh_upstream_kickstarts
refresh_upstream_kickstarts:
	@for file in $(UPSTREAM_KS_FILES) ; do \
		echo -e "# Sourced from $(UPSTREAM_URL)/$$file\n" > $$file; \
		curl --silent -L $(UPSTREAM_URL)/$$file >> $$file; \
	done


