#!/bin/bash

sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm

sudo yum install -y python2-pip
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
sudo ln -s /bin/python3.6 /bin/python3
sudo ln -s /usr/bin/pip3.6 /bin/pip3

sudo yum install -y zlib-devel bzip2 bzip2-devel \
 readline-devel openssl-devel xz xz-devel \
 curl git gcc wget

sudo pip install --upgrade pip
sudo pip3 install --upgrade pip

sudo pip3 install xlrd numpy
sudo pip3 install pillow
sudo pip3 install matplotlib
sudo pip3 install scikit-learn
sudo pip3 install Pandas
sudo pip3 install scrapy
sudo pip3 install NLTK
sudo pip3 install bokeh
sudo pip3 install NetworkX
sudo pip3 install scipy
sudo pip3 install Seaborn
sudo pip3 install jupyter
sudo pip3 install beautifulsoup4
sudo pip3 install keras
sudo pip3 install tensorflow

mkdir ~/ipython
mkdir ~/ipython/data
cp data.txt ~/ipython/data
cp demo.ipynb ~/ipython
mkdir ~/.jupyter
cp jupyter_notebook_config.py ~/.jupyter

sudo cp /home/opc/ipython-notebook.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ipython-notebook
sudo systemctl start ipython-notebook
