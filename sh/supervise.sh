# start / stop / status functions for supervise-daemon

# Copyright (c) 2016 The OpenRC Authors.
# See the Authors file at the top-level directory of this distribution and
# https://github.com/OpenRC/openrc/blob/master/AUTHORS
#
# This file is part of OpenRC. It is subject to the license terms in
# the LICENSE file found in the top-level directory of this
# distribution and at https://github.com/OpenRC/openrc/blob/master/LICENSE
# This file may not be copied, modified, propagated, or distributed
#    except according to the terms contained in the LICENSE file.

supervise_start()
{
	if [ -z "$command" ]; then
		ewarn "The command variable is undefined."
		ewarn "There is nothing for ${name:-$RC_SVCNAME} to start."
		return 1
	fi

	ebegin "Starting ${name:-$RC_SVCNAME}"
	eval supervise-daemon --start \
		--exec $command \
		${procname:+--name} $procname \
		${pidfile:+--pidfile} $pidfile \
		${command_user+--user} $command_user \
		$supervise_daemon_args \
		-- $command_args $command_args_foreground
	service_set_value "command" "${command}"
	[ -n "${pidfile}" ] && service_set_value "pidfile" "${pidfile}"
	[ -n "${procname}" ] && service_set_value "procname" "${procname}"
	return 0
}

supervise_stop()
{
	local startcommand="$(service_get_value "command")"
	local startpidfile="$(service_get_value "pidfile")"
	local startprocname="$(service_get_value "procname")"
	command="${startcommand:-$command}"
	pidfile="${startpidfile:-$pidfile}"
	procname="${startprocname:-$procname}"
	[ -n "$command" -o -n "$procname" -o -n "$pidfile" ] || return 0
	ebegin "Stopping ${name:-$RC_SVCNAME}"
	supervise-daemon --stop \
		${retry:+--retry} $retry \
		${command:+--exec} $command \
		${procname:+--name} $procname \
		${pidfile:+--pidfile} $pidfile \
		${stopsig:+--signal} $stopsig

	eend $? "Failed to stop $RC_SVCNAME"
}

supervise_status()
{
	_status
}
