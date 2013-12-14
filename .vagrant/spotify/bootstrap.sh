#!/usr/bin/env bash

# Add Spotify APT repo
cp /vagrant/spotify.list /etc/apt/sources.list.d/

# Install and update packages
apt-get update
apt-get install -y --force-yes spotify-apt-keys
apt-get install -y --force-yes spotify-maven-config \
                   spotify-hermes-utils \
                   spotify-python-dht-tools \
                   git-completion
