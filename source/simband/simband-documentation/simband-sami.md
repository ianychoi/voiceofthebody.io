---
title: "Simband <3 SAMI"
---

# Simband <3 SAMI

Although Simband is equipped with plenty of local memory, syncing with the cloud is a fundamental feature of the platform. [SAMI][1] is the service of choice. 

SAMI is an open, agnostic data exchange platform. With its [simple APIs][2], SAMI can collect and normalize data from any type of device or online source, and deliver it to any other device or application in real-time. 

Simband uses SAMI to store data in the cloud for processing. Basic rule engines, machine learning and algorithms in SAMI help aggregate and perform analysis on the data. And once in SAMI, the data is available to partners who want to create approved apps and services. 

SAMI defines a new paradigm for developers to create services and applications. It offers a new dimension to think beyond a single device, and enables developers to connect and analyze all sorts of data. This is what we call Data Driven Development (D<sup>3</sup>).


![SAMI architecture overview](/images/docs/simband/simband-documentation/sami-architecture.jpg){:.lightbox}

SAMI and its APIs are designed specifically for wearable devices and IoT. When WiFi is available, Simband will quickly upload the recorded data to SAMI. In an ideal network environment, you will be able to see data flowing in and out of SAMI with a delay of a couple of seconds (this is mostly due to network latency). When Simband is not connected to WiFi, it will store data locally and upload it later. Simband has sufficient storage to keep data for days.

To learn more about SAMI, have a look at [SAMI basics.][3]

[1]: http://developer.samsungsami.io "Samsung SAMI developer documentation"
[2]: http://developer.samsungsami.io/sami/api-spec.html "SAMI API reference"
[3]: http://developer.samsungsami.io/sami/sami-documentation/sami-basics.html "SAMI Basics"
