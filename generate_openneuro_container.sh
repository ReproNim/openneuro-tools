#!/bin/bash

set -eu

dev_build=
version_date=20210510

generate() {
	if [ "$dev_build" = "1" ]; then
		apt_pkgs=python3-pip
		run_cmd=":"
	else
		apt_pkgs=datalad
		run_cmd=":"
	fi
	# more details might come on https://github.com/ReproNim/neurodocker/issues/330
	[ "$1" == singularity ] && add_entry=' "$@"' || add_entry=''
	#neurodocker generate "$1" \
	ndversion=0.7.0
	#ndversion=master
	docker run --rm repronim/neurodocker:$ndversion generate "$1" \
		--base=neurodebian:bullseye \
		--ndfreeze date=${version_date}T000000Z \
		--pkg-manager=apt \
		--install vim wget strace time ncdu gnupg curl procps python3-datalad pigz less tree \
				  git-annex-standalone $apt_pkgs \
		--run "$run_cmd" \
		--run "curl -sL https://deb.nodesource.com/setup_16.x | bash - " \
		--install nodejs \
		--run "npm install -g bids-validator@1.7.1 openneuro-cli@3.31.1 react" \
		--run "mkdir /afs /inbox" \
		--user=reproin
}

#version=$(git describe)

generate docker > Dockerfile
