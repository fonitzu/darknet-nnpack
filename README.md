# Darknet with NNPACK
NNPACK was used to optimize [AlexeyAB/darknet](https://github.com/AlexeyAB/darknet) without using a GPU. It is useful for embedded devices using ARM CPUs.

## Automated build for Raspberry Pi 3

The newly added script `build_raspberry3.sh` automatically builds Darknet with
NNPACK for a 64-bit Ubuntu running on Raspberry Pi 3.

The script solves the usual build issues with Ninja and NNPACK
(`pthreadpool_deallocate` isn't defined,
see https://github.com/digitalbrain79/darknet-nnpack/issues/50).

To build Darknet:
```
git clone https://github.com/fonitzu/darknet-nnpack.git
cd darknet-nnpack
./raspberry3.sh
```

This build script was tested using following system configuration:
 - Raspberry Pi 3 Model B Rev 1.2,
 - make: GNU Make 4.3,
 - cmake: cmake version 3.18.4,
 - gcc: gcc (Ubuntu 10.3.0-1ubuntu1) 10.3.0,
 - Ubuntu 21.04, Linux 5.11.0-1008-raspi, Architecture: arm64,

The remaining Readme was left as reference.

## Build from Raspberry Pi 4
Log in to Raspberry Pi using SSH.<br/>
Install [PeachPy](https://github.com/Maratyszcza/PeachPy) and [confu](https://github.com/Maratyszcza/confu)
```
sudo pip install --upgrade git+https://github.com/Maratyszcza/PeachPy
sudo pip install --upgrade git+https://github.com/Maratyszcza/confu
```
Install [Ninja](https://ninja-build.org/)
```
git clone https://github.com/ninja-build/ninja.git
cd ninja
git checkout release
./configure.py --bootstrap
export NINJA_PATH=$PWD
```
Install clang
```
sudo apt-get install clang
```
Install [NNPACK-darknet](https://github.com/digitalbrain79/NNPACK-darknet.git)
```
git clone https://github.com/digitalbrain79/NNPACK-darknet.git
cd NNPACK-darknet
confu setup
python ./configure.py --backend auto
$NINJA_PATH/ninja
sudo cp -a lib/* /usr/lib/
sudo cp include/nnpack.h /usr/include/
sudo cp deps/pthreadpool/include/pthreadpool.h /usr/include/
```
Build darknet-nnpack
```
git clone https://github.com/digitalbrain79/darknet-nnpack.git
cd darknet-nnpack
make
```

## Test
COCO trained weights files can be downloaded from the [AlexeyAB/darknet](https://github.com/AlexeyAB/darknet).
```
COCO
./darknet detector test cfg/coco.data [cfg file] [weights file] [image path]
```
```
Pascal VOC
./darknet detector test cfg/voc.data [cfg file] [weights file] [image path]
```
## Results
#### COCO
cfg | Build Options | mAP | Prediction Time (seconds)
:-:|:-:|:-:|:-:
yolov3-tiny.cfg | NNPACK=1 | 33.1 | 1.1
yolov3-tiny.cfg | NNPACK=0 | | 14.5
yolov3-tiny-prn.cfg | NNPACK=1 | 33.1 | 0.86
yolov3-tiny-prn.cfg | NNPACK=0 | | 9.3

#### Pascal VOC
cfg | Build Options | mAP | Prediction Time (seconds) | Weights file
:-:|:-:|:-:|:-:|:-:
yolov3-tiny-voc.cfg | NNPACK=1 | 65.9 | 1.0 | [yolov3-tiny-voc.weights](https://drive.google.com/open?id=1gP531RumQnuGlMUUcQgymktatWajF4mH)
yolov3-tiny-voc.cfg | NNPACK=0 | | 14.0 |
yolov3-tiny-prn-voc.cfg | NNPACK=1 | 65.2 | 0.77 | [yolov3-tiny-prn-voc.weights](https://drive.google.com/open?id=1NljMzqeFxu0Kr04iftjc-zSL0Nxkns1n)
yolov3-tiny-prn-voc.cfg | NNPACK=0 | | 8.9 |
Gaussian_yolov3-tiny-voc.cfg | NNPACK=1 | 65.7 | 1.0 | [Gaussian_yolov3-tiny-voc.weights](https://drive.google.com/open?id=1qHdCsYsyvPX37pNoYpoug-FUUtu_1HxM)

## Raspberry Pi OS Image
Download OS image from [here](https://drive.google.com/open?id=1D9XRKn8eYiGokf_uN1Pwkqtnt_ae5SAQ)
```
sudo dd bs=4M if=darknet-nnpack.img of=/dev/sdX conv=fsyn
```
