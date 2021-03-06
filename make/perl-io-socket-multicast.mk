###########################################################
#
# perl-io-socket-multicast
#
###########################################################

PERL-IO-SOCKET-MULTICAST_SITE=http://$(PERL_CPAN_SITE)/CPAN/authors/id/L/LD/LDS
PERL-IO-SOCKET-MULTICAST_VERSION=1.07
PERL-IO-SOCKET-MULTICAST_SOURCE=IO-Socket-Multicast-$(PERL-IO-SOCKET-MULTICAST_VERSION).tar.gz
PERL-IO-SOCKET-MULTICAST_DIR=IO-Socket-Multicast-$(PERL-IO-SOCKET-MULTICAST_VERSION)
PERL-IO-SOCKET-MULTICAST_UNZIP=zcat
PERL-IO-SOCKET-MULTICAST_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-IO-SOCKET-MULTICAST_DESCRIPTION=Send and receive multicast messages.
PERL-IO-SOCKET-MULTICAST_SECTION=util
PERL-IO-SOCKET-MULTICAST_PRIORITY=optional
PERL-IO-SOCKET-MULTICAST_DEPENDS=perl, perl-io-interface
PERL-IO-SOCKET-MULTICAST_SUGGESTS=
PERL-IO-SOCKET-MULTICAST_CONFLICTS=

PERL-IO-SOCKET-MULTICAST_IPK_VERSION=3

PERL-IO-SOCKET-MULTICAST_CPPFLAGS=-I$(STAGING_LIB_DIR)/perl5/$(PERL_VERSION)/$(PERL_ARCH)/CORE
PERL-IO-SOCKET-MULTICAST_LDFLAGS=-L$(STAGING_LIB_DIR)/perl5/$(PERL_VERSION)/$(PERL_ARCH)/CORE -lperl

PERL-IO-SOCKET-MULTICAST_CONFFILES=
#PERL-IO-SOCKET-MULTICAST_PATCHES=$(PERL-IO-SOCKET-MULTICAST_SOURCE_DIR)/Makefile.PL.patch

PERL-IO-SOCKET-MULTICAST_BUILD_DIR=$(BUILD_DIR)/perl-io-socket-multicast
PERL-IO-SOCKET-MULTICAST_SOURCE_DIR=$(SOURCE_DIR)/perl-io-socket-multicast
PERL-IO-SOCKET-MULTICAST_IPK_DIR=$(BUILD_DIR)/perl-io-socket-multicast-$(PERL-IO-SOCKET-MULTICAST_VERSION)-ipk
PERL-IO-SOCKET-MULTICAST_IPK=$(BUILD_DIR)/perl-io-socket-multicast_$(PERL-IO-SOCKET-MULTICAST_VERSION)-$(PERL-IO-SOCKET-MULTICAST_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-IO-SOCKET-MULTICAST_SOURCE):
	$(WGET) -P $(@D) $(PERL-IO-SOCKET-MULTICAST_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(FREEBSD_DISTFILES)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

perl-io-socket-multicast-source: $(DL_DIR)/$(PERL-IO-SOCKET-MULTICAST_SOURCE) $(PERL-IO-SOCKET-MULTICAST_PATCHES)

$(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-IO-SOCKET-MULTICAST_SOURCE) $(PERL-IO-SOCKET-MULTICAST_PATCHES) make/perl-io-socket-multicast.mk
	$(MAKE) perl-stage
	rm -rf $(BUILD_DIR)/$(PERL-IO-SOCKET-MULTICAST_DIR) $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)
	$(PERL-IO-SOCKET-MULTICAST_UNZIP) $(DL_DIR)/$(PERL-IO-SOCKET-MULTICAST_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PERL-IO-SOCKET-MULTICAST_PATCHES)"; then \
		cat $(PERL-IO-SOCKET-MULTICAST_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PERL-IO-SOCKET-MULTICAST_DIR) -p1; \
	fi
	mv $(BUILD_DIR)/$(PERL-IO-SOCKET-MULTICAST_DIR) $(@D)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PERL-IO-SOCKET-MULTICAST_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PERL-IO-SOCKET-MULTICAST_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL  \
		PREFIX=$(TARGET_PREFIX) \
		"--cflags=$(STAGING_CPPFLAGS) $(PERL-IO-SOCKET-MULTICAST_CPPFLAGS)" \
		"--libs=$(STAGING_LDFLAGS)" \
	)
	touch $@

perl-io-socket-multicast-unpack: $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.configured

$(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.built: $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		LD=$(TARGET_CC) \
		PASTHRU_INC="$(STAGING_CPPFLAGS) $(PERL-IO-SOCKET-MULTICAST_CPPFLAGS)" \
		LDDLFLAGS="-shared $(STAGING_LDFLAGS) $(PERL-IO-SOCKET-MULTICAST_LDFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PERL-IO-SOCKET-MULTICAST_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		;
	touch $@

perl-io-socket-multicast: $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.built

$(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.staged: $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

perl-io-socket-multicast-stage: $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.staged

$(PERL-IO-SOCKET-MULTICAST_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: perl-io-socket-multicast" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-IO-SOCKET-MULTICAST_PRIORITY)" >>$@
	@echo "Section: $(PERL-IO-SOCKET-MULTICAST_SECTION)" >>$@
	@echo "Version: $(PERL-IO-SOCKET-MULTICAST_VERSION)-$(PERL-IO-SOCKET-MULTICAST_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-IO-SOCKET-MULTICAST_MAINTAINER)" >>$@
	@echo "Source: $(PERL-IO-SOCKET-MULTICAST_SITE)/$(PERL-IO-SOCKET-MULTICAST_SOURCE)" >>$@
	@echo "Description: $(PERL-IO-SOCKET-MULTICAST_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-IO-SOCKET-MULTICAST_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-IO-SOCKET-MULTICAST_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-IO-SOCKET-MULTICAST_CONFLICTS)" >>$@

$(PERL-IO-SOCKET-MULTICAST_IPK): $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR)/.built
	rm -rf $(PERL-IO-SOCKET-MULTICAST_IPK_DIR) $(BUILD_DIR)/perl-io-socket-multicast_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR) install \
		DESTDIR=$(PERL-IO-SOCKET-MULTICAST_IPK_DIR) \
		;
	find $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX) -type f -name 'perllocal.pod' -exec rm -f {} \;
	find $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX) -type f -name '.packlist' -exec rm -f {} \;
	mkdir -p $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX)/share
	mv -f $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX)/{man,share/}
	(cd $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX)/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)/CONTROL/control
	echo $(PERL-IO-SOCKET-MULTICAST_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-IO-SOCKET-MULTICAST_IPK_DIR)

perl-io-socket-multicast-ipk: $(PERL-IO-SOCKET-MULTICAST_IPK)

perl-io-socket-multicast-clean:
	-$(MAKE) -C $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR) clean

perl-io-socket-multicast-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-IO-SOCKET-MULTICAST_DIR) $(PERL-IO-SOCKET-MULTICAST_BUILD_DIR) $(PERL-IO-SOCKET-MULTICAST_IPK_DIR) $(PERL-IO-SOCKET-MULTICAST_IPK)

perl-io-socket-multicast-check: $(PERL-IO-SOCKET-MULTICAST_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
