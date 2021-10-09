---
title: "Cloud Computing Series #1 — Train Yolov3 Custom Object Detection Model with Colab"
image: "images/post/post-12.jpg"
date: 2020-05-10
author: "Kevin Yu"
tags: ["Cloud", "Cloud Computing", "Deep Learning"]
categories: ["Cloud Computing"]
draft: false
---

In the [ previous post ](http://hikariai.net/blog/start-your-cloud-computing-journey-with-colab/), we have walked through the basics of using [ Google Colab ](https://colab.research.google.com/). In this article, we will be doing an experiment on training a custom object detection model on the Cloud ! Let’s get started.

In this experiment, the custom object detection model will be trained based on a YOLOv3-tiny Darknet Weight. If you have never tried Yolov3 Object Detector, you may visit my previous [ YOLOV3 post ](http://hikariai.net/run-yolov3-object-detection-on-your-edge-device/), or you may visit the [ YOLOV3 site ](https://pjreddie.com/yolo/) for more information.

Yolov3 Dataloader (Google Colab) V2 is tailored for those who want to train their custom dataset on a `Yolov3-tiny Model`. I have not tested it with the normal Yolov3 weight, but feel free to try modifying the parameters in the config file. If you following the `instructions` in the Notebook step by step and run `every cell accordingly`, it will generate a new trained-weight in the end, and you may download it from Colab to your local machine. The reason why I configured this training with YOLOv3-tiny is that it is much easier to deploy it to the `Edge devices` such as Raspberry Pi and Jetson Nano. In this experiment, I deployed it on my `Jetson AGX Xavier` with satisfactory outputs.

{{< toc >}}

---

### Download the Notebook

I wrote a Jupyter Notebook for training. You may download it directly with the [LINK](https://objectstorage.ca-toronto-1.oraclecloud.com/n/yzpqsgba6ssd/b/bucket-20200415-0121/o/yolov3_dataloader_cloud_v2.ipynb), and you may clone it with my [ repo ](https://github.com/yqlbu/yolov3-dataloader-cloud-v2/).

Upload it to Colab

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.08.48-AM-2048x1119.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.09.43-AM-2048x960.png)

---

### Setup the Environment on Colab

#### Initialize a Runtime

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.11.30-AM.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.11.52-AM-2048x1019.png)

#### Check GPU Type

I wrote a Python script for checking if you receive a `P100` or a `T4` GPU in your runtime. Simply copy and paste the scripts below to the cell and run it. If you do not get a P100 or a T4, then you may go to the Menu bar, and find Runtime >> Factory rest runtime, and your Colab VM will be re-initialized.

```bash
# Check if you get a P4 or a P100 Nvidia GPU
# If you get a K80, you may reset the runtime

gpu_info = !nvidia-smi
gpu_info = '\n'.join(gpu_info)
if gpu_info.find('failed') >= 0:
  print('Select the Runtime → "Change runtime type" menu to enable a GPU accelerator, ')
  print('and then re-execute this cell.')
else:
  print(gpu_info)
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-colab-p100-1.png)

---

### Make Your Dataset

I used a tool called [ LabelImg ](https://github.com/tzutalin/labelImg) to label all my images for training. You may check out a good tutorial on how to make your dataset with LabelImg [HERE](https://www.arunponnusamy.com/preparing-custom-dataset-for-training-yolo-object-detector.html). The labeling process is somewhat tedious, but it is a must for training a custom dataset.

You may use the commands below to download LabelImg on Ubuntu 18.04. If you are a windows user, you may check out the installation guide [HERE](https://github.com/tzutalin/labelImg).

```bash
$ sudo apt-get install pyqt4-dev-tools
$ sudo apt-get install python-lxml
$ sudo apt-get install python-qt4
$ sudo apt install libcanberra-gtk-module libcanberra-gtk3-module
$ git clone https://github.com/tzutalin/labelImg.git
$ cd labelImg
$ make qt4py2
$ python labelImg.py
```

By the end of the labeling process, your dataset folder should look something as shown below.

{{< notice "info" >}}
Each image should have one `.xml` file with it, and both the image and the `.xml` file have the same name.
{{< /notice >}}

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.29.44-AM.png)

---

### Config the Training

The step is the most important step for in entire training process. If you mess it up, you might not get a good output weight as expected.

You need to update FOUR parameters before initializing the training process. `MODEL_NAME`, `CLASS_NAME`, `CLASS_NUM`, and `MAX_BATCHES`. You may find the descriptions for these four parameters in the Notebook as shown below.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.40.37-AM-2048x1188.png)

Go through the steps, and run each cell exactly once. If you are doing all steps correctly, your file structure should like something as shown below:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-Screen-Shot-2020-04-25-at-12.49.01-AM-2048x1190.png)

{{< notice "info" >}}
Notes: the `MODEL_NAME` is the default name in the config, you need to update the parameters based on your own preference.
{{< /notice >}}

---

### Start Training

Check if the directory contains the `.data`, the `.names`, and the `.cfg` files. If you miss one or more of the files, please check the instructions from the above steps.

Once the training process starts, you should have a similar output as shown below:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-training-2048x906.png)

The total training time with my Pastry model (contains 200 images) takes roughly 30 minutes with a `P100 GPU`. However, it takes more than an hour on my Xavier to finish the training. As you can tell, the `P100` is a costly but very powerful GPU for Deep Learning

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-training-done-2048x559.png)

You can observe a chart of how your model did throughout the training process by running the below command. It shows a chart of your average loss vs. iterations. For your model to be ‘accurate’ you would aim for a loss under `1`.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-training-graph-2048x1104.png)

Once the training has finished, the final weight will be saved to the `/content/yolov3-dataload/backup` directory.

---

### Test the results

Image Input

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-img-predict-1-2048x891.png)

Video Input

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-12-eggtart-demo-2048x1152.png)

---

### Conclusion

With this YOLOv3-Dataloader tool, you may easily train your own YOLOv3-tiny Object Detection Model on the Cloud, and it is `TOTALLY FREE`. If you encounter a disconnection issue, you may just hit the Reconnect button, your data will not lose, and the training process should not be terminated unless you manually restart the runtime. For one-time usage, Colab allows you to activate a runtime for a continuous `12-hour usage`, and it is good enough for a normal training process. I hope you could find something useful in this post. Happy training !

---
