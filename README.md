# OpenStackClient

A simple container image containing the OpenStack client and QEmu image tools.

Can be used in a cron-mode, executing the task regularly (`$USE_CRON=1`) or run only once (`unset $USE_CRON`).  In cron-mode, it can execute a user-specified crontab (`$CRONTAB=/path/to/file`) or an arbitrary command (`$COMMAND=/path/to/script`), the latter defaulting to the OpenStack client (`/usr/bin/openstack`).  Likewise, in non-cron-mode, the command being run can be configured in the same way (`$COMMAND=/path/to/script`).

## Basic usage

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

## Cron usage

Runs the OpenStack client (or a custom crontab)

The script understands the five environment variables to control time, representing the first 5 columns of a regular crontab (see `crontab(5)` for details) and takes the command line parameters to the OpenStackClient as arguments:
```
docker run --env USE_CRON=1 --env MINUTE=... --env HOUR=... --env DAY=... --env MONTH=... --env WEEKDAY=... quay.io/urzds/openstackclient $OPENSTACKCLIENT_ARGUMENTS
```

All five time related variables default to `*`, having the regular crontab meaning of `any time`. 

If you need a more complex setup, you can mount an entire crontab into the container and set `CRONTAB=/path/to/your/crontab` and the container's crontab will be initialised from there.

For how to pass the necessary environment variables to the OpenStack client, please refer to the documentation above.

### Examples

In the following, `...` represents the Docker flags necessary to pass the OpenStack client environment flags into the container. Please see above for details.

To print the version of the OpenStack client once per minute, you could run it like this:
```
docker run ... --env USE_CRON=1 quay.io/urzds/openstackclient --version
```

To print the list of servers accessible to you once per hour (i.e. everytime minute is 0), you would execute:
```
docker run ... --env USE_CRON=1 --env MINUTE=0 quay.io/urzds/openstackclient server list
```
