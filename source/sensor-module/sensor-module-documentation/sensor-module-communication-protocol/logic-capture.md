---
title: "Logic analyzer captures"
---

#Protocol data transfers over SPI bus
Data transfer from sensor module to Base Unit:

- Simsense interrupts the Base Unit by pulling the INT line low.
- Base Unit reads first 4 bytes to get protocol header and extract length.
- Base Unit reads rest of the packet.

## Packet overview

###Transaction: Packet overview
![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/packet-overview.png){:.lightbox}
**Packet overview**

###Transaction: Read: First 4 bytes
![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/read-first-4-bytes.png){:.lightbox}
**Read: First 4 bytes**

###Transaction: Read: Rest of the packet:
![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/read-rest-of-the-packet-01.png){:.lightbox}
**Read: Rest of the packet (1)**

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/read-rest-of-the-packet-02.png){:.lightbox}
**Read: Rest of the packet (2)**


##Configuration command sent from Base Unit to sensor module

###Transaction: Packet overview:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/packet-overview-command-sent-baseunit-sensor.png){:.lightbox}
**Packet overview (Command sent: Base Unit to sensor module)**

##Ack sent back from sensor module to Base Unit

###Transaction:Packet overview:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/packet-overview-command-sent-sensor-baseunit.png){:.lightbox}
**Packet overview (Command sent: sensor module to Base Unit)**

###Transaction: Ack first 4 bytes:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/ack-first-4-bytes.png){:.lightbox}
**Ack first 4 bytes**

###Transaction: Ack last 4 bytes:
 
![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/logic-capture/ack-last-4-bytes.png){:.lightbox} 
**Ack last 4 bytes**
    