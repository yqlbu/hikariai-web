---
title: "Start Your Cloud Computing Journey with Colab"
image: "images/post/post-11.jpg"
socialImage: "/images/post/post-11.jpg"
date: 2020-05-02
author: "Kevin Yu"
tags: ["Cloud", "Cloud Computing", "Deep Learning"]
categories: ["Cloud Computing"]
draft: false
---

Cloud computing is a term used to describe the use of hardware and software delivered via network (usually the Internet). The term comes from the use of cloud shaped symbol that represents abstraction of rather complex infrastructure that enables the work of software, hardware, computation and remote services.

Simply put, cloud computing is computing based on the internet. In the past, people would run applications or programs from software downloaded on a physical computer or server in their building. Cloud computing allows people access to the same kinds of applications through the internet.

{{< toc >}}

---

### Why Cloud Computing?

By using cloud infrastructure, you don’t have to spend huge amounts of money on purchasing and maintaing equipment. This drastically reduces capex costs. You don’t have to invest in hardware, facilities, utilities, or building out a large data center to grow your business. You do not even need large IT teams to handle your cloud data center operations, as you can enjoy the expertise of your cloud provider’s staff.

Cloud also reduces costs related to downtime. Since downtime is rare in cloud systems, this means you don’t have to spend time and money on fixing potential issues related to downtime.

AI applications are generally high performance when on servers with multiple and very fast Graphics Processing Units (GPUs). These systems are however extremely expensive and unaffordable for many organizations. AI as a service in cloud application development becomes accessible to these organizations at a more affordable price.

---

### Introduction to Colab

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-0_VxZTDRs7cpEqyqZP.jpg)

#### What is Google Colab

Colaboratory, or “Colab” for short, is a product from Google Research. Colab allows anybody to write and execute arbitrary python code through the browser and is especially well suited to machine learning, data analysis, and education. More technically, Colab is a hosted Jupyter notebook service that requires no setup to use, while providing free access to computing resources including GPUs. [LEARN MORE](https://research.google.com/colaboratory/faq.html)

If you have used Jupyter notebook previously, you would quickly learn to use Google Colab. To be precise, Colab is a free Jupyter notebook environment that runs entirely in the cloud. Most importantly, it does not require a setup and the notebooks that you create can be simultaneously edited by your team members – just the way you edit documents in Google Docs. Colab supports many popular machine learning libraries which can be easily loaded in your notebook. Check out the Hardware Spec [HERE](https://stackoverflow.com/questions/47805170/whats-the-hardware-spec-for-google-colaboratory)

With Colab, you can:
– improve your Python programming language coding skills.
– develop deep learning applications using popular libraries such as Keras, TensorFlow, PyTorch, and OpenCV.

#### Why Google Colab?

The most important feature that distinguishes Colab from other free cloud services is; Colab provides GPU and is `totally free`.

#### A Free P100 GPU?

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-output-onlinepngtools.png)

With Colab Pro you have priority access to our fastest GPUs. For example, you may get a T4 or P100 GPU at times when most users of standard Colab receive a slower K80 GPU. You can see what GPU you’ve been assigned at any time by executing the following cell. Colab offers you a free powerful GPU for up to 12 hrs at a time. It basically means you are able to run your application continuously for 12 hrs. After 12 hrs, the runtime will be rest, all the data will be lost, and you need to log in again, but 12 hrs runtime is good enough for doing a large scale application, for instance, training a neural network.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-colab-p100.png)

You may check out the price of a P100 GPU [HERE](https://www.microway.com/hpc-tech-tips/nvidia-tesla-p100-price-analysis/). I bet it may shock you.

---

### How to Set Up

Open New Colab Notebook

Login into [ Colab ](https://colab.research.google.com/) with your Google Credentials. You may then choose to Open a notebook from sources such as Google Drive and Github, or you may create a new one. I recommend opening the “Welcome To Colaboratory” if want to learn more basics of Colab.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-Screen-Shot-2020-04-24-at-10.03.40-PM-2048x1113.png)

#### Setting Free GPU

It is pretty simple to alter default hardware (CPU to GPU or vice versa); just follow `Edit` >> `Notebook settings` or `Runtime` >> `Change runtime type` and select `GPU` as Hardware accelerator.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-1_WNovJnpGMOys8Rv7YIsZzA.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-11-executing_code.png)

Hit the black circle on the left side of a cell to run all the commands or scripts inside that cell.

---

### Learn Colab Commands

Learning Colab Commands is very crucial because you might encounter problems such as installing python packages to the Colab Virtual Machine. Check out the link [HERE](https://colab.research.google.com/github/jakevdp/PythonDataScienceHandbook/blob/master/notebooks/01.05-IPython-And-Shell-Commands.ipynb) for learning Colab Commands. I would provide some basic commands that are essential for you to get started with Colab.

Basically you can execute bash shell commands with a “!” before the command, and navigate to a particular directory with “%cd” as the examples shown below:

```bash
# Install python packages started with "!"
!pip install package_name

# Navigate to a particular directory
%cd dir_path

# Show current path
!pwd
```

If you are not familiar with Linux Shell Commands, I recommend you check out the [ Linux Commands Series ](https://hikariai.net/blog/useful-linux-commands-for-ai-development-series-01-basic/) that I posted earlier in the week.

I also wrote a Python script for checking if you receive a `P100` or a `T4` GPU in your runtime. Simply copy and paste the scripts below to the cell and run it. If you do not get a P100 or a T4, then you may go to the Menu bar, and find Runtime >> Factory rest runtime, and your Colab VM will be re-initialized.

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

---

### Conclusion

Colab is a free cloud service based on Jupyter Notebooks for machine learning education and research. It provides a runtime fully configured for deep learning and free-of-charge access to a robust GPU.

The first thing you’ll notice using Colab notebooks is the handicap of dealing with a runtime that will blow up every 12 hours into the space! This is why is so important to speed up the time you need to run your runtime again.

You might want to check out more tricks and tips [HERE](https://dev.to/kriyeng/8-tips-for-google-colab-notebooks-to-take-advantage-of-their-free-of-charge-12gb-ram-gpu-be4)

I will publish more articles about Cloud Computing Applications in the future, so please stay tuned to my site, and good luck with your Cloud Computing journey !

---
