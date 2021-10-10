---
title: "Face Recognition API on the Jetson"
image: "images/post/post-16.jpg"
date: 2020-05-25
author: "Kevin Yu"
tags: ["Edge AI", "Jetson", "IoT", "Object Recognition", "Face Recognition"]
categories: ["Artificial Intelligence"]
draft: false
---

When it comes to `Face Recognition` there are many options to choose from. While most of them are cloud-based, I decided to build a hardware-based face recognition system that does not need an internet connection which makes it particularly attractive for robotics, embedded systems, and automotive applications. The project is built based on Dlib that is able to compile with CUDA, which means, the detector can run with GPU on the Jetson.

In this post, we will walk through how to build a Face Recognition API and deploy it on the Jetson Family. All the demo are tested on my Jetson AGX DevKit, and it should work like a charm on any other Jetson Devices such as Nano and TX2.

Quick Link to the repo: https://github.com/yqlbu/face_recognizer

{{< toc >}}

---

### Demos

#### Demo #1: Recognizer

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-16-recognizer-2048x766.png)

---

#### Demo #2: Detector

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-16-detector-1-2048x718.png)

---

#### Demo #3: Live-demo

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-16-live-demo.gif)

---

### Dependencies

The Face Detection API depends on the following libraries:

- `*` Dlib
- `*` Face_recognition
- `*` Pickle
- `*` OpenCV

[ OpenCV ](https://opencv.org/) and [ Pickle ](https://docs.python.org/3/library/pickle.html) are pre-installed with JetPack, so do not need to be reinstalled.

[ Dlib ](http://dlib.net/) is a general purpose cross-platform software library written in the programming language C++. Its design is heavily influenced by ideas from design by contract and component-based software engineering. Thus it is, first and foremost, a set of independent software components. It is open-source software released under a Boost Software License.

The [ face_recognition ](https://pythonhosted.org/face_recognition/readme.html) package is a Python package made by Adam Geitgey that makes it easy to do face recognition, face identification, and more. It is popular in computer vision with Python because it is very easy to use and works without a machine learning framework. Built using dlib’s state-of-the-art face recognition built with deep learning.

---

### Setup

Installing Dlib and face_recognition

Simply clone the [ repo ](https://github.com/yqlbu/face_recognizer) and then run the `setup.sh` script

```bash
$ cd ~
$ git clone https://github.com/yqlbu/face_recognizer
$ cd face_recognizer/
$ sudo chmod +x setup.sh
$ ./setup.sh
```

---

### How To Use

Train custom dataset

{{<notice "note">}}
You may customize the dataset inside /images based on your own need. To do so, you need to correctly name the image file for each image inside /images
{{</notice>}}

```bash
$ python3 training.py
```

Recognize unknown faces

```bash
$ python3 recognizer.py
```

Run the detector to identify faces of an input image

```bash
$ python3 detector.py
```

{{<notice "note">}}
Each time we grab a frame of video, we’ll also shrink it to half of its size. This will make the face recognition process run faster at the expense of only detecting larger faces in the image. You may change the scale by modifying the line of code (Line 12) in the script below
{{</notice>}}

```bash
scale = 0.5 # modify the scale based on your need
```

Run the detector in real-time to identify faces of an input stream

{{<notice "note">}}
The input sources are not limited to Camera stream, but any form of MJPEG streams such as Video, RTSP, and HTTP Stream
{{</notice>}}

```bash
$ python3 live-demo.py
```

{{<notice "note">}}
Each time we grab a frame of video, we’ll also shrink it to 1/4 of its size. This will make the face recognition process run faster at the expense of only detecting larger faces in the image. You may change the scale by modifying the line of code (Line 15) in the script below:
{{</notice>}}

```bash
scale = 0.25 # modify the scale based on your need
```

---

### Conclusion

This project is built with the face_recognition package, which is very easy to use. Even though you are not familiar with the Machine Learning frameworks like Tensorflow, Pytorch, you can easily make a program that detects human face, identifying the person using the face_recognition package.

You may try to warp this program into something entirely different. The pattern of reading a frame of video, looking for something in the image, and then taking an action is the basis of all kinds of computer vision systems. Furthermore, you may also integrates this Face Recognition API to other IoT modules such as Servo, PWM, etc so that they can work together to achieve many goals in real-life applications.

The face_recognition depends on the Dlib package. As you can tell by running the demos, the FPS is not high though, it may due to the consistency of Dlib and CUDA. Therefore, if the Dlib package’s performance improves, the face_recognition’s performance will be automatically improved. So always keep an eye on the version of these packages.

---
