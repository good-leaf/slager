PROJECT = slager
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

ERLC_OPTS = +'{parse_transform, lager_transform}' +'{lager_truncation_size, 512000}' +'{lager_extra_sinks, [sdebug,sinfo,swarning,serror,much,much0,much1,much2,much3,much4]}'
DEPS = lager

include erlang.mk
