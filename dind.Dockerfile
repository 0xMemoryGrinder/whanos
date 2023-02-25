FROM docker:dind

RUN mkdir -p /etc/docker
CMD echo "{ \"insecure-registries\" : [\"${REGISTRY}\"] }" > /etc/docker/daemon.json && dockerd-entrypoint.sh