#!/bin/bash
# Copyright (c) 2020 Microsoft
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Installs OpenMPI version specified by enviroment variable OPENMPI_VERSION

OPENMPI_MAJOR_MINOR_VERSION=3.1
OPENMPI_PATCH_VERSION=2
OPENMPI_VERSION=${OPENMPI_MAJOR_MINOR_VERSION}.${OPENMPI_PATCH_VERSION}

apt update

# SSH and RDMA
apt install -y --no-install-recommends \
    libmlx4-1 \
    libmlx5-1 \
    librdmacm1 \
    libibverbs1 \
    libmthca1 \
    libdapl2 \
    dapl2-utils \
    openssh-client \
    openssh-server \
    iproute2
# Others
apt install -y build-essential
apt install -y \
    bzip2=1.0.6-8.1ubuntu0.2 \
    libbz2-1.0=1.0.6-8.1ubuntu0.2 \
    git=1:2.17.1-1ubuntu0.4 \
    wget \
    cpio \
    libsm6 \
    libxext6 \
    libxrender-dev \
    fuse
# apt clean -y
rm -rf /var/lib/apt/lists/*

mkdir /tmp/openmpi-${OPENMPI_VERSION}
wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_MAJOR_MINOR_VERSION}/openmpi-${OPENMPI_VERSION}.tar.gz -P /tmp/
tar zxf /tmp/openmpi-${OPENMPI_VERSION}.tar.gz --directory /tmp/
cd /tmp/openmpi-${OPENMPI_VERSION}
./configure --enable-orterun-prefix-by-default
make -j $(nproc) all
make install
ldconfig
rm -rf /tmp/openmpi-${OPENMPI_VERSION}