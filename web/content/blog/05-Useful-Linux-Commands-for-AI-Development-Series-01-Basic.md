---
title: "Useful Linux Commands for AI Development Series #1 (Basic)"
image: "images/post/post-05.jpg"
socialImage: "/images/post/post-05.jpg"
date: 2020-04-25
author: "Kevin Yu"
tags: ["Linux", "Shell"]
categories: ["Linux"]
draft: false
---

The Linux command line is a text interface to your computer. Often referred to as the shell, terminal, console, prompt or various other names, it can give the appearance of being complex and confusing to use. This article will walk you through the most useful commands that you might need for your AI development, and you may also apply the techniques for your development on the Cloud. I’ll assume no prior knowledge, so let’s start with the basics.

{{< toc >}}

---

### File System

#### Navigate and Redirect

```bash
# Move to a specific directory
$ cd ./DIR_PATH

# Go back to the parent directory
$ cd ..

# Navigate to the HOME directory
$ cd ~
# OR
$ cd ${HOME}

# Get the path of the current directory
$ pwd
# OR
```

#### Show contents in a folder

```bash
# Only show the non-hidden files
$ ls
# Show all files including the hidden files
$ ls -a
# Show all files and their information such as file size
$ ls -lah
```

#### Create & Remove Files

```bash
# Create a folder
$ mkdir folder_name

# Create a file with an ext
$ touch file_name.ext
# Create a file inside an existing folder
$ touch folder_path/file_name.ext

# Remove a file or a folder
$ rm -rf file_path
# Remove all files in a folder
$ rm -rf *
```

#### Move a file or Rename a file

```bash
# Move a file to a specific directory
$ mv file_name path_directory

# Rename a File
$ mv original_filename new_filename
```

#### Find the path of a specific file/folder

```bash
# Find the path of a named file
$ find / -iname file_name  # may change "/" to a specific folder path
```

#### Copy files

```bash
# Backup a file
$ cp original_file_path backuped_file_path
# * means all files
$ cp original_file_path/* backuped_file_path
```

#### Extract files

```bash
# Extract files to a specific directory
$ tar xvf file.tar -C output_dir
$ tar xvzf file.tgz -C output_dir
$ tar xvzf file.tar.gz -C output_dir
$ unzip input_dir/file.zip -d output_dir
```

#### Compress files with zip

```bash
# Compress a single file
$ zip newfilename.zip input_dir

# Compress multiple files
$ zip newfilename.zip filename1  filename2
```

---

### File System Permission and Ownership

