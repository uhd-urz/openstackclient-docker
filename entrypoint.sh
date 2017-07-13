#!/bin/sh

set -e
set -x

MINUTE="${MINUTE:-*}"
HOUR="${HOUR:-*}"
DAY="${DAY:-*}"
MONTH="${MONTH:-*}"
WEEKDAY="${WEEKDAY:-*}"
COMMAND="${COMMAND:-/usr/bin/openstack}"

if test -n "$USE_CRON" ; then
	if test -n "$CRONTAB" ; then
		crontab "$CRONTAB"
	else
		echo "$MINUTE $HOUR $DAY $MONTH $WEEKDAY $COMMAND $@" | crontab -
	fi

	set --

	if test -n "$LOGFILE" ; then
		set -- "$@" -L "$LOGFILE"
	fi

	exec /usr/sbin/crond -f "$@"
else
	if "$LOGFILE" ; then
		exec > "$LOGFILE" 2>&1
	fi

	exec "$COMMAND" "$@"
fi
