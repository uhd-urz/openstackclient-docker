# OpenStackClient

A simple container image containing the OpenStack client and QEmu image tools.

# Usage

As with the non-container OpenStack client, you need to prepare following environment variables: `OS_AUTH_URL`, `OS_TENANT_ID`, `OS_TENANT_NAME`, `OS_PROJECT_NAME`, `OS_REGION_NAME`, `OS_USERNAME` and `OS_PASSWORD`. You usually receive them in form of an `openrc.sh` script from your cloud provider.

The difference with the container image is that you need to pass these variables through to the container. In Bash you could e.g. run:
```bash
. openrc.sh
docker run $(for v in OS_AUTH_URL OS_TENANT_ID OS_TENANT_NAME OS_PROJECT_NAME OS_REGION_NAME OS_USERNAME OS_PASSWORD ; do echo --env $v=${!v} ; done) quay.io/urzds/openstackclient --version
```

Or in Fish shell:
```fish
. openrc.fish
docker run (for v in OS_AUTH_URL OS_TENANT_ID OS_TENANT_NAME OS_PROJECT_NAME OS_REGION_NAME OS_USERNAME OS_PASSWORD ; echo --env $v=$$v ; end) quay.io/urzds/openstackclient --version
```


This will expand to:
```
docker run --env OS_AUTH_URL=... --env OS_TENANT_ID=... --env OS_TENANT_NAME=... --env OS_PROJECT_NAME=... --env OS_REGION_NAME=... --env OS_USERNAME=... --env OS_PASSWORD=... quay.io/urzds/openstackclient --version
```
