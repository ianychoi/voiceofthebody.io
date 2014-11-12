---
title: "Semantics of Simband data"
nav:
  - 'types-streams'
  - 'accessing-data-from-stream'
  - 'applications'
  - 'access-data-via-sami'
---

# Semantics of Simband data

At its core, Simband is a platform for collecting and analyzing biophysical data for preventative health. As such, data on this platform has certain traits: it is, at most, time-coded, continuous and numeric. This is why the [Simband API][6] describes data as a *stream*.

Before diving into quantitative details of the stream and Simband Runtime, let's look at Simband's system block diagram for an overview.

![](/images/docs/simband/simband-documentation/semantics-of-simband/system-block-simband-runtime01.png)

- The biophysical data comes from the heart of Simband: the sensor module. This documentation covers our reference implementation, [Simsense.][5] 
- The data gets signal conditioned and processed by M0 + M4F. 
- The data is provided to Simband Runtime, which categorizes it into streams and makes it accessible on demand. 

Let's find out how streams are created and used by Simband. 


## What is a stream?

A stream is a single continuous sequence of time-coded numeric data. Any numeric data on Simband can be expressed as a stream, which exists in parallel with streams produced by other sensors. By definition, any stream may have only one numeric value at any given point in time, or no value at all. All of the stream data on Simband is float-32.

For example, each PPG channel is a stream, but an accelerometer is divided into 3 streams (x, y, z). This is because each axis may have a single numeric value at any given point in time. [Learn about types of streams.][4]

## The flow of data

The primary source of data in Simband is [Simsense][5]. Each sensor in Simsense generates data at a pace dependent on its speed of operation, events and context. Some sensors generate data each second, while others might be inactive for minutes at a time. 

All the data, when generated from the sensor, is marked by a timestamp. Depending on the [mode of operation][3], sensor data is either buffered locally in Simsense or data is sent to Simband using our [communication protocol][2]. Data generated from different sensors are normalized to the same clock and to a 128 Hz sampling rate before being sent to Simband.

This diagram shows how data flows from the sensor module to Simband and how data is made accessible to various algorithms, the Simband UI and SAMI.

![](/images/docs/simband/simband-documentation/semantics-of-simband/flow-of-data.png)

The Simband component `simsensed` receives the data from the sensor module, normalizes and categorizes the data, and sends the data to the `datad`. 

`simsensed` categorizes data into its [stream type](/simband/simband-documentation/semantics-of-simband/types-streams.html) and normalizes the timestamps to UNIX timestamps. 

`datad` stores the data into the database and makes the data available when requested by an algorithm or the Simband UI. `datad` is also connected to SAMI and uploads the stored data based on the availability of WiFi. In an ideal network environment, you will be able to see data flowing in and out of SAMI with a delay of a couple of seconds (this is mostly due to network latency). 

### Where algorithms come in

Algorithms running on Simband elaborate the data, store the results locally and push them to SAMI, and also display them to the user. An algorithm may request the current value in the stream coming from a given sensor, or it may read all values in a given time frame, and Simband will provide the correct information based on the availability of the data.

Streams are immutable—i.e., algorithms **cannot** modify a stream of data linked to a sensor. When an algorithm wants to store data to be used later, it will effectively create a new stream of data fed by the algorithm itself. 

The power of this implementation is that each algorithm is the "owner if its fate," and can alter it at any time in the way it wants. Other algorithms, meanwhile, can also "dip" into that stream and benefit from the computations that happen in Simband without repeating the same work.

## Simband operation modes

### Monitoring Mode
Monitoring mode is activated when the display is on, and one of the Simband applications is running. During this time, all sensors on Simsense are running and collecting data. Algorithms run regularly on the watch base. Simsense sends all data it gets from the sensors as a 128 Hz wave, without any analysis. The only algorithm that needs to regularly run on Simsense during monitoring mode is the sample-rate converter, which normalizes the different streams to the same clock and to a 128 Hz sampling rate.

### Collection Mode
Though monitoring mode gives us full flexibility, it consumes a lot of power, as it requires all the sensors and also the main A7 processor to be on. This is not feasible in a system that works 24 hours. Collection mode is activated when the screen is off and no Simband application is running. During this time, Simsense collects data and reduces it to heartbeats (with an attached confidence indication). Once every 20 to 60 minutes, based on power considerations, Simband will wake up, flush that data from Simsense, and make it available on Simband. 

[1]: /simband/simband-documentation/semantics-of-simband/applications.html#spotcheck "Spotcheck"
[2]: /sensor-module/sensor-module-documentation/sensor-module-communication-protocol/ "Sensor module communication protocol"
[3]: /simband/simband-documentation/semantics-of-simband/#simband-operation-modes "Simband operation modes"
[4]: /simband/simband-documentation/semantics-of-simband/types-streams.html "Types of streams"
[5]: /sensor-module/sensor-module-documentation/simsense.html "Simsense"
[6]: /simband/simband-documentation/simband-api.html "Simband API"
