---
title: "Simband operation modes"
---

# Simband operation modes

Simband has three modes of operation. We defined each mode to address a different need for data collection, while also addressing functionality and battery life. Each mode defines which sensors will be activated and when and what data will be collected. The transition from one operation mode to another is determined by context and user input.

## Monitoring mode
As the name suggests, this mode in Simband is used for monitoring of signals. Monitoring mode is activated when the Monitor application is launched. During this time, all sensors on Simsense are running and collecting data. Simsense sends all data it gets from the sensors to the base, making them available for algorithm consumption on the base. During Monitoring mode, the only algorithm that runs regularly on Simsense is the sample-rate converter, which normalizes the different streams to the same clock and to a 128 Hz sampling rate.

## Collection mode
Though Monitoring mode gives us full flexibility, it consumes a lot of power, as it requires all the sensors and also the main A7 processor to be on. This is not feasible in a system that works 24 hours. Collection mode is activated when no Simband application is running. During this time, Simsense silently turns on one PPG channel, collects data and extracts heart rate (with an attached confidence indication). Once every 20 to 60 minutes, based on power and memory considerations, Simband will wake up, flush that data from Simsense and make it available on Simband, and eventually on SAMI.

## Fitness mode
Fitness mode is geared toward Fitness and activity. Simband will transition into Fitness mode whenever Simband detects any physical activity (e.g., walking or running) or when heart rate (HR) > 110 (configurable). This mode can be explicitly turned on by activating the [Fitness application](/simband/simband-documentation/applications.html#fitness). All Simband sensors are activated to collect data in this mode, just like in Monitor mode.