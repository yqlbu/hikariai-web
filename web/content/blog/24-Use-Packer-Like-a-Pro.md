---
title: "Use Packer like a Pro"
image: "images/post/post-24.png"
socialImage: "/images/post/post-24.png"
date: 2022-04-24
author: "Kevin Yu"
tags: ["Virtualization", "Cloud Computing", "DevOps", "Proxmox"]
categories: ["Virtualization", "DevOps"]
draft: false
---

I’ve been using [ Proxmox VE ](https://www.proxmox.com/en/proxmox-ve) for a while now in my Homelab as an open-source alternative for a virtualization platform like ESXi. One useful feature in Proxmox is the templates which allows us to create a `LXC` or `VM` templates that can then be cloned as a starting off point for new Proxmox resources. Now with these templates we are able to have a standard starting point to install our applications on top of, pre install packages for authentication, security, logging and etc without anyone else needing to think about it as we bake these best practices right into these template resources.

However, creating and managing these templates can become a challenge with how time-consuming and manual it can be. I want to show you how you can make this process more standardized and automated with the use of [ Packer ](https://www.packers.com/) codify your Proxmox templates and orchestrating the building and packaging of these templates so they are available for use on your Proxmox hosts.

---

## Refrence

- \- [Packer - Pipeline Builds](https://www.packer.io/guides/packer-on-cicd/pipelineing-builds)
- \- [Packer - Ansible Local Provisioner](https://www.packer.io/plugins/provisioners/ansible/ansible-local)
- \- [Packer - Promox Builder](https://www.packer.io/plugins/builders/proxmox/iso)

{{< toc >}}

---

## Source Code

https://github.com/TechProber/cloud-estate/tree/master/packer-templates

---

## Prerequisite

- \- A server already has `Proxmox VE` installed, I am currently running `Proxmox VE 7.0.12`
- \- A cup of coffee

### Software Requirement

Install `Packer` locally in your local machine

```bash
# archlinux
$ sudo pacman -S packer

# debian/ubuntu
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install packer

# homebrew
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/packer

# verify installation
$ packer
```

For detailed instructions on how to install Packer on other platform or linux distributions, please head to this [ Getting Started ](https://learn.hashicorp.com/packer/getting-started/install) guide.

---

## What is Packer

Packer is a utility that allows you to build virtual machine images so that you can define a golden image as code. Packer can be used to create images for almost all of the big cloud providers such as AWS, GCE, Azure and Digital Ocean, or can be used with locally installed hypervisors such as VMWare, Proxmox and a few others.

To build an image with packer we need to define our image through a template file. The file uses the JSON format and comprises of 3 main sections that are used to define and prepare your image.

<details><summary>Builders</summary>

</br>

**Builders**: Components of Packer that are able to create a machine image for a single platform. A builder is invoked as part of a build in order to create the actual resulting images.

</details>

<details><summary>Provisioners</summary>

</br>

**Provisioners**: Install and configure software within a running machine prior to that machine being turned into a static image. Example provisioners include shell scripts, Chef, Puppet, etc.

</details>

<details><summary>Post Processors</summary>

</br>

**Provisioners**: Install and configure software within a running machine prior to that machine being turned into a static image. Example provisioners include shell scripts, Chef, Puppet, etc.

</details>

</br>

By using packer we can define our golden VM image as code so that we can easily build identically configured images on demand so that all your machines are running the same image and can also be easily updated to a new image when needed.

---

## Create a Proxmox user for Packer

Packer requires a user account to perform actions on the Proxmox API. The following commands will create a new user account `packer@pve` with restricted permissions.

```bash
$ pveum useradd packer@pve
$ pveum passwd packer@pve
Enter new password: ****************
Retype new password: ****************
$ pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor"
$ pveum aclmod / -user packer@pve -role Packer
```

---

## Prepare your packer template

To create the template we will use the [ proxmox builder ](https://packer.io/docs/builders/proxmox.html) which connects through the proxmox `web API` to provision and configure the VM for us and then turn it into a template. To configure our template we will use a [variables file](https://github.com/TechProber/cloud-estate/blob/packer-templates/packer-templates/example.vars.json), to import this variables file we will use the `-var-file` flag to pass in our variables to packer. These variables will be used in our template file with the following syntax within a string like so `passwd/username={{ user 'ssh_username'}}`.

The builder block below will outline the basic properties of our desired proxmox template such as its name, the allocated resources and the devices attached to the VM. To achieve this the [ boot_command ](https://packer.io/docs/builders/qemu.html#boot-configuration) option will be used to boot the OS and tell it to look for the `http/user-data` file to automate the OS installation process. Packer will start a HTTP server from the content of the `http` directory (with the `http_directory` parameter). This will allow `Subiquity` to fetch the cloud-init files remotely.

**Notes:** The live installer `Subiquity` uses more memory than debian-installer. The default value from Packer (512M) is not enough and will lead to weird kernel panic. Use `1G` as a minimum.

The `boot_command` tells cloud-init to start and uses the `nocloud-net` data source to be able to load the `user-data` and `meta-data` files from a remote HTTP endpoint. The additional `autoinstall` parameter will force Subiquity to perform destructive actions without asking confirmation from the user.

{{<notice "info">}}

Import Notes: Since `Ubuntu 21.04`, the `boot_command` has been updated, so please be aware of that.

{{</notice>}}

```json
// https://github.com/TechProber/cloud-estate/blob/master/packer-templates/vars/ubuntu-2204.json#L23-L43
{
  ...
  "boot_command": [
      "<esc><esc><esc><esc>e<wait>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
      "initrd /casper/initrd<enter><wait>",
      "boot<enter>",
      "<enter><f10><wait>"
    ]
  ...
}
```

Finally, we will use the post processors to run some commands locally. This will make an SSH connection to the PVE host and run some commands manually to set up the virtual devices necessary for [ cloud init ](https://pve.proxmox.com/wiki/Cloud-Init_Support#_preparing_cloud_init_templates). This post-processor is using the [ shell-local ](https://packer.io/docs/provisioners/shell-local.html) post processor to run the commands on the local machine running packer but you could always move this configuration to something like an ansible playbook to make the configuration more readable and portable.

```hcl
# https://github.com/TechProber/cloud-estate/blob/master/packer-templates/proxmox-packer-template.pkr.hcl#L119-L127
post-processor "shell-local" {
    inline = [
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --boot c --bootdisk scsi0",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --ciuser ${var.ssh_username}",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --cipassword ${var.ssh_password}",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --serial0 socket --vga serial0",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --delete ide2"
    ]
  }
```

You may find the complete `packer-var` in https://github.com/TechProber/cloud-estate/tree/master/packer-templates/vars

---

## Build your Proxmox template with Packer

Source Code - https://github.com/TechProber/cloud-estate/tree/master/packer-templates.

### File Structure

```bash
# tree -d -L 3 ./
./
├── assets
├── http
├── playbooks
│   ├── roles
│   │   ├── apt.ops
│   │   ├── containerd.ops
│   │   ├── docker.ops
│   │   ├── maintenance.ops
│   │   ├── minio.ops
│   │   ├── proxmox.base
│   │   └── proxmox.bootstrap
│   └── vars
└── vars
```

- ./vars - where packer-var is defined
- ./http - where cloud-init configuration is defined
- ./playbooks - where all automation workloads are defined
- ./playbooks/roles - specific ansible-roles for different needs
- ./playbooks/vars - default ansible-playbook variables
- ./bake - the automation script that handles all the heavy-lifting work

### Bake CLI

The `bake` CLI is a tool I created for speeding up the process of building multiple VM templates

#### Help Menu

Check out the help menu with the `-h` option for more information:

```bash
./bake -h
```

#### List VM Templates

List all the available templates with `-a` option:

```bash
./bake -a
```

#### Bake a standard VM (Basic Usage)

```bash
./bake -i [vm-id] ubuntu-2204-server
```

#### Bake a custom VM (Advanced Usage)

```bash
./bake -i [vm-id] custom -n [custom-vm-template-name] -b [custom-build]
```

{{<notice "info">}}

For the `-b|--build` option, it ONLY support `minio` as custom build for now - [custom-proxmox-packer-template](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/custom-proxmox-packer-template.pkr.hcl#L93-L144).

{{</notice>}}

To extend its use case, feel free to [ contribute ](https://github.com/TechProber/cloud-estate/blob/master/docs/contribute.md). `PRs` are always welcome.

#### Ansible Roles

The entire automation is handled by `Ansible`. I assume you already have some foundational knowledge about Ansible, if not feel free to check out the [ Official Sites ](https://www.ansible.com/) for more information.

#### Docker Support

To bake/build a VM template that ships with [ Docker ](https://www.docker.com/ and [ Docker-Compose ](https://docs.docker.com/compose/), use the following command

```bash
./bake -i [vm-id] docker-ubuntu-2204-server
```

#### Containerd Support

To bake/build a VM template that ships with [ Containerd ](), use the following command

```bash
./bake -i [vm-id] containerd-ubuntu-2204-server
```

## Demo

To create the template execute the following command:

```bash


```

You should see some output for each of the `builders`, `provisioners` and `post-processors`.

```bash

```

---

## Conclusion

To sum up, unRAID on ESXi 7.0 is confirmed working like a charm. If you need any further troubleshooting help, visit https://forums.unraid.net/topic/90886-unraid-on-esxi-70-confimed-working/. unRAID has a very versatile community where you may find lots of people who might meet the same problem as you do, so be sure to leverage the community forum to help you build fundamental knowledge about unRAID as you go.

---

## Further reading on packer

You should now have a good starting point for building Proxmox VM templates with Packer. If your looking to extend its usefulness a little further check out these useful articles.

- \- [Getting started with Packer](https://packer.io/intro/getting-started/install.html)
- \- [Automated image builds with Jenkins, Packer, and Kubernetes](https://cloud.google.com/solutions/automated-build-images-with-jenkins-kubernetes)
- \- [Cloud images in Proxmox](https://gist.github.com/chriswayg/b6421dcc69cb3b7e41f2998f1150e1df)
- \- [Packer - Ansible Local Provisioner](https://www.packer.io/plugins/provisioners/ansible/ansible-local)
- \- [Packer - Pipeline Builds](https://www.packer.io/guides/packer-on-cicd/pipelineing-builds)

---
