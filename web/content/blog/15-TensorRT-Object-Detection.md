---
title: "TensorRT Object Detection (DetectNet + OpenCV)"
image: "images/post/post-15.jpg"
socialImage: "/images/post/post-15.jpg"
date: 2020-05-20
author: "Kevin Yu"
tags: ["Edge AI", "Jetson", "Jetson-Inference", "Object Detection"]
categories: ["Artificial Intelligence"]
draft: false
---

Recently, I found a very useful library that can utilize TensorRT to massively accelerate DNN (Deep Neural Network) application — the [ Jetson-Inference ](https://github.com/dusty-nv/jetson-inference) Library developed by Nvidia.

The Jetson-Inference repo uses NVIDIA TensorRT for efficiently deploying neural networks onto the embedded Jetson platform, improving performance and power efficiency using graph optimizations, kernel fusion, and `FP16/INT8` precision. Vision primitives, such as `ImageNet` for image recognition, `DetectNet` for object localization, and `SegNet` for semantic segmentation, inherit from the shared `TensorNet` object. Examples are provided for streaming from live camera feed and processing images. See the API Reference section for detailed reference documentation of the C++ and Python libraries.

In this post, we will build an `Object Detection API` with `DetectNet` and `OpenCV`. OpenCV has many built-in functions that allow us to build versatile applications. Moreover, you may easily change input video sources as well.

{{< toc >}}

---

### Demo

#### SSD Mobilenet V2

The demo is running @ 200-225 FPS on my Jetson AGX Xavier DevKit.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-15-Screen-Shot-2020-05-15-at-3.36.11-PM-2048x1152.png)

---

#### Pednet

The demo is running @ 90-100 FPS on my Jetson AGX Xavier DevKit.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-15-detectnet-demo006-2048x807.png)

---

### Prerequisite

#### Quick Installation

This demo requires [ jetson-inference ](https://github.com/dusty-nv/jetson-inference) prebuilt in your Jetson Device. To do so, you may visit the [ repo ](https://github.com/dusty-nv/jetson-inference/blob/master/docs/building-repo-2.md) provided by Nvidia, or you may type in the following commands in the console.

```bash
$ sudo apt-get update
$ sudo apt-get install git cmake libpython3-dev python3-numpy
$ git clone --recursive https://github.com/dusty-nv/jetson-inference
$ cd jetson-inference
$ mkdir build
$ cd build
$ cmake ../
$ make -j$(nproc)
$ sudo make install
$ sudo ldconfig
```

If you have executed all the commands above with no error, you should be good to go. **Notes:** in the process, there will be windows named `Model Downloader`, and `Pytorch Installer` popped up, please carefully check out the descriptions in the sections below.

---

#### Download Models

The jetson-inference project comes with many pre-trained networks that can you can choose to have downloaded and installed through the Model Downloader tool (download-models.sh). By default, not all of the models are initially selected for download to save disk space. You can select the models you want, or run the tool again later to download more models another time.

When initially configuring the project, cmake will automatically run the downloader tool for you:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-15-download-models.jpg)

To run the Model Downloader tool again later, you can use the following commands:

```bash
# Executes the commands below ONLY IF you have successfully compiled the jetson-inference library
$ cd jetson-inference/tools
$ ./download-models.sh
```

---

#### Install PyTorch

If you are using JetPack 4.2 or newer, another tool will now run that can optionally install PyTorch on your Jetson if you want to re-train networks with transfer learning later in the tutorial. This step is optional, and if you don’t wish to do the transfer learning steps, you don’t need to install PyTorch and can skip this step.

If desired, select the PyTorch package versions for Python 2.7 and/or Python 3.6 that you want to be installed and hit Enter to continue. Otherwise, leave the options un-selected, and it will skip the installation of PyTorch.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-15-pytorch-installer.jpg)

---

### Quick Start

Once you have set up the jetson-inference library, you may simply copy the Python script below and run it on your local device.

```python
#!/usr/bin/python3
import numpy as np
import cv2
import jetson.inference
import jetson.utils

# setup the network we are using
net = jetson.inference.detectNet("ssd-mobilenet-v2", threshold=0.5)
cap = cv2.VideoCapture(0)
# cap = cv2.VideoCapture('video.mp4')
cap.set(3,640)
cap.set(4,480)

while (True):
    ret, frame = cap.read()
    frame = cv2.resize(frame, (640, 480))
    w = frame.shape[1]
    h = frame.shape[0]
    # to RGBA
    # to float 32
    input_image = cv2.cvtColor(frame, cv2.COLOR_RGB2RGBA).astype(np.float32)
    # move the image to CUDA:
    input_image = jetson.utils.cudaFromNumpy(input_image)

    detections = net.Detect(input_image, w, h)
    count = len(detections)
    print("detected {:d} objects in image".format(len(detections)))
    for detection in detections:
        print(detection)

    # print out timing info
    net.PrintProfilerTimes()
    # Display the resulting frame
    numpyImg = jetson.utils.cudaToNumpy(input_image, w, h, 4)
    # now back to unit8
    result = numpyImg.astype(np.uint8)
    # Display fps
    fps = 1000.0 / net.GetNetworkTime()
    font = cv2.FONT_HERSHEY_SIMPLEX
    line = cv2.LINE_AA
    cv2.putText(result, "FPS: " + str(int(fps)) + ' | Detecting', (11, 20), font, 0.5, (32, 32, 32), 4, line)
    cv2.putText(result, "FPS: " + str(int(fps)) + ' | Detecting', (10, 20), font, 0.5, (240, 240, 240), 1, line)
    cv2.putText(result, "Total: " + str(count), (11, 45), font, 0.5, (32, 32, 32), 4, line)
    cv2.putText(result, "Total: " + str(count), (10, 45), font, 0.5, (240, 240, 240), 1, line)
    # show frames
    cv2.imshow('frame', result)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
```

Execute the script:

```python
$ nano demo.py
# Copy and paste the content above
$ sudo chmod +x demo.py
$ ./demo.py
```

{{<notice "note">}}
By default, the program will open a V4L2 (WebCam) and import frames as stream input. You may modify the line “cap = cv2.VideoCapture(‘video.mp4’)” to pass a custom video file as input source.
{{</notice>}}

---

### Conclusion

Jetson-Inference guide to deploying deep-learning inference networks and deep vision primitives with TensorRT and NVIDIA Jetson. With such a powerful library to load different Neural Networks, and with OpenCV to load different input sources, you may easily create a custom Object Detection API, like the one shown in the demo.

The reason why this Object Detection API is faster than most of the frameworks is that it utilized TensorRT to accelerate the data processing, hence effectively enhancing the detection efficiency.

---
