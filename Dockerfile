FROM gliderlabs/alpine:edge

# Version of RabbitMQ to install
ENV RABBITMQ_VERSION=3.5.6
ENV PLUGIN_BASE=v3.5.x
ENV DELAYED_MESSAGE_VERSION=0.0.1-rmq3.5.x-9bf265e4
ENV SHARDING_VERSION=3.5.x-fe42a9b6
ENV TOP_VERSION=3.5.x-99ed877e

RUN \
  apk --update add bash coreutils curl erlang erlang-asn1 erlang-crypto erlang-eldap erlang-erts erlang-inets erlang-mnesia erlang-os-mon erlang-public-key erlang-sasl erlang-ssl erlang-xmerl && \
  curl -sL -o /tmp/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.gz https://www.rabbitmq.com/releases/rabbitmq-server/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.gz && \
  mkdir -p /usr/lib/rabbitmq/lib /usr/lib/rabbitmq/etc && \
  cd /usr/lib/rabbitmq/lib && \
  tar xvfz /tmp/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.gz && \
  rm /tmp/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.gz && \
  ln -s /usr/lib/rabbitmq/lib/rabbitmq_server-${RABBITMQ_VERSION}/sbin /usr/lib/rabbitmq/bin && \
  ln -s /usr/lib/rabbitmq/lib/rabbitmq_server-${RABBITMQ_VERSION}/plugins /usr/lib/rabbitmq/plugins && \
  curl -sL -o /usr/lib/rabbitmq/plugins/rabbitmq_delayed_message_exchange-${DELAYED_MESSAGE_VERSION}.ez  http://www.rabbitmq.com/community-plugins/${PLUGIN_BASE}/rabbitmq_delayed_message_exchange-${DELAYED_MESSAGE_VERSION}.ez && \
  curl -sL -o /usr/lib/rabbitmq/plugins/rabbitmq_top-${TOP_VERSION}.ez http://www.rabbitmq.com/community-plugins/${PLUGIN_BASE}/rabbitmq_top-${TOP_VERSION}.ez

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN adduser -s /bin/bash -D -h /var/lib/rabbitmq rabbitmq

ADD erlang.cookie /var/lib/rabbitmq/.erlang.cookie
ADD rabbitmq.config /usr/lib/rabbitmq/etc/rabbitmq/

# Environment variables required to run
ENV ERL_EPMD_PORT=4369
ENV HOME /var/lib/rabbitmq
ENV PATH /usr/lib/rabbitmq/bin:$PATH

ENV RABBITMQ_LOGS=-
ENV RABBITMQ_SASL_LOGS=-
ENV RABBITMQ_DIST_PORT=25672
ENV RABBITMQ_SERVER_ERL_ARGS="+K true +A128 +P 1048576 -kernel inet_default_connect_options [{nodelay,true}]"
ENV RABBITMQ_CONFIG_FILE=/usr/lib/rabbitmq/etc/rabbitmq/rabbitmq
ENV RABBITMQ_ENABLED_PLUGINS_FILE=/usr/lib/rabbitmq/etc/rabbitmq/enabled_plugins
ENV RABBITMQ_MNESIA_DIR=/var/lib/rabbitmq/mnesia
ENV RABBITMQ_PID_FILE=/var/lib/rabbitmq/rabbitmq.pid

# Fetch the external plugins and setup RabbitMQ
RUN \
  apk --purge del curl tar gzip && \
  ln -sf /var/lib/rabbitmq/.erlang.cookie /root/ && \
  chown rabbitmq /var/lib/rabbitmq/.erlang.cookie && \
  chmod 0600 /var/lib/rabbitmq/.erlang.cookie /root/.erlang.cookie && \
  ls -al /usr/lib/rabbitmq/plugins/ && \
  rabbitmq-plugins list && \
  rabbitmq-plugins enable --offline \
        rabbitmq_delayed_message_exchange \
        rabbitmq_management \
        rabbitmq_management_visualiser \
        rabbitmq_consistent_hash_exchange \
        rabbitmq_federation \
        rabbitmq_federation_management \
        rabbitmq_mqtt \
        rabbitmq_shovel \
        rabbitmq_shovel_management \
        rabbitmq_stomp \
        rabbitmq_top \
        rabbitmq_web_stomp && \
  chown -R rabbitmq /usr/lib/rabbitmq /var/lib/rabbitmq

EXPOSE 4369 5671 5672 15672 25672

USER rabbitmq
CMD /usr/lib/rabbitmq/bin/rabbitmq-server
