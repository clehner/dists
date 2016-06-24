PKGS = main/binary-amd64/Packages main/binary-amd64/Packages.gz
INDEX = InRelease Release.gpg $(PKGS)

all: $(INDEX)

include packages.mk

Release: $(PKGS) apt-release.conf
	apt-ftparchive -c=apt-release.conf release . > $@

main/binary-amd64/Packages: $(PKG_AMD64) Makefile | packages
	dpkg-scanpackages --arch amd64 $| |\
		sed '/^Filename/ s/$|\///' > $@

%.gz: %
	@rm -vf $@
	gzip -k $<

In%: %
	@rm -vf $@
	gpg -a -s --clearsign -o $@ $<

%.gpg: %
	@rm -vf $@
	gpg -a -b -s -o $@ $<

clean:
	@rm -vf $(INDEX)

.PHONY: all clean
