---
title: "Use Packer like a Pro"
image: "images/post/post-24.jpg"
socialImage: "/images/post/post-24.jpg"
date: 2022-04-24
author: "Kevin Yu"
tags: ["Virtualization", "Cloud Computing", "DevOps", "Proxmox"]
categories: ["Virtualization", "DevOps"]
draft: false
---

I’ve been using [ Proxmox VE ](https://www.proxmox.com/en/proxmox-ve) for a while now in my Homelab as an open-source alternative for a virtualization platform like ESXi. One useful feature in Proxmox is the templates that allow us to create `LXC` or `VM` templates that can then be cloned as a starting point for new Proxmox resources. Now with these templates, we can have a standard starting point to install our applications on top of, pre-install packages for authentication, security, logging, etc without anyone else needing to think about it as we bake these best practices right into these template resources.

However, creating and managing these templates can become a challenge with how time-consuming and manual it can be. I want to show you how you can make this process more standardized and automated with the use of [ Packer ](https://www.packer.io/) to modifying your Proxmox templates, orchestrating the building, and packaging of these templates so they are available for use on your Proxmox hosts.

---

## References

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

Install `Packer` locally on your local machine

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

For detailed instructions on how to install Packer on other platforms or Linux distributions, please head to this [ Getting Started ](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli) guide.

---

## What is Packer

Packer is a utility that allows you to build virtual machine images so that you can define a golden image as code. Packer can be used to create images for almost all of the big cloud providers such as AWS, GCE, Azure, and Digital Ocean, or can be used with locally installed hypervisors such as VMWare, Proxmox, and a few others.

To build an image with packer we need to define our image through a template file. The file uses the JSON format and comprises 3 main sections that are used to define and prepare your image.

<details><summary>Builders</summary>
</br>
**Builders**: Components of Packer that can create a machine image for a single platform. A builder is invoked as part of a build to create the actual resulting images.
</details>

<details><summary>Provisioners</summary>
</br>
**Provisioners**: Install and configure software within a running machine before that machine is turned into a static image. Example provisioners include shell scripts, Chef, Puppet, etc.
</details>

<details><summary>Post Processors</summary>
</br>
**Provisioners**: Install and configure software within a running machine before that machine is turned into a static image. Example provisioners include shell scripts, Chef, Puppet, etc.
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

To create the template we will use the proxmox builder ](https://packer.io/docs/builders/proxmox.html) which connects through the proxmox `web API` to provision and configure the VM for us and then turn it into a template. To configure our template we will use a [variables file](https://github.com/TechProber/cloud-estate/blob/packer-templates/packer-templates/example.vars.json), to import this variables file we will use the `-var-file` flag to pass in our variables to Packer. These variables will be used in our template file with the following syntax within a string like so `passwd/username={{ user 'ssh_username'}}`.

The builder block below will outline the basic properties of our desired proxmox template such as its name, the allocated resources, and the devices attached to the VM. To achieve this the [ boot_command ](https://packer.io/docs/builders/qemu.html#boot-configuration) option will be used to boot the OS and tell it to look for the `http/user-data` file to automate the OS installation process. Packer will start an HTTP server from the content of the `http` directory (with the `http_directory` parameter). This will allow `Subiquity` to fetch the cloud-init files remotely.

**Notes:** The live installer `Subiquity` uses more memory than Debian-installer. The default value from Packer (512M) is not enough and will lead to weird kernel panic. Use `1G` as a minimum.

The `boot_command` tells cloud-init to start and uses the `nocloud-net` data source to be able to load the [user-data](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/http/user-data) and `meta-data` files from a remote HTTP endpoint. The additional `autoinstall` parameter will force Subiquity to perform destructive actions without asking for confirmation from the user.

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

Finally, we will use the post processors to run some commands locally. This will make an SSH connection to the PVE host and run some commands manually to set up the virtual devices necessary for [ cloud-init. This post-processor is using the [ shell-local ](https://packer.io/docs/provisioners/shell-local.html) post processor to run the commands on the local machine running packer but you could always move this configuration to something like an ansible playbook to make the configuration more readable and portable.

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

### Get Started

Source Code - https://github.com/TechProber/cloud-estate/tree/master/packer-templates.

```bash
$ git clone https://github.com/TechProber/cloud-estate
$ cd packer-templates
```

### File Structure

```bash
# tree -d -L 3 ./
./
├── assets
├── http
├── playbooks
│   ├── roles
│   │   ├── apt.ops
│   │   ├── containerd.ops
│   │   ├── docker.ops
│   │   ├── maintenance.ops
│   │   ├── minio.ops
│   │   ├── proxmox.base
│   │   └── proxmox.bootstrap
│   └── vars
└── vars
```

- ./vars - where packer-var is defined
- ./http - where cloud-init configuration is defined
- ./playbooks - where all automation workloads are defined
- ./playbooks/roles - specific ansible-roles for different needs
- ./playbooks/vars - default ansible-playbook variables
- ./bake - the automation script that handles all the heavy-lifting work

### Proxmox API Authentication

After creating a dedicated Packer User followed the guide [above](#create-a-proxmox-user-for-packer), you will also need to export the `PM_PASS` as an environment variable (the password of the packer user to interact with Proxmox API authentication).

```bash
$ export PM_PASS=<pm_password>
```

You will also need to manually modify the `./config.yml` to connect to your Proxmox Server

```yaml
{
  "proxmox_host": "10.178.0.10",
  "proxmox_node_name": "pve-01",
  "proxmox_api_user": "packer@pve",
  "http_bind_address": "10.178.0.50",
}
```

{{<notice "note">}}

`http_bind_address` is the IP address of the host machine that has Packer installed.

{{</notice>}}

The `./bake` script will take the `PM_PASS` environment variable and all the attributes defined in the `./config.yml` to interact with Packer and Proxmox.

### SSH Key Management

For safety concerns, the VM template created by Packer can ONLY be connected via `ssh-key-pair`. You will need to prepare your ssh-public key before baking the VM. If you do not have an `ssh-key-pair` yet, you may use the following commands to generate one.

```bash
$ ssh-keygen -m PEM -t rsa -b 4096 -C “user@example.com”
```

Then, you will need to replace the default `./id_rsa.pub` with your newly created public key in the project root directory

```bash
# ./packer-templates
$ cat ~/.ssh/id_rsa.pub > ./id_rsa.pub
```

### Ansible Local Provisioner

During the VM baking/building period, the entire automation is handled by `Ansible`. I assume you already have some foundational knowledge about Ansible, if not feel free to check out the [ Official Sites ](https://www.ansible.com/) for more information.

The `ansible-local` Packer provisioner will execute ansible in Ansible's `local` mode on the remote/guest VM using Playbook and Role files that exist on the guest VM. This means Ansible must be installed on the remote/guest VM. Playbooks and Roles can be uploaded from your build machine (the one running Packer) to the VM. Ansible is then run on the guest machine in local mode via the `ansible-playbook` command. For more information, please check out https://www.packer.io/plugins/provisioners/ansible/ansible-local

To see all the available roles, head over to https://github.com/TechProber/cloud-estate/tree/master/packer-templates/playbooks/roles. You are also welcome to raise PR/issue for feature requests. More roles are coming up soon.

Each VM template relies on a combination of `ansible-roles` to achieve different features. For instance, there is a specific role for `Docker` and `Docker-Compose`. Reference to the sample [docker-ubuntu-2204-server VM template](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/playbooks/docker-ubuntu-2204-server.yml)

#### Customization

If you like to create a custom VM template that is not defined in the `./bakery-config.json`, you may take the [custom VM template](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/playbooks/custom.yml) as a reference and adjust the roles you would like to be included in the VM template.

### Ansible Vault (Optional)

If you plan to use [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html) to encrypt ansible variables, you may also need to create the `.vault-pass` file with a vault password under `./playbooks/.vault-pass` (already added to `.gitignore`). It will be used to encrypt and decrypt sensitive variables.

You will also need to add an extra `provisioner` in the packer template file as this is for the advanced use case. The `.vault-pass` file will be passed to `/tmp/.vault-pass` during the baking period and will be deleted afterward (seen in [detailed implementation](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/playbooks/roles/proxmox.bootstrap/tasks/post-actions.yml#L25-L29)). Feel free to check out an existing example - https://github.com/TechProber/cloud-estate/blob/master/packer-templates/custom-proxmox-packer-template.pkr.hcl#L108-L112

{{<notice "info">}}

Import Notes: By default, the custom vm template uses `minio` which relies on `.vault-pass`. If you do not wish to install Mini Client, then you will need to manually remove the `minio-role` in [./playbooks/custom.yml]()

{{</notice>}}

### Bake CLI

The `bake` CLI is a tool I created for speeding up the process of building multiple VM templates

#### Help Menu

Check out the help menu with the `-h|--help` option for more information:

```bash
./bake -h
```

#### List VM Templates

List all the available templates with `-a|--all` option:

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

For the `-b|--build` option, it ONLY supports `minio` as custom build for now - [custom-proxmox-packer-template](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/custom-proxmox-packer-template.pkr.hcl#L93-L144).

{{</notice>}}

To extend its use case, feel free to [ contribute ](https://github.com/TechProber/cloud-estate/blob/master/docs/contribute.md). `PRs` are always welcome.

#### Docker Support

To bake/build a VM template that ships with [ Docker ](https://www.docker.com/) and [ Docker-Compose ](https://docs.docker.com/compose/), use the following command:

```bash
./bake -i [vm-id] docker-ubuntu-2204-server
```

#### Containerd Support

To bake/build a VM template that ships with [ Containerd ](https://containerd.io/) and [ Nerdctl ](https://github.com/containerd/nerdctl), use the following command:

```bash
./bake -i [vm-id] containerd-ubuntu-2204-server
```

#### Changing APT Source

There is a role to change the default `APT` source - https://github.com/TechProber/cloud-estate/tree/master/packer-templates/playbooks/roles/apt.ops/set-sources.ops, and it is set to the `CN(USTC)` source by default. You may overwrite the configurations defined in [./playbooks/var/apt.yml](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/playbooks/vars/apt.yml)

## Demo

Create a custom ubuntu-2204-server with `Docker` and `Minio Client` installed and configured

```bash
$ ./bake -i 9001 -t custom -n custom-ubuntu-2204-server -c minio
```

./playbooks/custom.yml

```yaml
---
# Bake custom-server

- name: "Bake proxmox custom vm template"
  hosts: localhost
  become: yes

  vars_files:
    - ./vars/apt.yml
    - ./vars/maintenance.yml

  vars:
    - vault_enable: true

  roles:
    - role: ./roles/apt.ops/set-sources.ops/
      vars:
        release: "jammy"
    - role: ./roles/apt.ops/install-packages.ops/
      vars:
        extra_packages:
          - neofetch

    - role: ./roles/maintenance.ops/key.ops/

    - role: ./roles/docker.ops/

    - role: ./roles/proxmox.bootstrap/
```

./custom-proxmox-packer-template.pkr.hcl

```hcl
...

build {

  name = "minio"

  sources = ["source.proxmox.bakery-template"]

  # Provisioner Configurations

  # SSH public key
  provisioner "file" {
    source      = "./id_rsa.pub"
    destination = "/tmp/id_rsa.pub"
  }

  # Minio plabyook
  provisioner "file" {
    pause_before = "5s"
    source       = "./playbooks/.vault_pass"
    destination  = "/tmp/.vault_pass"
  }
  provisioner "ansible-local" {
    playbook_dir            = "./playbooks"
    playbook_file           = "./playbooks/minio.yml"
    clean_staging_directory = true
    extra_arguments = [
      "--vault-password-file=/tmp/.vault_pass",
      "--extra-vars \"ansible_user=packer\""
    ]
  }

  # Main playbook depends of vm_type
  provisioner "ansible-local" {
    pause_before            = "5s"
    playbook_dir            = "./playbooks"
    playbook_file           = var.playbook_file
    clean_staging_directory = true
    extra_arguments = [
      "--extra-vars \"ansible_user=packer\""
    ]
  }

  # Convert to proxmox vm template
  post-processor "shell-local" {
    inline = [
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --boot c --bootdisk scsi0",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --ciuser ${var.ssh_username}",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --cipassword ${var.ssh_password}",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --serial0 socket --vga serial0",
      "ssh root@${var.proxmox_host} qm set ${var.vm_id} --delete ide2"
    ]
  }
}
```

You should see some output for each of the `builders`, `provisioners,` and `post-processors`.

```bash
# ./bake -i 9001 -t custom -n custom-ubuntu-2204-server -c minio

########## Baking prod-ubuntu-2204-server-template template with packer

minio.proxmox.bakery-template: output will be in this color.

==> minio.proxmox.bakery-template: Creating VM
==> minio.proxmox.bakery-template: Starting VM
==> minio.proxmox.bakery-template: Starting HTTP server on port 8802
==> minio.proxmox.bakery-template: Waiting 5s for boot
==> minio.proxmox.bakery-template: Typing the boot command
==> minio.proxmox.bakery-template: Waiting for SSH to become available...

...

==> minio.proxmox.bakery-template: Uploading ./id_rsa.pub => /tmp/id_rsa.pub
    minio.proxmox.bakery-template: id_rsa.pub 743 B / 743 B [=================================================================] 100.00% 0s
==> minio.proxmox.bakery-template: Pausing 5s before the next provisioner...
==> minio.proxmox.bakery-template: Uploading ./playbooks/.vault_pass => /tmp/.vault_pass
    minio.proxmox.bakery-template: .vault_pass 21 B / 21 B [==================================================================] 100.00% 0s
==> minio.proxmox.bakery-template: Provisioning with Ansible...
    minio.proxmox.bakery-template: Uploading Playbook directory to Ansible staging directory...
    minio.proxmox.bakery-template: Creating directory: /tmp/packer-provisioner-ansible-local/626557b5-6bf5-0aba-7ab2-50b0916afe37
    minio.proxmox.bakery-template: Uploading main Playbook file...
    minio.proxmox.bakery-template: Uploading inventory file...
    minio.proxmox.bakery-template: Executing Ansible: cd /tmp/packer-provisioner-ansible-local/626557b5-6bf5-0aba-7ab2-50b0916afe37 && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/packer-provisioner-ansible-local/626557b5-6bf5-0aba-7ab2-50b0916afe37/minio.yml --extra-vars "packer_build_name=bakery-template packer_builder_type=proxmox packer_http_addr=10.178.0.50:8802 -o IdentitiesOnly=yes" --vault-password-file=/tmp/.vault_pass --extra-vars "ansible_user=packer" -c local -i /tmp/packer-provisioner-ansible-local/626557b5-6bf5-0aba-7ab2-50b0916afe37/packer-provisioner-ansible-local2268832455

...

    minio.proxmox.bakery-template: PLAY RECAP *********************************************************************
    minio.proxmox.bakery-template: 127.0.0.1                  : ok=34   changed=21   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    minio.proxmox.bakery-template:
    minio.proxmox.bakery-template: Removing staging directory...
    minio.proxmox.bakery-template: Removing directory: /tmp/packer-provisioner-ansible-local/626557c0-c15c-4738-aebb-53538294728e
==> minio.proxmox.bakery-template: Stopping VM
==> minio.proxmox.bakery-template: Converting VM to template
==> minio.proxmox.bakery-template: Adding a cloud-init cdrom in storage pool sata-pool
==> minio.proxmox.bakery-template: Running post-processor:  (type shell-local)
==> minio.proxmox.bakery-template (shell-local): Running local shell script: /tmp/packer-shell1584895912
    minio.proxmox.bakery-template (shell-local): update VM 9001: -boot c -bootdisk scsi0
    minio.proxmox.bakery-template (shell-local): update VM 9001: -ciuser packer
    minio.proxmox.bakery-template (shell-local): update VM 9001: -cipassword <hidden>
    minio.proxmox.bakery-template (shell-local): update VM 9001: -serial0 socket -vga serial0
    minio.proxmox.bakery-template (shell-local): update VM 9001: -delete ide2
Build 'minio.proxmox.bakery-template' finished after 5 minutes 58 seconds.

==> Wait completed after 5 minutes 58 seconds

==> Builds finished. The artifacts of successful builds are:
--> minio.proxmox.bakery-template: A template was created: 9001
--> minio.proxmox.bakery-template: A template was created: 9001
The last command took 359.68 seconds.

```

---

Up to this point, the custom VM template with `Docker`, `Docker-Compose`, and `Minio Client` pre-installed has been successfully uploaded to the Proxmox server.

![](https://github.com/TechProber/cloud-estate/blob/master/packer-templates/assets/screenshot.png?raw=true)

## Conclusion

To sum up, with such an approach, we can deploy a new VM in minutes and drastically speed up the DevOps process. Ansible is a very powerful tool as it opens up many opportunities to basically automate any shell-based tasks. Next, I plan to write another post to further extend the automation with [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/) to deploy a VM in Proxmox with the VM template created by Packer.

---

## Further reading on packer

You should now have a good starting point for building Proxmox VM templates with Packer. If your looking to extend its usefulness a little further check out these useful articles.

- \- [Getting started with Packer](https://packer.io/intro/getting-started/install.html)
- \- [Automated image builds with Jenkins, Packer, and Kubernetes](https://cloud.google.com/solutions/automated-build-images-with-jenkins-kubernetes)
- \- [Cloud images in Proxmox](https://gist.github.com/chriswayg/b6421dcc69cb3b7e41f2998f1150e1df)
- \- [Packer - Ansible Local Provisioner](https://www.packer.io/plugins/provisioners/ansible/ansible-local)
- \- [Packer - Pipeline Builds](https://www.packer.io/guides/packer-on-cicd/pipelineing-builds)

---
