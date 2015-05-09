# Copyright (c) 2014 Benda Xu <heroxbd@gentoo.org>
# Released under the 2-clause BSD license.

runit_start()
{
	local service_dir runit_service
	service_dir="${runit_service_dir:-/etc/sv}
	runit_service="${service_dir}/${RC_SVCNAME}"
	if [ ! -d "${runit_service}" ]; then
		eerror "Runit service ${runit_service} not found"
		return 1
	fi
	ebegin "Starting ${name:-$RC_SVCNAME}"
	ln -snf "${runit_service}" "${RC_SVCDIR}/runit/$RC_SVCNAME" &&
		sv check up "${RC_SVCDIR}/runit/$RC_SVCNAME"
	eend $? "Failed to start $RC_SVCNAME"
}

runit_stop()
{
	ebegin "Stopping ${name:-$RC_SVCNAME}"
	sv down "${RC_SVCDIR}/runit/${RC_SVCNAME}" &&
		rm "${RC_SVCDIR}/runit/${RC_SVCNAME}"
	eend $? "Failed to stop $RC_SVCNAME"
}

runit_status()
{
	sv status "${RC_SVCDIR}/runit/${RC_SVCNAME}"
}
