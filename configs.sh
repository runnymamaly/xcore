#!/bin/sh
set -e

ID="$(cat "data/uuid")"
PRIVATE_KEY="$(awk '/PrivateKey/{print $2}' "data/keys")"
PUBLIC_KEY="$(awk '/Password/{print $3}' "data/keys")"
ADDRESS="${ADDRESS:-$(wget -q "ifconfig.me/ip" -O-)}"

if [ -z "${ADDRESS}" ]; then echo "The ADDRESS environment variable must be set!" >&2; exit 1; fi
if [ "${NETWORK}" = "ws" ]; then
  # echo "vless://${ID}@${ADDRESS}:${PORT}?type=xhttp&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}" | qrencode -t ansiutf8
  echo "vless://${ID}@${ADDRESS}:${PORT}?encryption=none&security=tls&sni=${ADDRESS}&fp=chrome&alpn=http%2F1.1&insecure=0&allowInsecure=0&type=ws#${ADDRESS}" | qrencode -t ansiutf8
  
elif [ "${NETWORK}" = "tcp" ]; then
  echo "vless://${ID}@${ADDRESS}:${PORT}?type=tcp&flow=xtls-rprx-vision&security=reality&pbk=${PUBLIC_KEY}&sni=${SNI}&fp=chrome#${ADDRESS}" | qrencode -t ansiutf8
  
else
  echo 'The NETWORK environment variable must be set to "tcp" or "xhttp"!' >&2
  exit 1
fi

{
  echo
  echo "Address: ${ADDRESS}"
  echo "Port: ${PORT}"
  echo "Network: ${NETWORK:-tcp}"
  echo "ID: ${ID}"
  echo "PublicKey: ${PUBLIC_KEY}"
  echo "SNI: ${SNI}"
  echo
} | column -L -t
