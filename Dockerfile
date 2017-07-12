FROM docker.io/library/alpine:3.6
MAINTAINER Dennis Schridde <dennis.schridde@uni-heidelberg.de>

ENV OPENSTACKCLIENT_VERSION=3.11.0 \
	QEMU_VERSION=2.8.1

RUN dev_pkgs='\
	gcc \
	libc-dev \
	linux-headers \
	python-dev \
' \
&& apk add --no-cache \
	ca-certificates \
	py-pip \
	"qemu-img>=$QEMU_VERSION" \
	tini \
	$dev_pkgs \
&& pip install \
	python-openstackclient==$OPENSTACKCLIENT_VERSION \
&& apk del \
	$dev_pkgs

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/openstack"]
