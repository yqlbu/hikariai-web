---
title: "Useful Linux Commands for AI Development Series #3 (Advanced)"
image: "images/post/post-07.jpg"
socialImage: "/images/post/post-07.jpg"
date: 2020-04-27
author: "Kevin Yu"
tags: ["Linux", "Shell"]
categories: ["Linux"]
draft: false
---

This article is the last post in the Command Tutorial Series. In [ Series #1 (Basic) ](https://hikariai.net/blog/05-useful-linux-commands-for-ai-development-series-01-basic), we have walked through some useful commands for topics including File System Basics, File System Permission & Ownership, SSH (Remote Control), and Monitor System Loads (CPU, GPU, Memory). In [ Series #2 (Intermediate) ](https://hikariai.net/blog/06-useful-linux-commands-for-ai-development-series-02-intermediate/), we have walked through some useful commands for topics including Symbolic Links, Screen, Python pip installation and management, and Git Commands.

In this article, we will talk through more topics such as Shell Script, ONNX-TensorRT Conversion, Anaconda 3, and CUDA Setup.

{{< toc >}}

---

### Shell Script

#### Header

The first thing to do after you create an empty Bash Script is to append the following line to the first line of your script

```bash
#!/bin/bash
```

If it is a `Python-based` script, you may insert the following line to the first line of your script

```bash
#!/usr/bin/python
```

#### Variable

```bash
# To assign a value to a variable
variable=123  (no space is allowed aside "=")

# To parse a variable or to use it
${variable}
#eg #1:
new_value = ${variable}
#eg #2:
temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
echo "Current temperature : $temp C"

# To pass an argument from console to a variable inside the script
$1, $2, $3....$n refers to the input arguments from the console
#eg:
./test.sh A B C， $1 refers to A; $2 refers to B
```

#### Condition

```bash
#if statement
if condition
then
    command1
    command2
    ...
    commandN
fi

#if else
if condition
then
    command1
    command2
    ...
    commandN
else
    comand
fi
```

#### Equality

```bash
#  sign            reference
#  -eq               equal
#  -ne             not equal
#  -gt        n1 greater than n2
#  -lt          n1 less than n2
#  -ge    n1 greater than or equal to n2
#  -le      n1 less than or equal n2

# eg #1:

# if the parameter is not equal to 1, then execute the echo mand
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <Install Folder>"
    exit

# Note: make sure you have "space" placed aside the sign as the example shown.
# If you do if [ "$#"-ne1 ] or [ "$#"!=1 ] or ["$#" -ne 1], it is not going to work.
# ** Space does matter.

# eg #2:

# else if
if [ $1 -ge 18 ]
then
echo You may go to the party.
elif [ $2 == 'yes' ]
then
echo You may go to the party but be back before midnight.
else
echo You may not go to the party.
fi

# eg #3:

# multiple conditions AND example
if [ -r $1 ] && [ -s $1 ]
then
echo This file is useful.
fi

# eg #4:
# multiple conditions OR example
if [ $USER == 'bob' ] || [ $USER == 'andy' ]
then
ls -alh
else
ls
fi
```

I recommend check out more examples [ here ](https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php).

#### Save and Export Absolute Path

```bash
# Saves the absolute path of the current working directory to the variable cwd
$ cwd=$(pwd)
$ echo ${PWD}

# Export current PATH
$ export PATH=$(pwd)+somethingelse

# Export a specific PATH
$ export PATH=${HOME}/PATH
$ cd $PATH
```

#### User Input

```bash
# Ask the user for login details
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
echo
echo Thank you $uservar we now have your login details

* -p which allows you to specify a prompt
* -s which makes the input silent.

# Method #1 with read -p
read -p -> Put the package # you wish to install here: num

# Method #2 with echo -n
echo -n " -> Put the package # you wish to install here: $num"
read num


#Terminal (output of Method #1)

user@bash: ./login.sh
Username: ryan
Password:
Thankyou ryan we now have your login details
user@bash:
```

#### Function

```bash
function_example.sh

#!/bin/bash

# Define a basic function
print_something () {
echo Hello I am a function
}

# Execute the function
print_something

# Terminal Output
user@bash: ./function_example.sh
Hello I am a function
Hello I am a function
user@bash:
```

#### Execution

```bash
# Execute a script with "source"
# The shortcut of "source" is ". ", there is a space in between
# eg:
. tesh.sh
# OR
source tesh.sh

# However, if you want to write commands into ~/.bashrc, you need to use source ~/.bashrc

# Execute a script with "./"
# You need to give executable permission to your file
$ sudo chmod +x test.sh
$ ./test.sh

# Run a script as a command without "./" and ".sh"
$ sudo cp test.sh /usr/bin/test
$ test
```

---

### ONNX-TensorRT Conversion for YOLOv3

ONNX is an open format built to represent machine learning models. ONNX defines a common set of operators – the building blocks of machine learning and deep learning models – and a common file format to enable AI developers to use models with a variety of frameworks, tools, runtimes, and compilers. [ LEARN MORE ](https://onnx.ai/).

NVIDIA TensorRT™ is an SDK for high-performance deep learning inference. It includes a deep learning inference optimizer and runtime that delivers low latency and high-throughput for deep learning inference applications. [ LEARN MORE ](https://developer.nvidia.com/tensorrt).

#### Repo

I found a very useful repo for those who want to convert your ONNX model to the TensorRT Engine and run real-time inference applications with TensorRT. Check out the repo [ here ](https://github.com/onnx/onnx-tensorrt).

#### Demo

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-07-tensorrt-x-yolov3-2048x1152.png)

#### Note

This repo should work for both ARM64 and X86 computers as long as your environment setup meets all the requirements in the repo.

I strongly recommend setting up a virtual environment or conda environment for this project because you might encounter packages conflict issues.

#### Setup

```bash
# Check Tensorrt if already installed
$ dpkg -l | grep TensorRT

# Install ONNX
$sudo apt install protobuf-compiler libprotoc-dev
$pip install onnx==1.4.1

# Check tensorRT for Python3
$ pip list
# If it has not been installed yet,
# for x86 computer users, you will need to check out the Nvidia website for the installation guide.
# For Jetson users, you will need to copy the local packages to the environment libraries.
cd /usr/lib/python3.6/dist-packages/

# Copy the packages below
/usr/lib/python3.6/dist-packages/tensorrt
/usr/lib/python3.6/dist-packages/tensort-5.0.6.3.dist-info
/usr/lib/python3.6/dist-packages/graphsurgeon
/usr/lib/python3.6/dist-packages/graphsurgeon-0.3.2.dist-info
/usr/lib/python3.6/dist-packages/uff
/usr/lib/python3.6/dist-packages/uff-0.5.5.dist-info

# to ~/.virtualenvs/envname/lib/python3.6/site-packages
# or to ~/archiconda3/envname/lib/python3.6/site-packages
# or to ~/.conda/envname/lib/python3.6/site-packages
# envname is the name of your environment

# Download the source code
$ git clone https://github.com/jkjung-avt/tensorrt_demos

# Install pycuda
$ pip install pycuda

# Download yolov3 weight
$ cd ${HOME}/project/tensorrt_demos/yolov3_onnx
$ ./download_yolov3.sh

# Convert yolov3-416 model to onnx,
$ python3 yolov3_to_onnx.py --model yolov3-416

# Convert yolov3-416.onnx to yolov3-416.trt
$ python3 onnx_to_tensorrt.py --model yolov3-416
```

#### Test

```bash
# Download the testing image
$ wget https://raw.githubusercontent.com/pjreddie/darknet/master/data/dog.jpg -O ${HOME}/Pictures/dog.jpg
# Run the test
$ python3 trt_yolov3.py --model yolov3-416 --image --filename ${HOME}/Pictures/dog.jpg

# Or to open a USB Camera live show
$ python3 trt_yolov3.py --model yolov3-416 --usb --vid 0 --height 720 --width 1280

# Notes: for  opening a USB webcam, you need to modify a camera config file,
# located in ~\tensorrt_demos\utils\camera.py
# Set USB_GSTREAMER to false
USB_GSTREAMER = False       # True to False

# Or to use a media file as input
# Add the following attribute to run the trt_yolov3.py
--file --filename shinjuku.mp4
# It should look like
$ python3 trt_yolov3.py \
    --model yolov3-tiny-416 \
    --height 720 --width 1280 \
    --file --filename shinjuku.mp4
```

---

### Archiconda 3

Archiconda3 is a distribution of conda for 64 bit ARM. [ Anaconda ](https://www.anaconda.com/) is a free and open-source distribution of the Python and R programming languages for scientific computing (data science, machine learning applications, large-scale data processing, predictive analytics, etc.), that aims to simplify package management and deployment. Like Virtualenv, Anaconda also uses the concept of creating environments so as to isolate different libraries and versions.

For more information about the setup and usage of Archiconda 3, please visit the site [ here ](https://hikariai.net/edge-ai/archiconda3/).

---

### CUDA Setup

[ CUDA ](https://blogs.nvidia.com/blog/2012/09/10/what-is-cuda-2/) stands for Compute Unified Device Architecture, and is an extension of the C programming language and was created by Nvidia. Using CUDA allows the programmer to take advantage of the massive parallel computing power of an Nvidia graphics card in order to do general-purpose computation.

For Jetson Devices, you do not need to install CUDA and cuDNN because they are pre-installed in the JetPack. The setup below is mainly for computers running x86-based operation system and equipped with one or more Nvidia Graphic Cards.

Notes: If you want to set up CUDA on your cloud server, using the following setup should work.

CUDA 10.0

```bash
# Installation Instructions:
$ wget https://objectstorage.ca-toronto-1.oraclecloud.com/n/yzpqsgba6ssd/b/bucket-20200415-0121/o/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
$ sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
$ sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
$ sudo apt-get update
$ sudo apt-get install cuda

$ echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
$ echo 'export PATH=$PATH:$CUDA_HOME/bin' >> ~/.bashrc
$ echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64' >> ~/.bashrc

$ source ~/.bashrc

# Test if everything is working fine.

$ nvcc --version
$ nvidia-smi
```

cuDNN 10.0

```bash
$ wget https://objectstorage.ca-toronto-1.oraclecloud.com/n/yzpqsgba6ssd/b/bucket-20200415-0121/o/cudnn-10.0-linux-x64-v7.5.0.56.tgz
$ sudo tar -xzvf cudnn-10.0-linux-x64-v7.5.0.56.tgz -C /usr/local/
$ sudo chmod a+r /usr/local/cuda/include/cudnn.h

# install python-nvcc plugin
$ sudo apt install python3-pip
$ sudo -H pip3 install --upgrade pip
$ sudo apt-get install unzip
$ sudo pip install git+git://github.com/andreinechaev/nvcc4jupyter.git

# check if installed successfully
$ sudo /usr/local/cuda/bin/nvcc --version
```

---

That’s all the contents for the Useful Linux Commands for AI Development Series. I hope you find something useful for your project development. Good Luck !

---
