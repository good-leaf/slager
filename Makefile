PROJECT = slager
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

ERLC_OPTS = +'{parse_transform, lager_transform}' +'{lager_extra_sinks, [sdebug, sinfo, swarning, serror]}'
DEPS = lager

include erlang.mk
