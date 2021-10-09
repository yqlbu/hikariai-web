---
title: "Run YOLOv3 Object Detection On Your Edge Device"
image: "images/post/post-09.jpg"
date: 2020-04-30
author: "Kevin Yu"
tags: ["Edge AI", "YOLO"]
categories: ["Artificial Intelligence"]
draft: false
---

[ YOLOv3 ](https://pjreddie.com/darknet/yolo/) is a popular DNN (Deep Neural Network) object detection algorithm, which is really fast and works also on not so powerful devices. The YOLO object detector is often cited as being one of the fastest deep learning-based object detectors, achieving a higher FPS rate than computationally expensive two-stage detectors (ex. Faster R-CNN) and some single-stage detectors (ex. RetinaNet and some, but not all, variations of SSDs).

The YOLOv3 is still not fast enough to run on embedded devices such as the Raspberry Pi, and the Jetson Nano. To help make YOLO even faster, Redmon et al. (the creators of YOLO), defined a variation of the YOLO architecture called Tiny-YOLO.

Today, we are going to dig into Object Detection with YOLOv3 on the Edge. The JetsonAGX Xavier (32G) with 512 CUDA cores is used for the demo.

Quick Link: https://github.com/yqlbu/Yolov3-Darknet

{{< toc >}}

---

### Demo

Object Detector on an image input

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-09-demo001.png)

---

Object Detector on a video input

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-09-maxresdefault.jpg)

---

### Setup

Clone the Repository

```bash
$ cd ${HOME}
$ git clone https://github.com/yqlbu/Yolov3-Darknet
$ cd Yolov3-Darknet
```

Run the Installation Script

```bash
$ sudo chmod +x install.sh
$ ./install.sh
```

### How to use

Run the demo scripts below

```bash
# Image Input
$ ./image.sh

# Video Input
$ ./video.sh

# Live Camera
$ ./camera.sh
```

Notes: You may change the weight to `yolov3-tiny.weights`

```bash
# Notes:
# You may change the config and weight to yolov3-tiny in the script

# The script (video.sh) for tiny-YOLO is shown as below
# You may modify image.sh and camera.sh accordingly

#!/bin/bash

export PATH=${HOME}/darknet
cd ${HOME}/darknet
./darknet detector demo \
cfg/coco.data \
cfg/yolov3-tiny.cfg \
yolov3-tiny.weights \
-width 416 -height 416 \
-ext_output shinjuku.mp4
```

---

### Conclusion

The Tiny-YOLO architecture is approximately 450% faster than it’s larger big brothers, achieving upwards of 80 FPS on the Jetson AGX Xavier, and of around 12 FPS on the Jetson Nano.

The small model size (< 50MB) and fast inference speed make the Tiny-YOLO object detector naturally suited for embedded computer vision/deep learning devices such as the Raspberry Pi, Google Coral, and NVIDIA Jetson Nano.

As for trade-offs, since Tiny-YOLO is a smaller version than its big brothers, this also means that Tiny-YOLO is unfortunately even less accurate. I think that it is still a good fit for deploying Real-time Object Detection application on Edge devices such as the Raspberry Pi and the Jetson Nano, running at around at 10~12FPS.

To learn more information about the YOLOv3 darknet, please visit [ here ](https://github.com/AlexeyAB/darknet).

---

I will publish more YOLOv3 articles covering topics such as Training on the Cloud, Make Custom Dataset, and YOLOv3 + Deepsort for Object Tracking, so please stay tuned to my site.

Happy coding !

---
