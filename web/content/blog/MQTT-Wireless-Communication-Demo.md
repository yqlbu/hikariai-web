---
title: "MQTT — Wireless Communication Demo"
image: "images/post/post-14.jpg"
date: 2020-05-13
author: "Kevin Yu"
tags: ["IoT", "MQTT", "Software", "Jetson", "Raspberry Pi"]
categories: ["IoT"]
draft: false
---

In the previous post, we have covered the basic concepts of MQTT such as Client/Broker, Subscription/Publish, and MQTT’s Workflow. In this post, we are going to dig into the MQTT workflow and create a communication channel between devices. Basically, any devices ranging from Desktop, Laptop, to Edge devices can serve as a broker, a client, or both simultaneously.

{{< notice "info" >}}
I strongly recommend going through all the topics in my previous [ POST ](https://hikariai.net/blog/wireless-communication-between-edge-devices-via-mqtt/) before starting this tutorial. Otherwise, you might encounter lots of troubles.
{{< /notice >}}

Quick Link: https://github.com/yqlbu/MQTT

{{< toc >}}

---

### Workflow Review

The MQTT protocol defines two types of entities in the network: a message broker and a number of clients.

- `*` The client connects to the broker. It can subscribe to any message “topic” in the broker. This connection can be a plain TCP/IP connection or an encrypted TLS connection for sensitive messages.

- `*` The client publishes messages under a topic by sending the message and topic to the broker.

- `*` The broker then forwards the message to all clients that subscribe to that topic.

Since MQTT messages are organized by topics, the application developer has the flexibility to specify that certain clients can only interact with certain messages. For example, sensors will publish their readings under the “sensor_data” topic and subscribe to the “config_change” topic. Data processing applications that save sensor data into a backend database will subscribe to the “sensor_data” topic. An admin console application could receive system admin’s commands to adjust the sensors’ configurations, such as sensitivity and sample frequency, and publish those changes to the “config_change” topic.

At the same time, MQTT is lightweight. It has a simple header to specify the message type, a text-based topic, and then an arbitrary binary payload. The application can use any data format for the payload, such as JSON, XML, encrypted binary, or Base64, as long as the destination clients can parse the payload.

---

### Quick Demo

Send JSON data to a single device (Jetson Nano)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-14-jetson-demo-1-2048x1279.png)

---

Send JSON data between devices (Raspberry Pi & Jetson Nano)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-14-pi-demo-2048x1152.png)

---

JSON data details

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-14-Screen-Shot-2020-04-29-at-4.12.53-PM-2048x741.png)

{{< notice "tip" >}}
You can customize the JSON data format and content based on your own need. However, you will need to specify the IP Address of the broker, or the data will not be successfully sent with MQTT Protocol.
{{< /notice >}}

---

### Setup

Install Guide

In this demo, we will be using Python scripts to host an MQTT server to receive messages, and also to server as a client to send messages. The install lation is quite simple. Run the Shell Command in your terminal, and make sure you are using Python 3.

```bash
$ pip install paho-mqtt
```

Clone the Repo

```bash
$ cd ~
$ git clone https://github.com/yqlbu/MQTT
$ cd MQTT
```

Repo Tree

```bash
$ tree MQTT/
```

`mqtt-server.py` –> setup your local machine as a broker (your local machine can both server as a broker and a client)

`mqtt-client.py` –> setup your local machine as a client (your local machine can both server as a broker and a client)

`utils.py` –> defines all the functions needed for the communication

### Configuration

#### Broker

{{< notice "info" >}}
You do not need to specify the IP Address of your local device as a broker, the script will take care of the IP for you. The Python script for hosting a broker is shown as below
{{< /notice >}}

```python
# MQTT Client demo
# Creator: Kevin Yu

import paho.mqtt.client as mqtt
import time
import json
from utils import on_log, on_connect, on_disconnect, on_message, get_ip

# Create an MQTT brocker
broker=get_ip()[1]

# Create an MQTT client and attach our routines to it.
client=mqtt.Client() #new instance
# Bind call back function
client.on_connect=on_connect
client.on_disconnect=on_disconnect
client.on_message=on_message
# Enable log
#client.on_log=on_log

# Connect to broker
print("Connecting to broker {} @ {} ".format(get_ip()[0],broker))
client.connect(broker,1883,60)
client.loop_forever()
```

