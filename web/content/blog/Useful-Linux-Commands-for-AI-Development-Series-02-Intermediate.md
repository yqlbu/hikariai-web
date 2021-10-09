---
title: "Useful Linux Commands for AI Development Series #2 (Intermediate)"
image: "images/post/post-06.jpg"
date: 2020-04-26
author: "Kevin Yu"
tags: ["Linux", "Shell"]
categories: ["Linux"]
draft: false
---

In [ Series #1 (Basic) ](https://hikariai.net/blog/useful-linux-commands-for-ai-development-series-01-basic/), we have walked through some useful commands for topics such as File System Basics, File System Permission & Ownership, SSH (Remote Control), and Monitor System Loads (CPU, GPU, Memory). Let’s walk through more in this article.

{{< toc >}}

---

### Symbolic Links

There are two types of links: hard link & symbolic link. Hard link refers that users may create multiple names for a linked file. Whereas, software only allows the user to create one particular link, which directly points to another directory that differs from the original directory. This technique is frequently used in linking the default environment packages such as OpenCV library to a virtual environment library.

On Unix-like operating systems, the ln command creates links between files, associating file names with file data. More info [ here ](https://www.computerhope.com/unix/uln.html).

#### Create symbolic links

```bash
# Syntax:
# ln [option] [original-file] [target-file-or-folder]
# Parameters:
# -b delete，overwrite the existing links
# -d allow users to make hard link
# -f force execute
# -i interchangeable mode, if the file already exists, then asks if users want to overwrite
# -s symbolic link
# -v show the process
$ ln -s path/[original-file] path/[target-file-or-folder]
```

---

### Screen

The screen application is very useful if you are dealing with multiple programs from a command-line interface and for separating programs from the terminal shell. It also allows you to share your sessions with other users and detach/attach terminal sessions.

#### Clear current screen

```bash
Ctrl + L
```

#### Create a new screen

```bash
# Create a new screen session
$ screen -S screen_name
```

#### List all available screen sessions

```bash
# List the available screen sessions
$ screen -list
```

#### Reatttach to a specific screen session

```bash
# Reattach to this screen session
$ screen -r screen_name
```

#### Kill (Terminate) a screen session

```bash
# Kill a screen session
$ screen -S screen_name -X quit
```

---

### Python pip installation and management

`pip` is a package manager for Python packages, or modules if you like.

#### Install pip

```bash
$ sudo apt install python3-pip
$ sudo -H pip3 install --upgrade pip
```

#### Install python packages

```bash
$ pip install package-name
```

#### List all installed packages

```bash
$ pip list
```

#### Check if a packages has been installed

```bash
$ pip show package-name
```

#### Show python path and pip path

```bash
$ which python
$ which pip
```

### Git Commands

[ Git ](https://git-scm.com/docs/git) is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.

#### Git Config

```bash
# Set up the config file for furture useage
$ git config --global user.name Your Name
$ git config --global user.email email@example.com
# Note: --global refers that the config file will be applied to all the repos on your device.
```

#### Add private key to Git

```bash
$ ssh-keygen -t rsa -C email@example.com
# Log in to your Github page, open up Account Settings >> SSH and GPG keys >> Add SSH keys,
# Paste your the content inside your id_rsa.pub file to the block
# Give it a title
```

#### Upload your repo to Github

```bash
# Initialize a repo
$ git init

# Add a file to the repo
$ git add filename.ext
# Add all files to the repo
$ git add *
#OR
$ git add --all

# Commit changes
$ git commit -am 'custom-msg'

# Build a remote connection
$ git remote add origin https://github.com/username.git

# Remove the connection
$ git remote rm origin

# Sync the local repo to Github (Cloud Server)
$ git push origin master
# you may change master with your custom branch

# Check repo status
$ git status
```

#### Download a repo from Github

```bash
$ git clone https://github.com/username.git
# If you want to rename the repository, you may do
$ git clone https://github.com/username.git new_repo_name
```

#### Get updates from a repo (Assume one or more people working on the same repo)

```bash
# Get updates of the repo from your contributor
$ git pull
```

---

If you have already walked through all the commands above, let’s move forward to the advanced commands tutorial at [ Series #3 (Advanced) ](https://hikariai.net/blog/useful-linux-commands-for-ai-development-series-03-advanced/). Happy Coding !

---
