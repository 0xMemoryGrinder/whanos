FROM docker:dind

CMD echo "{ \"insecure-registries\" : [\"${REGISTRY}\"] }" > /etc/docker/daemon.json && dockerd-entrypoint.sh