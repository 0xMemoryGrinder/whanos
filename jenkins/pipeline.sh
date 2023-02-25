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
    # deploy using helm charts
fi