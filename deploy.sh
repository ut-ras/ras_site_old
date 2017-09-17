#!/bin/bash

# Will, assuming you have the correct permissions, deploy the UT RAS site.
# Required:
# Define the environment variable UTWEB_USER to the utweb username

set -o nounset
set -o errexit

_die () { err_code=$1; shift 1; echo $@ >&2; exit $err_code; }

#cd `dirname "${BASH_SOURCE[0]}"`
#git pull
jekyll build --config deploy.conf.yml || _die 1 "Failed to generate website"
rsync -rlz --delete --partial --info=progress2 -e "ssh" _site/* \
    ${UTWEB_USER}@panel.utweb.utexas.edu:/home/utweb/utw10091/public_html || \
    _die 2 "Failed to upload website"
#ssh ${UTWEB_USER}@panel.utweb.utexas.edu chown -R ${UTWEB_USER}:utw10091 /home/utweb/utw10091/public_html/*
