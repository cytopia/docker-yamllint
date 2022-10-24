ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.docker Makefile.lint
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)

# Set default Target
.DEFAULT_GOAL := help


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
# Own vars
TAG        = latest

# Makefile.docker overwrites
NAME       = yamllint
VERSION    = latest
IMAGE      = cytopia/yamllint
FLAVOUR    = latest
FILE       = Dockerfile.${FLAVOUR}
DIR        = Dockerfiles

# Building from master branch: Tag == 'latest'
ifeq ($(strip $(TAG)),latest)
	ifeq ($(strip $(VERSION)),latest)
		DOCKER_TAG = $(FLAVOUR)
	else
		ifeq ($(strip $(FLAVOUR)),latest)
			DOCKER_TAG = $(VERSION)
		else
			DOCKER_TAG = $(FLAVOUR)-$(VERSION)
		endif
	endif
# Building from any other branch or tag: Tag == '<REF>'
else
	ifeq ($(strip $(FLAVOUR)),latest)
		DOCKER_TAG = $(VERSION)-$(TAG)
	else
		DOCKER_TAG = $(FLAVOUR)-$(VERSION)-$(TAG)
	endif
endif
ARCH       = linux/amd64

# Makefile.lint overwrites
FL_IGNORES  = .git/,.github/,tests/,Dockerfiles/data/
SC_IGNORES  = .git/,.github/,tests/
JL_IGNORES  = .git/,.github/


# -------------------------------------------------------------------------------------------------
#  Default Target
# -------------------------------------------------------------------------------------------------
.PHONY: help
help:
	@echo "lint                                     Lint project files and repository"
	@echo
	@echo "build [ARCH=...] [TAG=...]               Build Docker image"
	@echo "rebuild [ARCH=...] [TAG=...]             Build Docker image without cache"
	@echo "push [ARCH=...] [TAG=...]                Push Docker image to Docker hub"
	@echo
	@echo "manifest-create [ARCHES=...] [TAG=...]   Create multi-arch manifest"
	@echo "manifest-push [TAG=...]                  Push multi-arch manifest"
	@echo
	@echo "test [ARCH=...]                          Test built Docker image"
	@echo


# -------------------------------------------------------------------------------------------------
#  Docker Targets
# -------------------------------------------------------------------------------------------------
.PHONY: build
build: ARGS=--build-arg VERSION=$(VERSION)
build: docker-arch-build

.PHONY: rebuild
rebuild: ARGS=--build-arg VERSION=$(VERSION)
rebuild: docker-arch-rebuild

.PHONY: push
push: docker-arch-push


# -------------------------------------------------------------------------------------------------
#  Manifest Targets
# -------------------------------------------------------------------------------------------------
.PHONY: manifest-create
manifest-create: docker-manifest-create

.PHONY: manifest-push
manifest-push: docker-manifest-push


# -------------------------------------------------------------------------------------------------
#  Test Targets
# -------------------------------------------------------------------------------------------------
.PHONY: test
test: _test-version
test: _test-run

.PHONY: _test-version
_test-version:
	@echo "------------------------------------------------------------"
	@echo "- Testing correct version"
	@echo "------------------------------------------------------------"
	@if [ "$(TAG)" = "latest" ]; then \
		echo "Fetching latest version from GitHub"; \
		LATEST="$$( \
			curl -L -sS  https://github.com/adrienverge/yamllint/releases/latest/ \
				| tac | tac \
				| grep -Eo "adrienverge/yamllint/releases/tag/v[.0-9]+" \
				| head -1 \
				| sed 's/.*v//g' \
		)"; \
		echo "Testing for latest: $${LATEST}"; \
		if ! docker run --platform $(ARCH) --rm $(IMAGE):$(DOCKER_TAG) --version | grep -E "v?$${LATEST}"; then \
			docker run --platform $(ARCH) --rm $(IMAGE):$(DOCKER_TAG) --version; \
			echo "Failed"; \
			exit 1; \
		fi; \
	else \
		echo "Testing for tag: $(TAG)"; \
		if ! docker run --platform $(ARCH) --rm $(IMAGE):$(DOCKER_TAG) --version | grep -E "v?$(TAG)[.0-9]+$$"; then \
			docker run --platform $(ARCH) --rm $(IMAGE):$(DOCKER_TAG) --version; \
			echo "Failed"; \
			exit 1; \
		fi; \
	fi; \
	echo "Success"; \

.PHONY: _test-run
_test-run:
	@echo "------------------------------------------------------------"
	@echo "- Testing yaml files "
	@echo "------------------------------------------------------------"
	if ! docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests:/data $(IMAGE):$(DOCKER_TAG) . ; then \
		echo "Failed"; \
		exit 1; \
	fi; \
	echo "Success";
