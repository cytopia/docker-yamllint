FROM alpine:latest
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-yamllint"

ARG VERSION=latest
RUN set -x \
	&& apk add --no-cache python3 \
	&& if [ "${VERSION}" = "latest" ]; then \
		pip3 install --no-cache-dir --no-compile yamllint; \
	else \
		pip3 install --no-cache-dir --no-compile yamllint==${VERSION}; \
	fi \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

WORKDIR /data
ENTRYPOINT ["yamllint"]
CMD ["--help"]
