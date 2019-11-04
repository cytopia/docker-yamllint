FROM alpine:3.9 as builder

RUN set -eux \
	&& apk add --no-cache \
		bc \
		python3

ARG VERSION
RUN set -eux \
	&& if [ "${VERSION}" = "latest" ]; then \
		pip3 install --no-cache-dir --no-compile yamllint; \
	else \
		MAJOR="$( echo "${VERSION}" | awk -F '.' '{print $1}' )"; \
		MINOR="$( echo "${VERSION}" | awk -F '.' '{print $2}' )"; \
		MINOR="$( echo "${MINOR}+1" | bc )"; \
		pip3 install --no-cache-dir --no-compile "yamllint>=${VERSION},<${MAJOR}.${MINOR}"; \
	fi \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf


FROM alpine:3.9 as production
ARG VERSION
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#LABEL "org.opencontainers.image.created"=""
#LABEL "org.opencontainers.image.version"=""
#LABEL "org.opencontainers.image.revision"=""
LABEL "maintainer"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.authors"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.vendor"="cytopia"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.url"="https://github.com/cytopia/docker-yamllint"
LABEL "org.opencontainers.image.documentation"="https://github.com/cytopia/docker-yamllint"
LABEL "org.opencontainers.image.source"="https://github.com/cytopia/docker-yamllint"
LABEL "org.opencontainers.image.ref.name"="Yamllint ${VERSION}"
LABEL "org.opencontainers.image.title"="Yamllint ${VERSION}"
LABEL "org.opencontainers.image.description"="Yamllint ${VERSION}"

RUN set -eux \
	&& apk add --no-cache python3 \
	&& ln -sf /usr/bin/python3 /usr/bin/python \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf
COPY --from=builder /usr/lib/python3.6/site-packages/ /usr/lib/python3.6/site-packages/
COPY --from=builder /usr/bin/yamllint /usr/bin/yamllint
WORKDIR /data
ENTRYPOINT ["yamllint"]
CMD ["--help"]
