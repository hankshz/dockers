#!/bin/bash

set -e

apt-get update
apt-get install -y bzip2 wget

chmod +x /raw/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh
/bin/bash /raw/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p ${ANACONDA_BUILD}
conda install -y keras
mkdir /root/.jupyter
cp /raw/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
