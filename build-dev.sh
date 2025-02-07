#!/bin/bash
readonly VERSION='1.22-alpine'

cd "$(dirname $0)" || exit

docker build "${@}" -t cr.selcloud.ru/leshak/nginx-with-upload-dev:${VERSION} -f Dockerfile.dev . -t cr.selcloud.ru/leshak/nginx-with-upload-dev:latest
docker push cr.selcloud.ru/leshak/nginx-with-upload-dev:${VERSION}
docker push cr.selcloud.ru/leshak/nginx-with-upload-dev:latest
