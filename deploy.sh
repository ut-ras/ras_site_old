#!/bin/bash

# Will, assuming you have the correct permissions, deploy the UT RAS site.
# Define the environment variable UTWEB_USER to be your utweb username.

set -o nounset
set -o errexit

_die () { err_code=$1; shift 1; echo $@ >&2; exit $err_code; }

#jekyll build || _die 1 "Failed to generate website"
rsync -rlz --partial -e "ssh" _site/* \
    ${UTWEB_USER}@panel.utweb.utexas.edu:/home/utweb/utw10091/public_html || \
    _die 2 "Failed to upload website"
ssh ${UTWEB_USER}@panel.utweb.utexas.edu chown -R ${UTWEB_USER}:utw10091 /home/utweb/utw10091/public_html/*
