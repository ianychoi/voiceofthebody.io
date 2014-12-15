---
title: "Mechanical overview"
---

# Mechanical overview

Simsense is designed to uphold our core design principle of a modular platform. 

By considering two primary design aspects—[mechanical][1] and [electrical][2]—you can build your own version of the sensor module and easily integrate it with Simband.

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/simsense-cross-section-oblique02.png)
**Simsense module cross-section**

In this article, we describe Simsense's mechanical assembly, which demostrates cutting-edge flexible mechanical form factors. Below we have shown the spread assembly of Simband's reference sensor module—Simsense.

##Simsense mechanical parts

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/simsense-exploded-view.png)
**Simsense module spread assembly**

###Wrist layer 

Surrounds the sensors interacting with the user's wrist. This layer is made of polyurethane. This layer is for sensor support, comfort and durability.

###Athena

Athena is the flex PCB of the Simsense reference design, which contains all the sensors with minimal circuitry. On the bottom of Athena is a female connector that connects Athena to Apollo, electrically. The PCB is complete hard flex with solid center.

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/athena-electrode-optical-component-placement.png)
**Athena electrode and optical component placement**

###Top cover

This layer is attached to Athena with PSA tape and epoxy. Apollo is secured when the top cover and bottom cover are connected. The top cover is secured by screws.

###Apollo

Apollo is the signal conditioning and processing core of the Simsense reference design which contains two microcontrollers and other power conditioning circuits for Athena. On the top of Apollo is a connector that connects to Athena. On the bottom of Apollo are 12 pads that are aligned to the spring contact connector in the Simsense bucket (see below). The PCB is rigid-flex-rigid-flex-rigid.

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/apollo-bottom.png)
**Apollo bottom connector**

###Bottom cover

The bottom cover secures Apollo when connected with the top cover. The bottom cover is designed with consideration of Simsense bucket dimensions.  

###Simsense bucket

The Simsense bucket is built into the wristband. It contains two cantilevel spring style connectors, a flex connection running from the bucket to the watch that carries the electrical signals from Apollo to Simband, and 4 screws that secure the top cover with the bucket to ensure electrical and mechanical stability. The Simsense sensor module is designed to fit into the bucket. The outer dimensions of the module are fixed, while the interior region is free for your use. 

###Screws

4 screws of type M1 thread x 2.75mm length are used to secure Simsense in the bucket. The cross-section below shows how the screws fit into the top cover. 

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/simsense-cross-section-oblique03.png)
**Screw binding**

###Simsense bucket connector

Simsense connects to Simband via two 6-pin low-profile cantilevel spring style connectors that contain the power, data, sensor signal and reserved pins. On the Simsense side there are 12 individual contact pads, aligned to make contact when the Simsense is placed in the Simsense bucket. 

The Simsense bucket connector is shown below.
<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/simsense-bucket-connector.png)
</div>

###Thickness dimensions

| Layer                    |Thickness  [mm]| 
|--------------------------|------------------|
| **Athena Flex**          | 0.1              |
| **Top Cover**            | 0.5              |
| **Apollo PCB - Rigid**   | 0.86             |
| **Apollo PCB - Flex**    | 0.24             |

## Removing and attaching sensor module

The Simsense module is designed to be attached to Simband with 4 micro screws. The Simsense bucket should include 4 M1 threaded x 2.75mm  screw locations as shown in the diagram below: 

![](/images/docs/sensor-module/sensor-module-documentation/mechanical-overview/simsense-screw-dimension.png)
**Locations of the 4 M1 threaded x 2.75mm screws in the Simsense top cover**

[1]: /sensor-module/sensor-module-documentation/mechanical-overview.html#simsense-mechanical-parts "Mechanical overview"
[2]: /sensor-module/sensor-module-documentation/electrical-overview.html "Electrical overview"