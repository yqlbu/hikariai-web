---
title: "10-line Python Code for Object Detection with DetectNet"
image: "images/post/post-03.jpg"
date: 2020-04-21
author: "Kevin Yu"
tags: ["Edge AI", "Jetson"]
categories: ["Artificial Intelligence"]
draft: false
---

For those of you who already tried out the [ Jetson-Inference ](https://github.com/dusty-nv/jetson-inference/blob/master/docs/detectnet-camera-2.md) provided by Nvidia. You might also want to try out my 10-line Python Code for real-time Object Detection with detectNet Engine. I hope you would enjoy it xD!

If you have not tested out the jetson-inference, you may find the repo [ here ](https://github.com/dusty-nv/jetson-inference/blob/master/docs/building-repo-2.md).

**Please make sure you have compiled [ jetson-inference ](<https://github.com/dusty-nv/jetson-inference/blob/master/docs/detectnet-camera-2.md(opens%20in%20a%20new%20tab)>) properly**. Otherwise, the code below will not work. Before you run the demo, I recommend you to max out the performance on your Jetson Kit. To do so, you may type the following commands on your console:

```
$ sudo nvpmodel -m 0
$ sudo jetson_clocks
```

---

### Demo (on Jetson AGX Xavier)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-03-Screen-Shot-2020-04-20-at-12.06.40-AM.png)

The Python interface is very simple to get up & running. Here’s an object detection example in 10 lines of Python code using SSD-Mobilenet-v2 (90-class MS-COCO) with TensorRT, which runs at 25FPS on Jetson Nano and at 190FPS on Jetson Xavier on a live camera stream with OpenGL visualization:

---

#### Setup environment

```
$ export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
$ export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

---

#### Create a demo script

```
$ cd ${HOME}
$ touch detect.sh
$ gedit detect.sh
```

Insert the codes below to the script

```python
#!/usr/bin/python

import jetson.inference
import jetson.utils

net = jetson.inference.detectNet("ssd-mobilenet-v2")
camera = jetson.utils.gstCamera(640, 480, "/dev/video0")
display = jetson.utils.glDisplay()

while display.IsOpen():
    img, width, height = camera.CaptureRGBA()
    detections = net.Detect(img, width, height)
    display.RenderOnce(img, width, height)
    display.SetTitle("Object Detection | Network {:.0f} FPS".format(1000.0 / net.GetNetworkTime()))
```

---

#### Test it out and enjoy!

```
$ sudo chmod +x detect.sh
$ ./detec.sh
```

You can even re-train models onboard Nano using [ PyTorch and transfer learning ](https://github.com/dusty-nv/jetson-inference/blob/master/docs/pytorch-transfer-learning.md) ! Example datasets for training a Cat/Dog model and Plant classifier are provided, in addition to a camera-based tool for collecting and labeling your own datasets:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-03-0.jpg)

Have fun training!

---
