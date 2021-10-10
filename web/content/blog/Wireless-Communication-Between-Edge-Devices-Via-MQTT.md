---
title: "Wireless Communication Between Edge Devices Via MQTT Broker/Client"
image: "images/post/post-13.jpg"
date: 2020-05-12
author: "Kevin Yu"
tags: ["IoT", "MQTT", "Software"]
categories: ["IoT"]
draft: false
---

For `Internet of Things (IoT)` devices, connecting to the Internet is kind of a requirement. Connecting to the Internet allows the devices to work with each other and with backend services. The underlying network protocol of the Internet is TCP/IP. Built on top of the TCP/IP stack, `MQTT (Message Queue Telemetry Transport)` has become the standard for IoT communications. MQTT can also run on SSL/TLS, which is a secure protocol built on TCP/IP, to ensure that all data communication between devices are encrypted and secure.

{{< toc >}}

---

### Video Tutorial

{{< youtube WmKAWOVnwjE>}}

---

### What is MQTT?

[ MQTT ](https://mqtt.org/) is a lightweight and flexible network protocol that strikes the right balance for IoT developers. The lightweight protocol allows it to be implemented on both heavily constrained device hardware as well as high latency / limited bandwidth networks. Its flexibility makes it possible to support diverse application scenarios for IoT devices and services. MQTT allows you to send commands to `control outputs, read and publish data` from sensor nodes and much more.

What makes the MQTT so `lightweight` and `flexible`? A key feature of the MQTT protocol is its `publish` and `subscribe` model. As with all messaging protocols, it decouples the publisher and consumer of data.

---

### Basic Concepts

In MQTT there are a few basic concepts that you need to understand

`Broker/Clients`

`Publish/Subscribe`

`Messages`

`Topics`

---

### What is an MQTT Broker ?

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-13-mqtt_broker.png)

An MQTT broker is a server that receives all messages from the clients and then routes the messages to the appropriate destination clients. The broker is primarily responsible for receiving all messages, filtering the messages, decide who is interested in them and then publishing the message to all subscribed clients.

---

### What is an MQTT Client?

An MQTT client is any device (from a microcontroller up to a full-fledged server) that runs an MQTT library and connects to an MQTT broker over a network. The MQTT client can interact with the broker to send and receive messages. A client could be an IoT sensor in the field or an application in a data center that processes IoT data.

---

### MQTT Publish/Subscribe

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-13-publish-subscribe.webp)

In a publish and subscribe system, a device can publish a message on a topic, or it can be subscribed to a particular topic to `receive messages`

For example Device 1 publishes on a topic. Device 2 is subscribed to the same topic as device 1 is publishing in. Therefore, device 2 receives the message.

---

### MQTT Messages

Messages are the information that you want to exchange between your devices. Whether it’s a command or data.

---

### MQTT Topics

Topics are the way you register interest for incoming messages or how you specify where you want to publish the message.

Topics are represented with strings separated by a forward slash. Each forward slash indicates a topic level. Here’s an example on how you would create a topic for a lamp in your home office:

If you would like to turn on a lamp in your home office using MQTT you can imagine the following scenario:

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-13-publish-subscribe-example.webp)

- You have a device that publishes “on” and “off” messages on the home/office/lamp topic.

- You have a device that controls a lamp (it can be an ESP32, ESP8266, or any other board). The ESP32 that controls your lamp, is subscribed to that topic: home/office/lamp.

- When a new message is published on that topic, the ESP32 receives the “on” or “off” message and turns the lamp on or off.

---

### How MQTT Works?

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-13-image1.png)

The MQTT protocol defines two types of entities in the network: a `message broker` and a number of `clients`.

- `*` The client connects to the broker. It can subscribe to any message “topic” in the broker. This connection can be a plain TCP/IP connection or an encrypted TLS connection for sensitive messages.

- `*` The client publishes messages under a topic by sending the message and topic to the broker.

- `*` The broker then forwards the message to all clients that subscribe to that topic.

Since MQTT messages are organized by topics, the application developer has the flexibility to specify that certain clients can only interact with certain messages. For example, sensors will publish their readings under the “sensor_data” topic, and subscribe to the “config_change” topic. Data processing applications that save sensor data into a backend database will subscribe to the “sensor_data” topic. An admin console application could receive system admin’s commands to adjust the sensors’ configurations, such as sensitivity and sample frequency, and publish those changes to the “config_change” topic.

At the same time, MQTT is lightweight. It has a simple header to specify the message type, a text-based topic, and then an arbitrary binary payload. The application can use any data format for the payload, such as JSON, XML, encrypted binary, or Base64, as long as the destination clients can parse the payload.

---

### Conclusion

To wrap up what we have covered in this post, the MQTT is a communication protocol based on a publish and subscribe system. It is simple to use and it is great for Internet of Things and Home Automation projects. We hope you’ve found this tutorial useful and you now understand what is MQTT and how it works. I will make another post about how to use MQTT to communicate between your edge devices and your local machine such as laptop and desktop, so please stay tuned to my site !

---
