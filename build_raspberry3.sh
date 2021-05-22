#!/usr/bin/bash

git clone https://github.com/fonitzu/NNPACK
cd NNPACK
confu setup
python ./configure.py --backend auto
mkdir build
cd build
cmake ..
make
cd deps/pthreadpool
PTHREAD_LIB=$(pwd)
cd ../../../..
echo $PTHREAD_LIB
make PTHREAD_LIB?=$PTHREAD_LIB
wget https://pjreddie.com/media/files/yolov3-tiny.weights
./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights data/dog.jpg


