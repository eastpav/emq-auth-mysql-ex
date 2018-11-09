.PHONY: app tests

PROJECT = emq_auth_mysql_ex
PROJECT_DESCRIPTION = Authentication/ACL with MySQL with limited user count
PROJECT_VERSION = 2.3.11

DEPS = mysql ecpool clique

dep_mysql  = git https://github.com/mysql-otp/mysql-otp 1.3.1
dep_ecpool = git https://github.com/emqtt/ecpool v0.2.1
dep_clique = git https://github.com/emqtt/clique v0.3.10

BUILD_DEPS = emqttd cuttlefish
dep_emqttd = git https://github.com/emqtt/emqttd master
dep_cuttlefish = git https://github.com/emqtt/cuttlefish v2.0.11

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'

TEST_DEPS = emqttc emq_auth_username
dep_emqttc = git https://github.com/emqtt/emqttc
dep_emq_auth_username = git https://github.com/emqtt/emq-auth-username

TEST_ERLC_OPTS += +debug_info
TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emq_auth_mysql_ex.conf -i priv/emq_auth_mysql_ex.schema -d data

