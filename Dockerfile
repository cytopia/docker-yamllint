FROM alpine:latest

ARG VERSION=latest
RUN set -x \
	&& apk add --no-cache python3 \
	&& if [ "${VERSION}" = "latest" ]; then \
		pip3 install yamllint; \
	else \
		pip3 install yamllint==${VERSION}; \
	fi \
	&& ( find /usr/lib/python* -name '__pycache__' -exec rm -rf {} \; || true ) \
	&& ( find /usr/lib/python* -name '*.pyc' -exec rm -rf {} \; || true )

WORKDIR /data
ENTRYPOINT ["yamllint"]
CMD ["--help"]
