---
title: "Jetson Software Setup"
image: "images/post/post-02.jpg"
socialImage: "/images/post/post-02.jpg"
date: 2020-04-20
author: "Kevin Yu"
tags: ["Edge AI", "Jetson"]
categories: ["Artificial Intelligence"]
draft: false
---

Quick Link: https://www.github.com/yqlbu/jetson-install

I’ve been playing around with my Jetson Nano and Jetson AGX Xavier development kits for a few weeks. I found out that it might be a bit hard for beginners to get started with the development kits. For this reason, I would like to document all steps that I apply to set up the software development environment on the Jetson Series (Nano, TX2, and AGX Xavier). Hence, this article would probably save loads of time for people who are new to the Nvidia Edge AI platform.

---

### Basic Setup for Jetson

For now, the Jet Pack 4.3 comes with all the necessary Toolkits including CUDA 10.0, cuDNN 7, OpenCV, and TensorRT libraries. The Ubuntu LTS image for the Jetson Nano DevKit also pre-installed the above software, so you do not need to download them again. However, if you tend to use Virtual environments or Conda environments, which I strongly recommended, you will need to know how to link the library properly to your environments.

CUDA toolkit related paths are not set in the environment variables. For example, “nvcc” is not in ${PATH} by default. You need to manually export the CUDA paths into the PATH and LD_LIBRARY_PATH variables. To do so, please use the following scripts:

```bash
$ cd ${HOME}
$ git clone https://github.com/yqlbu/jetson-install
$ cd jetson-install/
$ ./set_cuda.sh
```

At the next login or at a new terminal window, the CUDA environment variables should have been set up properly.

---

### Add more SWAP

Since memory (4GB) on the Jetson Nano is rather limited, If you are using TX2 or AGX Xavier, you might not need to worry about the memory problem. However, for Jetson Nano the limited memory is going to affect your normal usage. Since memory (4GB) on the Jetson Nano is rather limited, you need to create and mount a swap file on the system so that it will not shut down automatically while running programs. You may adjust the swap file size based on your needs, but as for recommendation, you might need at least a 4G swap file. To do so, type the shell commands below:

```bash
$ sudo fallocate -l 4G /mnt/4GB.swap
$ sudo mkswap /mnt/4GB.swap
$ sudo swapon /mnt/4GB.swap
$ sudo reboot
```

Once the above commands are working, add the following line into /etc/fstab and reboot the system. Make sure the swap space gets mounted automatically after reboot.

```
/mnt/8GB.swap  none  swap  sw 0  0
```

You should be all set with the memory concern issue.

---

### Auto-Fan-Control script

Here is a script for controling the pwm fan with the change of the CPU temperature on the Jetson AGX Xavier DevKit. I might also work with the Jetson TX2 and Jetson Nano as long as it is hooked up with a PWM fan.

This fan control script has three modes 0 , 1 , 2 and its set to different value of pwm. The default pwm values associated with mode 0 , 1 , 2 are 80, 150 , 255 accordingly. You may modify the pwm value associated with the mode in the script on your own need.

Check out the demo below:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-02-demo.png)

To use it, please follow the instructions in the [Repo](https://github.com/yqlbu/fan-control), or visit the [site](https://hikariai.net/pwm-fan/) for more info.

---

### Install Softwares

I wrote a script to install the most important software based on aarch64 architecture you may need for development on your jetson kit. It is compatible with TX1, TX2, Nano, Xavier, and even Raspberry Pi. There are 11 software listed. You may check out the detailed description for each software on my [Github Repo](https://www.github.com/yqlbu/jetson-install)

```bash
$ cd ${HOME}
$ git clone https://github.com/yqlbu/jetson-install/
$ sudo chmod +x install.sh
$ ./install.sh
```

Clone the repository, install, and enjoy !!

![](<https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-02-demo%20(1).png>)

Personally, I strongly recommend you install Nomachine (Remote Login), Jetson-stats (A system monitor software tailored for Jetson devices), Jupyter Lab (Code IDE with Markdown), and finally Archiconda (The most advanced environments manager). I will publish more articles about the setup and usage of the software above, so stay tuned to my site.

---
