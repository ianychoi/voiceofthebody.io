---
title: "Developer guide"
nav:
  - 'design-essentials'
  - 'mechanical-overview'
  - 'electrical-overview'
  - 'sensor-module-communication-protocol'
  - 'simsense'
---

# Developer guide

Simband raises the standard of health and activity data that can be collected from a wearable health device. [Data on Simband][6] works to foster new algorithms and better insights, and also provides an opportunity to develop new types of sensor modules.

This documentation shows how we built Simsense; our reference implementation. Simsense is designed to push the limit on the number of sensors that work together on a wristband, while still being comfortable to wear.

![](/images/docs/sensor-module/sensor-module-documentation/simsense-top-oblique.png)

We want to take wearable sensors even further. This is where you come in. Simband's modular platform makes it easier to customize Simsense, or integrate an entirely new sensor module. You'll need to understand the mechanical and electrical constraints, debug some of your code or even ours and implement our communication protocol to talk to Simband. 

## What this documentation covers

- An overview of Simsense's hardware, including its [mechanical][5] and [electrical][4] assembly. 
- The [communication protocol][2] that Simsense, or a custom sensor module, uses to talk to Simband.
- Sensor information for [Simsense][1], our reference implementation.
- Get access to Simsense's [schematics][3] and mechanical design files.

[1]: /sensor-module/sensor-module-documentation/simsense.html "Simsense"
[2]: /sensor-module/sensor-module-documentation/sensor-module-communication-protocol/index.html "Sensor Module Communication Procotol"
[3]: /sensor-module/schematics.html "Schematics"
[4]: /sensor-module/sensor-module-documentation/electrical-overview.html "Electrical overview"
[5]: /sensor-module/sensor-module-documentation/mechanical-overview.html "Mechanical overview"
[6]: /simband/simband-documentation/semantics-of-simband "Semantics of Simband"