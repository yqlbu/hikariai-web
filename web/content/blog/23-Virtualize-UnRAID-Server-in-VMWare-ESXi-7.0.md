---
title: "Virtualize unRAID Server in VMWare ESXi 7.0"
image: "images/post/post-23.jpg"
socialImage: "/images/post/post-23.jpg"
date: 2021-10-20
author: "Kevin Yu"
tags: ["Virtualization", "Cloud Computing", "unRAID", "VMWare"]
categories: ["Virtualization"]
draft: false
---

After some intensive research and consideration, I found out that virtualizing unRIAD Server in [ VMWare ESXi 7.0 ](https://customerconnect.vmware.com/en/web/vmware/evalcenter?p=free-esxi7&src=vmw_so_vex_dbori_1255) seems like a possibility. Due to the fact that the licensing model Lime Technology is using this is NOT `straightforward`. UnRAID require to be installed on a `USB Flash` drive with a `GUID`. Not very virtualization-friendly in other words.

Luckily in VMware ESXi 7.0, there is possible to boot VMs directly from a USB drive (It has earlier just been possible through third-party tools like [ Plop Boot Manager ](https://www.plop.at/en/bootmanager/full.html))

**Refrence:**

- [unRAID on ESXi 7.0 - Confirmed Working](https://forums.unraid.net/topic/90886-unraid-on-esxi-70-confimed-working/)
- [How to install UnRaid on ESXi 7.0 Step -by-Step](https://www.youtube.com/watch?v=xIR5KtptxD0)
- [How to convert a physical UnRAID server to a virtual machine in VMware ESXi 7.0](https://flemmingss.com/how-to-convert-a-physical-unraid-server-to-a-virtual-machine-in-vmware-esxi-7-0/)

{{< toc >}}

---

### Prerequisite

- A server already have `VMWare ESXi 7.0` installed
- A cup of coffee (It's a must xD!)

---

### Install unRAID on USB-Flash Drive

#### Download unRAID USB Flash Creator

Download the Latest USB Flash Creator from [ UNRAID Official Website ](https://unraid.net/), and then go through the installation guide.

{{<notice "info">}}
Do _NOT_ select the `UEFI` boot method as it will not be booted from the ESXi VM.
{{</notice>}}

<img src="https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-screenshot-02.png" width="500"/>

After the installation, you should be able to find the boot content from your USB Flash Drive.

#### Download PlopKexec Bootloader

Download the latest `PlopKexec-bin-tar` from [Plop Official Website](https://www.plop.at/en/plopkexec/download.html)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-screenshot-01.jpg)

Extract the `tar` file and find the files named `bootx64.efi` (bootloader) and `plopkexec64` (Disc Image File)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-screenshot-03.png)

Upload the `plopkexec64` ISO file to the datastore in `ESXi`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-screenshot-04.png)

Copy the `bootx64.efi` (bootloader) to your USB Flash Drive with unRAID installed in the previous steps

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-screenshot-05.png)

---

### Toggle PCI-Passthrough (Optional)

{{<notice "info">}}
You may skip this step if you do NOT want to passthrough `physical drives` to the `unRAID` VM.
{{</notice>}}

`*` In the ESXi Console GUI got to `Host` > `Manage` > `PCI Devices`

`*` Select your PCI/PCI Express `SATA/SAS Controller` Card and select `Toggle Passthrough`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_pci_devices_sas2008.png)

A message like this will show if the passthrough is successful:

_“Successfully toggled passthrough for device Broadcom / LSI SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon].”_

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_pci_devices_sas2008_passtrough_successfull.png)

### Create unRAID VM

`*` Go to `Virtual Machine` in the left menu.

`*` Select `Create / Register VM`

`*` Select `Create a new virtual machine`, and `Next`.

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_new_vm_unraid_1.png)

`*` Give the VM a recognizable name and select as follows:

- `Compatibility`: ESXi 7.0(U2) virtual machine
- `Guest OS family`: Linux
- `Guest OS version`: Ubuntu Linux (64-bit)

`*` Click `Next`

`*` Select a `datastore` and click `Next`

`*` Configure `CPU`, `Memory` and `Hard disk`.

- Change the Hard disk Controller location from the default `SCSI Controller` to `SATA Controller` as unRAID can ONLY recognize SATA drives

---

### Configure the VM

#### Add PCIE Devices (Optional)

`*` Click on `Add other device`, then `PCI device`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_new_vm_unraid_4_pci_device_selected.png)

#### Add PlopKexec ISO to the VM

`*` Select `CD/DVD Drive 1`, and select `Datastore ISO file`. Pick the `PlopKexec` ISO file from the datastore

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-iso_selection.png)

#### Add USB Flash Drive

`*` Select `Add other device` and choose `USB controller`, find your USB Flash Drive with unRAID installed in it

`*` Modify the `USB controller` type to fit your USB Flash Drive type. By default it is set to `2.0`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-usb_selection.png)

#### Add Extra Boot Parameters

According to https://forums.unraid.net/topic/90886-unraid-on-esxi-70-confimed-working/?do=findComment&comment=849079, someone mentioned that we may need to pass a specific parameter, `monitor.allowLegacyCPU = True` to the VM to make this fully funtional.

To do so, follow the steps below:

`*` Edit VM Settings, under `VM Options` > `Advanced` > `Edit Configuration`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-edit_configuration.png)

`*` Press `Add parameter` and add `monitor.allowLegacyCPU` parameter and set its value to `TRUE`

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-extra_params.png)

#### VM Configuration

My unRAID VM Configuration

```config
CONFIG:
Name	UnRAID
Guest OS name	Ubuntu Linux (64-bit)
Compatibility	ESXi 7.0U2 virtual machine
vCPUs	12
Memory	8 GB
Network adapter 1 network	LAN-server
Network adapter 1 type	VMXNET 3
SCSI controller 0	LSI Logic Parallel
SATA controller 0	New SATA controller
Hard disk 1
Capacity	200GB
Provisioning	Thick provisioned, lazily zeroed
Controller	SCSI controller 0 : 0
Connected	Yes
USB controller 1	USB 3.1
USB device 1	Kingston DataTraveler 3.0
...
```

---

### Boot unRAID

Double check if everything has been set up correctly, especially the `USB Controller`, which has to match your `USB Flash Drive` USB type

If everything is good, then we can proceed to boot the unRAID VM

{{<notice "info">}}
Press the `Up and Down` arrow key on your keyboard to toggle the `boot option`, you should see the `Unraid OS` boot options in the menu
{{</notice>}}

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-boot_vm.png)

Demo

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-demo.png)

---

### Install VMware Tools

After unRAID is up and running you should install `VMware Tools`.

`*` Assuming you have already installed the [ Community Applications ](https://forums.unraid.net/topic/38582-plug-in-community-applications/) Plug-In in UnRAID, open the UnRAID GUI and go to the `Apps-tab`.

`*` Search for `openVMTools_compiled` and you will find this app:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_unraid_vm_opnvmtools_app.png)

`*` Install the plugin by clicking Install

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-23-vmware_esxi_7.0_unraid_vm_opnvmtools_app_installed.png)

That’s it, the `Virtualized unRAID Server` is now fully functional just as a physical machine.

---

### Conclusion

To sum up, unRAID on ESXi 7.0 is confirmed working like a charm. If you need any further troubleshooting help, visit https://forums.unraid.net/topic/90886-unraid-on-esxi-70-confimed-working/. unRAID is a very versatile community where you may find lots of people who might meet the same problem as you do, so be sure to leverage the community forum to help you build fundamental knowledge about unRAID as you go.

---
