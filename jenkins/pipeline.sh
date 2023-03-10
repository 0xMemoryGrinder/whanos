#! /bin/bash

LANGUAGE=()

if [[ $(find app -type f) == app/main.bf ]]; then
	LANGUAGE+=("befunge")
fi
if [[ -f Makefile ]]; then
	LANGUAGE+=("c")
fi
if [[ -f app/pom.xml ]]; then
	LANGUAGE+=("java")
fi
if [[ -f package.json ]]; then
	LANGUAGE+=("javascript")
fi
if [[ -f requirements.txt ]]; then
	LANGUAGE+=("python")
fi

if [[ ${#LANGUAGE[@]} == 0 ]]; then
	echo "Invalid project: no language detected."
	exit 1
fi
if [[ ${#LANGUAGE[@]} != 1 ]]; then
	echo "Invalid project: multiple project types detected (${LANGUAGE[@]})."
	exit 1
fi


image_name=$REGISTRY/whanos/whanos-$1-${LANGUAGE[0]}
local_image=localhost:32000/whanos/whanos-$1-${LANGUAGE[0]}

if [[ -f Dockerfile ]]; then # using dockerfile in repository
	docker build . -t $image_name
else # using standalone image
	docker build . \
		-f /images/${LANGUAGE[0]}/Dockerfile.standalone \
		-t $image_name
fi

if ! docker push $image_name; then
	exit 1
fi


if [[ -f whanos.yml ]]; then
	helm upgrade -if whanos.yml "$1" /kubernetes/project-deploy --set image.image=$local_image --set image.name="$1-name"

	external_ip=""
	ip_timeout=20
	echo "Trying to get the external IP:"
	while [ -z $external_ip ]; do
		if [[ "$ip_timeout" -eq "0" ]]; then
			ip_timeout="Couldn't get the IP: Timeout"
			break
		fi
		sleep 5
		echo -n "."
		external_ip=$(kubectl get svc $1-lb --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
		ip_timeout=$(($ip_timeout - 1))
	done

	echo "."
	echo "$external_ip"
else
	if helm status "$1" &> /dev/null; then
		helm uninstall "$1"
	fi
fi