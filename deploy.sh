#!/bin/bash

set -o nounset
set -o errexit

_die () { err_code=$1; shift 1; echo $@ >&2; exit $err_code; }

UTWEB_USER=${UTWEB_USER:-$(whoami)}

cd `dirname "${BASH_SOURCE[0]}"`
git pull
jekyll build --config deploy.conf.yml || _die 1 "Failed to generate website"
rsync -az --delete --partial --info=progress2 -e "ssh" _site/* \
    ${UTWEB_USER}@panel.utweb.utexas.edu:~/utw10091/public_html || \
    _die 2 "Failed to upload website"
