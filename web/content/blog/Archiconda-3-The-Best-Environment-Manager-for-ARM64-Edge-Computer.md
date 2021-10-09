---
title: "Archiconda 3 — The Best Environment Manager for ARM64 Edge Computer"
image: "images/post/post-08.jpg"
date: 2020-04-28
author: "Kevin Yu"
tags: ["Edge AI", "Software"]
categories: ["Software"]
draft: false
---

Archiconda3 is a distribution of conda for 64 bit ARM. [ Anaconda ](https://www.anaconda.com/distribution/) is a free and open-source distribution of the Python and R programming languages for scientific computing (data science, machine learning applications, large-scale data processing, predictive analytics, etc.), that aims to simplify package management and deployment. Like Virtualenv, Anaconda also uses the concept of creating environments so as to isolate different libraries and versions. Check out my [ repo ](https://github.com/yqlbu/archiconda3/) for the installation guide.

{{< toc >}}

---

### Why using Archiconda 3 is a Plus for Edge Devices?

Conda is a cross platform package and environment manager that installs and manages conda packages from the Anaconda repository as well as from the Anaconda Cloud. Conda packages are binaries. There is never a need to have compilers available to install them. Additionally conda packages are not limited to Python software. They may also contain C or C++ libraries, R packages or any other software.

This highlights a key difference between conda and pip. Pip installs Python packages whereas conda installs packages that may contain software written in any language. For example, before using pip, a Python interpreter must be installed via a system package manager or by downloading and running an installer. Conda, on the other hand, can install Python packages as well as the Python interpreter directly.

For Edge devices such as the Raspberry Pi and the Jetson Nano, it is very crucial to set up different environments for different projects. For instance, you intend to build a project that requires the TensorFlow==2.1 and its dependencies in the environment, whereas you have already installed the TensorFlow==1.5. You have to make a decision either to uninstall the older version of Tensorflow to install the newer version one, or to keep the older one and work on another project. Archiconda 3 can tackle this problem well. You may create multiple conda environments to install different versions of TensorFlow ! Check out the demo below, and you will know what exactly I am talking about xD

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-08-conda-screenshot-2048x635.jpg)

---

### Setup

I created a script for a quick installation. You may also follow the instructions on my [ repo ](https://github.com/yqlbu/archiconda3/) to install.

```bash
# Download the installation script and run it
$ cd ${HOME}
$ git clone https://github.com/yqlbu/archiconda3
$ sudo chmod +x install.sh
$ ./install.sh

# Check the version, if conda is successfully installed, you will see the version info on the terminal.
$ conda -V
```

---

### How To Use

Create/Delete an environment

```bash
# --To create an environment--
$ conda create --name envname (replace envname in your preference)

# --To create an environment with a specific version of Python--
$ conda create -n envname python=3.6 (replace envname in your preference)

# --To delete an environment--
$ conda remove -n envname --all (replace envname in your preference)

# --To remove an environment--
$ conda remove -n envname --all (replace envname in your preference)
```

Grant the current user permission

```bash
$ sudo chown -R username ~/archiconda3
```

Activate/Deactivate the environment

```bash
# --To activate the environment--
$ conda activate envname (replace envname in your preference)

# --To deactivate the environment--
$ conda deactivate

# --To prevent conda from activating the base environment by default--
$ conda config --set auto_activate_base false
```

Install packages within an environment

```bash
# --To install a specific package such as SciPy into an existing environment--
$ conda install --name envname pkgname

# --To add more conda channels
$ conda config add --channels channel-name
# ie. add forge-conda
$ conda config add --channels forge-conda

# --If you do not specify the environment name,
# which in this example is done by --name myenv,
# the package installs into the current environment--
$ conda install pkgname

# --Upgrade pip--
$ python -m pip install --upgrade pip

# --Check pip version (Note please make sure you check the path of the pip,
# or the packages installed with pip/pip3 might not be installed in the conda environment)--
$ which pip
$ which pip3
```

List all the environments in conda

```bash
$ conda env list
```

Run jupyter notebook/lab inside the conda virtualenv

```bash
$ sudo chown -R username <PATH\TO>/archiconda
$ conda install -c conda-forge jupyterlab
# install the conda kernel inside a virenv
$ conda activate envname (replace envname in your preference)
$ conda install -c anaconda ipykernel
$ pip3 install --upgrade --force jupyter-console

# Add an env to jupyter
$ ipykernel install --user --name=envname (replace envname in your preference)

# Remove an env from jupyter
$ jupyter kernelspec uninstall envname (replace envname in your preference)

# List the existing environments
$ jupyter kernelspec list
```

Reference: https://medium.com/@nrk25693/how-to-add-your-conda-environment-to-your-jupyter-notebook-in-just-4-steps-abeab8b8d084

---

Run jupyter lab remotely from your client machine

```bash
# For instance, you may open jupyter notebook/lab from a windows/mac machine a client.

# -- In the server machine, type the following commands:
$ jupyter lab --generate-config
$ sudo find / -name jupyter_notebook_config.py #it will display the path of the config file
$ vi <PATH\TO\CONFIG>/jupyter_notebook_config.py
# you may change the settings in your own preference.


# -- In your local client machine type the following commands:
$ rm ~/.ssh/known_hosts
$ ssh -L 8000:localhost:PORT username_@server_ip  #check the port by opening jupter lab, the default is 8888
$ jupyter lab
# note: you may change 8000 to whatever # in your preference
# (ig: ssh -L 8000:localhost:9999 kev@10.10.10.65 )
# Type the adrress with the customized in the web browser localhost:8000

# first-time login
# Copy the token from the server terminal
# Open a web browser from the client, type localhost:PORT (localhost:8000 as default)
# then it will prompt up a window to ask you to type in the token, just paste the token, and you should be good to go.
```

---

### Conclusion

- It is free and open-source.
- It has more than 1500 Python/R data science packages.
- Anaconda simplifies package management and deployment.
- It has tools to easily collect data from sources using machine learning and AI.
- It creates an environment that is easily manageable for deploying any project.
- Anaconda is the industry standard for developing, testing and training on a single machine.
- It has good community support you can ask your questions there.

---

Check out the video tutorial [ here ](https://www.youtube.com/watch?v=23aQdrS58e0&t=1383s), it is realy helpful !

---
