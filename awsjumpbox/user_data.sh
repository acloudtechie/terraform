#!/usr/bin/env bash
sudo yum update -y
sudo yum install git -y
wget "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.45-linux-amd64"
chmod +x bosh-cli-*
sudo mv bosh-cli-* /usr/local/bin/bosh
sudo yum install -y gcc gcc-c++ ruby ruby-devel mysql-devel postgresql-devel postgresql-libs sqlite-devel libxslt-devel libxml2-devel patch openssl
gem install yajl-ruby
mkdir scripts
