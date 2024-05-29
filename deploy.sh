#!/bin/bash

# Will build and deploy the RAS site to ras.ece.utexas.edu,
# assuming you have ssh permissions on the server.

# if you want to setup ssh keys you won't have to enter your password more than once.

echo "Building site with Jekyll..."
jekyll build
echo "Done."
# echo -n "Please enter UT EID: "
# read utweb_user # UNCOMMENT IF YOU WANT TO USE ANOTHER UT EID
echo "Uploading with rsync to temp directory..."
rsync --progress \
      -u \
      -rlz \
      -p \
      --chmod=D775,F664 \
      --inplace \
      -e "ssh" \
      ./_site/ dvn344@panel.utweb.utexas.edu:/home/utweb/utw10091/public_html/temp_dest # SWAP WITH BELOW LINE IF DIFF USER
      #  ./_site/ $utweb_user@panel.utweb.utexas.edu:/home/utweb/utw10091/public_html/temp_dest 
echo "Done."
echo "Moving files to the destination directory..."
# ssh $utweb_user@panel.utweb.utexas.edu " # SWAP WITH BELOW LINE IF DIFF USER
ssh dvn344@panel.utweb.utexas.edu "
rm -rf /home/utweb/utw10091/public_html/2024;
rm -rf /home/utweb/utw10091/public_html/about;
rm -rf /home/utweb/utw10091/public_html/resources;
mv -f /home/utweb/utw10091/public_html/temp_dest/2024 /home/utweb/utw10091/public_html/;
mv -f /home/utweb/utw10091/public_html/temp_dest/about /home/utweb/utw10091/public_html/;
mv -f /home/utweb/utw10091/public_html/temp_dest/* /home/utweb/utw10091/public_html/;"
# rm -rf /home/utweb/utw10091/public_html/temp_dest/;
# this was very hacky way of removing the relevant years and overwriting them, if better alternative exists then fix this later
echo "Done."

# rsync options:
#  -r                sync files recursively (entire directory hierarchy)
#  -l                copy symlinks (not really necessary; we don't have any)
#  -z                compresses files during transfer
#  -p                makes rsync set permissions
#  --inplace         overwrites previous files, including permissions
#  --chmod=D775,F664 sets permissions (needs -p) (see rationale below)
#  -e "ssh"          use ssh (this is default already, but make sure)
# Note: the rsync version on server does not support setting custom group;
# however, all webmasters belong to the default group, so no problem.

# FILE PERMISSIONS RATIONALE
#
# We have multiple webmasters, each of which should be able to completely
# rewrite all of the website files on the server. To make this work,
# attention needs to be paid to file and directory permissions:
#
# Some fine points of unix directory permissions:
# - files and directories have an owner (one user) and group (multiple)
# - owner, group, and others have read/write/execute flags on each file
# - execute flag on directory means "can see contents of directory"
# - user can edit file contents iff has write permission (user or group)
# - user can delete file iff has write permission to enclosing directory
# - user can chown iff user is current owner, new owner, in new group
# - user can chmod iff user is current owner
#
# Note these rules mean non-root users cannot change file owners. Also,
# if a user creates a directory with a file in it, other non-root users
# cannot delete either if they do not have write permissions to the
# directory, no matter the permissions on the grandparent directory
# (although the directory can be renamed).
#
# In our case, we want, in a hierarchical directory structure:
# (a) general public can read, but not write, all files
#      - other file permissions are r-- or r-x (x bit doesn't matter)
#      - other directory permissions are r-x (must be x to see files)
# (c) webmasters can add new files
#      - group directory permissions are rwx
# (b) webmasters can delete files (e.g., delete and write new version)
#      - group directory permissions include w
# (c) webmasters might as well be able to edit files 
#      - group file permissions are rw- or rwx (x bit doesn't matter)
# (d) file-uploading webmasters (file owners) have all permissions
#      - owner file permissions are rw- or rwx (x bit doesn't matter)
#      - owner directory permissions are rwx
#
# So we want:
# - all directories to have permissions rwxrwxr-x (775)
# - all files to have permissions rw-rw-r-- (664) [or rwxrwxr-x (775)]
#
# When uploading site files, all permissions should be changed to the
# above, no matter what permissions are present locally.

