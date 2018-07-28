
all:
	$(MAKE) -C hostapd-mana/hostapd/

install:
	# Create the target directories
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/www
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/crackapd
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/firelamb
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/sslstrip2
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/sslstrip2/sslstrip
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/dns2proxy
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/net-creds
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/cert
	install -d -m 755 $(DESTDIR)/usr/share/mana-toolkit/run-mana
	install -d -m 755 $(DESTDIR)/usr/lib/mana-toolkit/
	install -d -m 755 $(DESTDIR)/var/lib/mana-toolkit/sslsplit
	install -d -m 755 $(DESTDIR)/etc/mana-toolkit/
	install -d -m 755 $(DESTDIR)/etc/apache2/sites-available/
	# Install configuration files
	install -m 644 run-mana/conf/* $(DESTDIR)/etc/mana-toolkit/
	install -m 644 crackapd/crackapd.conf $(DESTDIR)/etc/mana-toolkit/
	install -m 644 apache/etc/apache2/sites-available/* $(DESTDIR)/etc/apache2/sites-available/
	# Install the hostapd binary
	install -m 755 hostapd-mana/hostapd/hostapd $(DESTDIR)/usr/lib/mana-toolkit/
	install -m 755 hostapd-mana/hostapd/hostapd_cli $(DESTDIR)/usr/lib/mana-toolkit/
	# Install the data
	cp -R apache/var/www/* $(DESTDIR)/usr/share/mana-toolkit/www/
	install -m 644 run-mana/cert/* $(DESTDIR)/usr/share/mana-toolkit/cert/
	# Install the scripts
	install -m 755 crackapd/crackapd.py $(DESTDIR)/usr/share/mana-toolkit/crackapd/
	install -m 644 firelamb/* $(DESTDIR)/usr/share/mana-toolkit/firelamb/
	chmod 755 $(DESTDIR)/usr/share/mana-toolkit/firelamb/*.py \
	          $(DESTDIR)/usr/share/mana-toolkit/firelamb/*.sh
	install -m 644 sslstrip-hsts/dns2proxy/* \
	    $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/dns2proxy/
	install -m 644 $$(find sslstrip-hsts/sslstrip2/ -maxdepth 1 -type f) \
	    $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/sslstrip2/
	install -m 644 $$(find sslstrip-hsts/sslstrip2/sslstrip/ -maxdepth 1 -type f) \
	    $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/sslstrip2/sslstrip/
	chmod 755 $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/sslstrip2/sslstrip.py \
	          $(DESTDIR)/usr/share/mana-toolkit/sslstrip-hsts/dns2proxy/dns2proxy.py
	install -m 644 net-creds/* \
	    $(DESTDIR)/usr/share/mana-toolkit/net-creds/
	install -m 755 run-mana/*.sh $(DESTDIR)/usr/share/mana-toolkit/run-mana
	# Dynamic configuration (if not fake install)
	if [ "$(DESTDIR)" = "" ]; then \
	    a2enmod rewrite || true; \
	    a2dissite 000-default || true; \
	    for conf in apache/etc/apache2/sites-available/*; do \
	        a2ensite `basename $$conf` || true; \
	    done; \
	fi
