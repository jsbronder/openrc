# Using runit with OpenRC

Beginning with OpenRC-0.21, we support using runit [1] in place of
start-stop-daemon for monitoring and restarting daemons.

## Setup

Documenting runit in detail is beyond the scope of this guide. It will
document how to set up OpenRC services to communicate with runit.

### Use Default start, stop and status functions

If you write your own start, stop and status functions in your service
script, none of this will work. You must allow OpenRC to use the default
functions.

### Dependencies

All OpenRC service scripts that want their daemons monitored by runit
should have the following line added to their dependencies to make sure
the runit scan directory is being monitored.

need s6-svscan

### Variable Settings

The most important setting is the supervisor variable. At the top of
your service script, you should set this variable as follows:

supervisor=runit

Several other variables affect runit services. They are documented on the
openrc-run man page, but I will list them here for convenience:

runit_service_path - the path to the runit service directory. The default is
/etc/sv/$RC_SVCNAME.

s6_svwait_options_start - the options to pass to s6-svwait when starting
the service. If this is not set, s6-svwait will not be called.

s6_service_timeout_stop - the amount of time, in milliseconds, s6-svc
should wait for a service to go down when stopping.

This is very early support, so feel free to file bugs if you have
issues.

[1] http://www.smarden.org/runit
