#!/usr/bin/env bash

# exit on error
set -e

kubectl=${KUBECTL_PATH:-$(>&2 echo '✗ KUBECTL_PATH environment variable not found, please supply the path to a kubectl with the appropriate cluster selected as current context'; exit 1)}

# we use a gpg key to encrypt secrets uploaded to github and decrypt them on the
# cluster. use the command
# gpg --full-generate-key
# to generate a 4096-bit RSA key pair, if you don't have one yet. you can then
# find out the secret key's id (to use it as GPG_SECRET_KEY_ID below) by running
# gpg --list-secret-keys
# if you have questions, you can also refer to the official flux docs regarding
# this topic: https://fluxcd.io/docs/guides/mozilla-sops/
kubectl=${GPG_SECRET_KEY_ID:-$(>&2 echo '✗ GPG_SECRET_KEY_ID environment variable not found, please supply the id of a secret key in your gpg keychain to use for secrets decryption in the cluster (check bootstrap.sh for instructions if you do not have such a key yet)'; exit 1)}

# you can re-run this with a new key id, just make sure to re-encrypt all secrets with the new key as well
echo 'creating or updating secret key'
gpg --list-secret-keys "$GPG_SECRET_KEY_ID" > /dev/null # unlike --export, this fails if no key with given id exists
gpg --export-secret-keys --armor "${GPG_SECRET_KEY_ID}" |
kubectl create secret generic sops-gpg \
--kubeconfig=$KUBECTL_PATH \
--namespace=flux-system \
--from-file=sops.asc=/dev/stdin \
--dry-run=client \
--output=yaml |
kubectl apply \
-f - \
--kubeconfig=$KUBECTL_PATH

SOPS_YAML_PATH=$(dirname "$0")/secrets/.sops.yaml
cat <<EOF > ${SOPS_YAML_PATH}
creation_rules:
  - path_regex: .*.yaml
    encrypted_regex: ^(data|stringData)$
    pgp: ${GPG_SECRET_KEY_ID}
EOF

gpg --export --armor "${GPG_SECRET_KEY_ID}" > $(dirname "$0")/secrets/.sops.pub.asc

# expects env GITHUB_TOKEN to be set
# note that this needs to be run again as soon as the GITHUB_TOKEN is replaced
echo 'bootstrapping or updating flux'
flux bootstrap github \
	--components-extra=image-reflector-controller,image-automation-controller \
	--kubeconfig=$KUBECTL_PATH \
	--owner=public-transport \
	--repository=infrastructure \
	--private \
	--read-write-key \
	--branch=main \
	--path=kubernetes/clusters/prod
