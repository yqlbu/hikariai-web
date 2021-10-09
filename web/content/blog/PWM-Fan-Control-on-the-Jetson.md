---
title: "Jetson Software Setup"
image: "images/post/post-04.jpg"
date: 2020-04-21
author: "Kevin Yu"
tags: ["Edge AI", "Jetson"]
categories: ["Artificial Intelligence"]
draft: false
---

I have used the Jetson AGX Xavier Devkit for a few weeks and noticed that when the clock on the jetson is at `MAX 0`, the PWM fan will run at its maximum speed, and it might produce some annoying noise. To decrease the RPM (Rotations per minutes) of the PWM fan embedded on the Jetson Xavier in the meanwhile keeping its clock at MAX 0, we need to manually overwrite the parameters in the pwm fan config file. For convenience, to control the pwm fan with the instant change of the CPU temperature on the Jetson AGX Xavier DevKit, I wrote an auto-control script for it.

You may find more info in the [ Repo ](https://github.com/yqlbu/fan-control).

This fan control script has three modes `0 , 1 , 2` and its set to different value of pwm. The default pwm values associated with mode `0 , 1 , 2` are `80, 150 , 255` accordingly. You may modify the pwm value associated with the mode in the script on your own need.

Check out the demo below:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-04-demo-2048x1152.png)

The script is written in python as shown below:

```python
#!/usr/bin/python
import time

while True:
    fo = open("/sys/class/thermal/thermal_zone0/temp","r")
    thermal = int(fo.read(10))
    mode=0
    pwm=50 #default
    fo.close()

#    print thermal

    thermal = thermal / 1000
    if (thermal < 40):
        mode = 0
        pwm = 80
    elif (thermal >= 40 and thermal < 60):
        mode = 1
        pwm = 150
    else:
        mode = 2
        pwm = 255

    pwm = str(pwm)
    print ("current temp: " + str(thermal))
    print ("current fan mode: " + str(mode))
    print ("current pwm: " + str(pwm))

    fw=open("/sys/devices/pwm-fan/target_pwm","w")
    fw.write(pwm)
    fw.close()

    time.sleep(10) #print the result for every 10s
```

---

## How To Use

##### Download the repository from my github repo

```
$ git clone https://github.com/yqlbu/fan-control/
```

##### Modify Parameters

open the `.sh` or `.py` file and modify the pwm value based on your own need, save & exit

```bash
$ cd fan-control
$ gedit fan.sh
```

##### Run it automatically when the device is booted at startup

```bash
$ sudo chmod +x fan.sh
$ sudo scp fan.sh /etc/init.d
$ sudo crontab -e
# add @reboot /etc/init.d/fan.sh at the very top lane
$ sudo reboot
```

Test it out, and enjoy !

---
