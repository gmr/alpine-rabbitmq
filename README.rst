alpine-rabbitmq
===============
RabbitMQ container with a small disk footprint

Enabled plugins
---------------

 - Consistent Hash Exchange
 - Delayed Message Exchange
 - Federation
 - Federation Management
 - Management
 - Management Visualiser
 - MQTT
 - Shovel
 - Shovel Management
 - Stomp
 - Top
 - WebStomp

Example Usage
-------------

.. code-block::

    docker run --name rabbitmq -d -p 4369:4369 -p 5672:5672 -p 15672:15672 -p 25672:25672 gavinmroy/alpine-rabbitmq

.. |Stars| image:: https://img.shields.io/docker/stars/gavinmroy/alpine-rabbitmq.svg?style=flat&1
   :target: https://hub.docker.com/r/gavinmroy/alpine-rabbitmq/

.. |Pulls| image:: https://img.shields.io/docker/pulls/gavinmroy/alpine-rabbitmq.svg?style=flat&1
   :target: https://hub.docker.com/r/gavinmroy/alpine-rabbitmq/

.. |Layers| image:: https://img.shields.io/imagelayers/image-size/gavinmroy/alpine-rabbitmq/latest.svg?style=flat&1
    :target: https://hub.docker.com/r/gavinmroy/alpine-rabbitmq/