Linux is a clone of UNIX, the multi-user operating system which can be accessed by many users simultaneously. Linux can also be used in mainframes and servers without any modifications. But this raises security concerns as an unsolicited or malign user can corrupt, change or remove crucial data. For effective security, Linux divides authorization into 2 levels — Ownership and Permission. More info [ here ](https://www.guru99.com/file-permissions.html).

```bash
chmod – change permissions
chown – change ownership.
```

---

#### permissions

```bash
# Add a new user
$ sudo -i
$ adduser user_name
# set the password

# Grant sudo account for an existing Ubuntu/Debian Linux user
$ usermod -aG sudo username

# Excute sudo command without password
$ sudo visudo
# Append the following entry to the last line to run ALL command without a password for a user:
# user_name ALL=(ALL) NOPASSWD:ALL

# Changing file/directory permissions with 'chmod' command
$ chmod permissions filename
# Number    Permission Type        Symbol
# 0 No Permission                   ---
# 1 Execute                         --x
# 2 Write                           -w-
# 3 Execute + Write                 -wx
# 4 Read                            r--
# 5 Read + Execute                  r-x
# 6 Read + Write                    rw-
# 7 Read + Write +Execute           rwx
$ chmod 777 filename # -> to give user access to read, write, and execute

# Symbolic Mode
# Operator  Description
# + Adds a permission to a file or directory
# - Removes the permission
# = Sets the permission and overrides the permissions set earlier.
$ chmod permissions filename # -> to give user access to execute
```

---

### SSH (Remote Control)

SSH is typically used to log into a remote machine and execute commands, but it also supports tunneling, forwarding TCP ports and X11 connections; it can transfer files using the associated SSH file transfer (SFTP) or secure copy (SCP) protocols. SSH uses the client-server model.

For Edge devices such as the Raspberry Pi and Nvidia Jetson, you might need to control your devices remotely, thereby SSH is a good tool for you.

#### Enable SSH on local machine

You will need to enable the SSH settings in your local devices/machines in the terminal, or you will not be able to log in and access files remotely.

```bash
$ sudo -i
$ nano /etc/ssh/sshd_config
# Find the lines with "Password Authentication", and set the value from no to yes
# or comment out the "#" the line with "Password Authentication"
# you may also enable "PermitRootLogin", but you need to set a password for root first.
# To enable "PermitRootLogin", comment out the "#" in the same line, and set to "yes"
# Ctrl-X Y -> save and exit
$ passwd root
```

#### Remote log in to your devices with password via SSH

On your local Desktop/Latop, open a new terminal and type the following commands:

```bash
$ ssh username@ip_adress
# To login as root, you need to set a password for root first
```

#### Remote log in to your devices with private-key via SSH

On your local Desktop/Latop, open a new terminal and type the following commands:

```bash
# Notes: this method only works if you successfully log in to your device with a password before, or you have manually uploaded the key-pair files to your devices
# Generating a key pair
$ ssh-keygen -t rsa
# Copying the public key you just created on your home computer to your device/server
$ ssh-copy-id -i ~/.ssh/id_rsa.pub username@server_ip
# Now you will be able to log in to your device without the password
$ ssh username@ip_adress
# Or you may log in with the private key (ends without the .pub ext) that you just generated from your local machine
$ ssh username@ip_adress -i path_to_private_key
```

---

### Monitor System Loads (CPU, GPU, RAM, Storage)

#### Monitor with jetson-stats

[ jetson-stats ](https://pypi.org/project/jetson-stats/) is a package to monitoring and control your NVIDIA Jetson (Nano, Xavier, TX2i, TX2, TX1) embedded board.

```bash
$ sudo apt-get install -y python3-pip python3-dev python3-setuptools
$ sudo -H pip install -U jetson-stats
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-05-68747470733a2f2f6769746875622e636f6d2f72626f6e6768692f6a6574736f6e5f73746174732f77696b692f696d616765732f6a746f702e676966.gif)

#### Monitor with Htop

[ Htop ](https://monovm.com/blog/what-is-htop-and-what-does-it-do/) is an interactive system monitor, process viewer and process manager designed for Unix systems.)

```bash
$ sudo apt-get install -y htop
$ htop
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-05-htop.png)

#### Check system info with Screenfetch

[ ScreenFetch ](https://www.tecmint.com/screenfetch-system-information-generator-for-linux/) is an ultimate system information generator for Linux

```bash
$ sudo apt-get -y screenfetch
$ screenfetch
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-05-oracle-vm002.png)

#### Nvidia System Monitor Interface

The [ NVIDIA System Management Interface ](https://developer.nvidia.com/nvidia-system-management-interface) (nvidia-smi) is a command line utility, based on top of the NVIDIA Management Library (NVML), intended to aid in the management and monitoring of NVIDIA GPU devices.

Unfortunately, it is not compatible with the Jetson platform. However, any operation system running with x86 should work fine.

```bash
$ nvcc --version
$ nvidia-smi
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-05-68747470733a2f2f7331342e706f7374696d672e696f2f36686d7a656f616f782f696d6167652e706e67.png)

#### GPU Stats

A web interface of [ gpustat ](https://github.com/wookayin/gpustat-web) — aggregate gpustat across multiple nodes.

```bash
$ pip install gpustat
$ gpustat
```

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-05-training-on-gcp.png)

#### Monitor RAM Usage Status

```bash
# Show the RAM Usage status on your local device/machine
$ free -m
```

#### Monitor Storage Status

```bash
# Show all disks storage on your local device/machine
$ df -h
```

---

You might want to check out more useful commands for monitoring your system loads. Check it out [ here ](http://linuxpitstop.com/10-linux-commands-to-monitor-your-systems-health/).

If you have already walked through all the commands above, let’s move forward to the intermediate commands tutorial at [ Series #2 (Intermediate) ](https://hikariai.net/blog/blog/useful-linux-commands-for-ai-development-series-02-intermediate). Enjoy !

---