---

#### Client

Open up `mqtt-client.py` Modify the IP Address of the broker as shown below:

```python
import paho.mqtt.client as mqtt
import time
import json
from datetime import datetime
from utils import on_log, on_connect, on_disconnect, on_message, get_ip

# Create an MQTT client and attach our routines to it.
# Modify the Broker IP Address below
broker="127.0.0.1" # <-- change IP here
```

---

#### Config Cusom Json Data

If you want to config your own JSON data, you may navigate to line `#20` of the script below, and change the content of the JSON data based on your own need. However, I recommend keeping the `client` and `client_ip` objects since they are useful for the broker to identify the source of the message.

```python
client=mqtt.Client() #new instance
# Bind call back function
client.on_connect=on_connect
client.on_disconnect=on_disconnect
client.on_message=on_message

# Enable log
#client.on_log=on_log

# Connect to broker
print("Connecting to broker {}".format(broker))
client.connect(broker,1883,60)

# Publish a message
# It is set to send the message every 5 seconds by default
while True:
    # Create a msg object
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Config your own JSON data below
    data={
        "time":datetime.now().strftime("%d/%m/%Y %H:%M:%S"),
        "client":get_ip()[0],
        "client_ip":get_ip()[1],
        "msg":"Hello"
    }

    # Encode message to Json String
    data_out=json.dumps(data)
    client.publish("test",data_out)
    print("Msg has been sent!")
    time.sleep(5)  # <-- Change time interval here

client.disconnect() # Disconnect
```

**Notes:**

- `*` The mqtt_client program is set to send messages every five seconds, you may also set a specific time interval based on your own need. This feature allows you to send data such as sensors data constantly to the broker so that the broker can keep track of the system status of the client device.
- `*` You may also disconnect the client once it finishes sending a message for a one-time message send usage.
- `*` For debug purpose, you may enable the log features by commenting out “client.on_log=on_log”

---

#### IOT Advanced Integration

All the functions associated with this demo can be found in the “utils.py” in the repo. Please check out the detailed descriptions below.

##### Connection Call-back Function

```python
def on_connect(client, userdata, flags, rc):
    if rc==0:
    # Subscribing in on_connect() - if we lose the connection and
        # reconnect then subscriptions will be renewed.
        client.subscribe("test") # <-- change the topic here
        print("Connection OK")
    else:
        print("Bad connection returned code=",rc)
```

This function is mainly for two purposes:

- `*` To track if a client successfully connects to the broker.
- `*` To enable subscription to a specific topic once the client connects to the broker. \*Notes: the message can only be interchanged if the broker and the client subscribe to the same topic. You may add more topics based on your own needs.

---

##### Message Call-back Function

```python
def on_message(client, userdata, message):
    print("Data received!")
    # Decode message from Json to Python Dictionary
    content=json.loads(message.payload.decode("utf-8","ignore"))
    msg=content['msg']
    data={
    "topic":message.topic,
    "content":content,
    "qos":message.qos,
    "retain_flag":message.retain
    }
    print(data)
    if msg == u'Hello': #Unicode String
        print("Received a special msg {}!".format(content['msg']))
        # Do something #  <-- Integrate more IoT Functions here
```

This function is mainly for three purposes:

- `*` To confirm the topic, message content, client_name, and client_ip associated with that received message.
- `*` To decode the JSON data associated with the message sent from the client. **Notes:** the format of the received data is in Unicode String format, you may look up [here] if you want to convert the Unicode String to a Plain String.
- `*` To enable and integrates more IoT Functionalities such as turning ON/OFF a servo when receiving a specific message (‘ON’) from client, you may just insert your Servo code below #Do Something

---

### Wrap Up

In this post, we have walked through a practical example of how to communicate between devices (Edge devices) with MQTT protocol. This demo may also apply to a more advanced scenario, for instance, streaming data to the Public Cloud platform such as Google Cloud IoT Core and Azure IoT Hub. If you want to study more about MQTT, you may visit the site [here](https://www.eclipse.org/paho/clients/python/docs/#subscribe-unsubscribe). I hope you could find something useful for your project development. Enjoy!

---
