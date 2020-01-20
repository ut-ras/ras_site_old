# Setup instructions for new Webmasters/Site Editors
*This guide assumes that the reader is running Ubuntu on WSL or a Linux/Ubuntu boot.*
## Dependencies
* Ruby - Jekyll dependency
  * `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
7D2BAF1CF37B13E2069D6956105BD0E739499BDB`
  * `curl -sSL https://get.rvm.io | bash -s stable --ruby`
  * `source /usr/local/rvm/scripts/rvm`
  * `rvm version` - if the version is less than 2.4, upgrade to 2.4 using the following commands:
    * `rvm list known`
    * `rvm install ruby-2.4`
    * `rvm --default use ruby-2.4`
* Jekyll - site builder
  * `gem install bundler jekyll`
* Git - version control  
  * `sudo apt install git`
* VPN - (install on Windows)
  * [wikis.utexas.edu](https://wikis.utexas.edu/display/engritgpublic/Connecting+to+the+University+of+Texas+VPN)
  
## Setup and Use
1. Setup directory for ras_site
    1. `git clone https://github.com/ut-ras/ras_site.git`
2. Check if site can build
    1. `jekyll build`
3. Make changes to repo files
4. Rebuild site and check changes
5. Publish to github
    1. `git add -u/--all`
    2. `git commit -m "commit message here"`
    3. `git push`
6. Publish to UT servers - webmaster/president/vice president only have permissions
    1. If on utexas wifi: `./deploy.sh`, enter in UT EID, Password.
