#!/bin/bash
readonly VERSION='1.22-alpine'

cd "$(dirname $0)" || exit

docker build "${@}" -t cr.selcloud.ru/leshak/nginx-with-upload:${VERSION} . -t cr.selcloud.ru/leshak/nginx-with-upload:latest
docker push cr.selcloud.ru/leshak/nginx-with-upload:${VERSION}
docker push cr.selcloud.ru/leshak/nginx-with-upload:latest
