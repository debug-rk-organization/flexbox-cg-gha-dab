#!/usr/bin/env bash
if [ "$CODESPACES" = "true" ]; then
    echo "Codespaces detected, skipping PG Root CA installation"
else
    curl -sL https://iiot-services.pg.com/InstallIiotCertsDeb | sudo bash
	openssl s_client -connect pg.goskope.com:443 -showcerts </dev/null 2>/dev/null | sed -e '/-----BEGIN/,/-----END/!d' | tee "/usr/local/share/ca-certificates/pg.goskope.com.crt" >/dev/null
    # pip install certifi
fi
