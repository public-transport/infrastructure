#!/usr/bin/env bash

# exit on error
set -e

kubectl=${KUBECTL_PATH:-$(>&2 echo '✗ KUBECTL_PATH environment variable not found, please supply the path to a kubectl with the appropriate cluster selected as current context'; exit 1)}

# expects env GITHUB_TOKEN to be set
# note that this needs to be run again as soon as the GITHUB_TOKEN is replaced
flux bootstrap github \
	--components-extra=image-reflector-controller,image-automation-controller \
	--kubeconfig=$KUBECTL_PATH \
	--owner=public-transport \
	--repository=infrastructure \
	--private \
	--read-write-key \
	--branch=main \
	--path=kubernetes/clusters/prod
