#!/bin/bash
  
   # Directory in which librarian-puppet should manage its modules directory
   PUPPET_DIR=/vagrant/provision/puppet
  
   # NB: librarian-puppet might need git installed. If it is not already installed
   # in your basebox, this will manually install it at this point using apt or yum
 
  $(which git > /dev/null 2>&1)
  FOUND_GIT=$?
  if [[ "$FOUND_GIT" -ne '0' ]]; then
    echo '******************* Attempting to install git.'
   
    if [[ "${FOUND_APT}" -eq '0' ]]; then
      apt-get -q -y update
      apt-get -q -y install git
      echo '******************* git installed.'
    else
      echo '******************* ******************* No package installer available. You may need to install git manually.'
    fi
 else
    echo '******************* git found.'
 fi

if [[ "$(dpkg --get-selections | grep "ruby-dev")" = "" ]]; then
    echo '******************* Installing ruby-dev'
    apt-get -q -y update
    apt-get -q -y install ruby-dev
    echo '******************* Finished installing ruby-dev'
else
   echo '******************* ruby-dev found.'
fi
 
if [[ "$(gem list | grep "librarian-puppet")" = "" ]]; then
    echo '******************* Installing librarian-puppet'
    gem install librarian-puppet
    echo '******************* Finished installing librarian-puppet'

    echo '******************* Running librarian-puppet install modules'
    cd $PUPPET_DIR && librarian-puppet install --clean
    echo '******************* ******************* Finished librarian-puppet install modules'
    
else
  echo '******************* Running librarian-puppet update modules'
   cd $PUPPET_DIR && librarian-puppet update
  echo '******************* Finished librarian-puppet update modules'
fi
