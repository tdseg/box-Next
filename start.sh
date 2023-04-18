#!/bin/bash

PORT=8080
AUUID=5aaed9b7-7fe3-47c3-bb52-db59859ce198
ParameterSSENCYPT=chacha20-ietf-poly1305
CADDYIndexPage=https://raw.githubusercontent.com/caddyserver/dist/master/welcome/index.html
XRayConfig=https://raw.githubusercontent.com/bsefwe/glitch-Xray/main/etc/config.json
# download execution
chmod +x  xray

# set caddy
mkdir -p etc/caddy/ usr/share/caddy
echo -e "User-agent: *\nDisallow: /" > usr/share/caddy/robots.txt
wget $CADDYIndexPage -O usr/share/caddy/index.html && unzip -qo usr/share/caddy/index.html -d usr/share/caddy/ && mv usr/share/caddy/*/* usr/share/caddy/


# set config file
wget -qO- $XRayConfig  | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" > xray.json


# start service
./xray -config xray.json &
./caddy run --config etc/caddy/Caddyfile --adapter caddyfile
