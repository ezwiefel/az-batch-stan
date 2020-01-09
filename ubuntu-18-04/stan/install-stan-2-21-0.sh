#!/bin/bash
# Copyright (c) 2020 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Installs STAN version specified by enviroment variable STAN_VERSION

STAN_VERSION=2.21.0
STAN_PATH=/usr/local/cmdstan-${STAN_VERSION}

apt update
apt install -y python-dev

mkdir ${STAN_PATH}
wget https://github.com/stan-dev/cmdstan/releases/download/v${STAN_VERSION}/cmdstan-${STAN_VERSION}.tar.gz -P /tmp
tar xvfz /tmp/cmdstan-${STAN_VERSION}.tar.gz --directory /usr/local/
cd ${STAN_PATH}
echo "STAN_MPI=true" >> ${STAN_PATH}/make/local
echo "CXX=mpicxx" >> ${STAN_PATH}/make/local
echo "TBB_CXX_TYPE=gcc" >> ${STAN_PATH}/make/local
make build -j $(nproc)

# Clean up
rm /tmp/cmdstan-${STAN_VERSION}.tar.gz

echo "STAN_PATH=${STAN_PATH}" >> /etc/environment
