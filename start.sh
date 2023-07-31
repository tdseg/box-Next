#!/bin/bash
# set val

PORT=8080
AUUID=5aaed9b7-7fe3-47c3-bb52-db59859ce198
ParameterSSENCYPT=chacha20-ietf-poly1305
CADDYIndexPage=https://showip.net/
XRayConfig=https://raw.githubusercontent.com/bsefwe/codesandbox/main/etc/Caddyfile
Con=https://raw.githubusercontent.com/bsefwe/codesandbox/main/etc/config.json


# set caddy
mkdir -p etc/caddy/ usr/share/caddy
echo -e "User-agent: *\nDisallow: /" > usr/share/caddy/robots.txt
wget $CADDYIndexPage -O usr/share/caddy/index.html && unzip -qo usr/share/caddy/index.html -d usr/share/caddy/ && mv usr/share/caddy/*/* usr/share/caddy/

# download execution
wget "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" -O xray-linux-64.zip
unzip -o xray-linux-64.zip && rm -rf xray-linux-64.zip
mv xray web
chmod +x caddy web

# set config file
wget -qO- $XRayConfig | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(./caddy hash-password --plaintext $AUUID)/g" > etc/caddy/Caddyfile
wget -qO- $Con | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" > web.json


# start service
./web -config web.json &
./caddy run --config etc/caddy/Caddyfile --adapter caddyfile
