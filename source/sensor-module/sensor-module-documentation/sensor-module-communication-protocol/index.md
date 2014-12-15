---
title: "Sensor module communication protocol"
nav:
  - 'protocol-usage-examples'
  - 'logic-capture'
---

# Sensor module communication protocol

Let's see how [Simsense][1] talks to [Simband][1], or how any sensor module can talk to Simband.

Here you'll find the sensor module communication protocol and data transfer protocol. The protocol defines a generic frame structure that enables the transfer of data over a hardware interface from a source to a destination while having features to ensure data integrity, reliable transfer and segmentation between the two sides.

## Protocol goals

1.  Protocol software implementation should be abstracted from the hardware interface used for data transfer.
2.  Two-way communications with the ability to configure and query data across the different chain of sources and destinations.
3.  Application message format is extendible and allows backward compatibility.
4.  Data integrity should be sustained and verified during message/data exchange.
5.  Protocol packets are agnostic to the application data content inside the packets.
6.  Command/Response implementation.
7.  Allow some level of flow control.
8.  Allow packet segmentation.
9.  Allow last packet retransmission.

## Constraints

1.  Application payload is part of the user implementation.
2.  For this version of the protocol only Little Endian is supported.
3.  No encryption or authentication at protocol level—user payload (app layer) can be delivered encrypted, which makes it the responsibility of the user to decrypt it once delivered.
4.  Only one sensor module on the hardware bus. This sensor module can have multiple sensors that can serve as possible routing destinations.

## Physical layer

From a physical layer perspective, this document will address the following general hardware layout described in the Sensor Module Developer Guide document:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Simband-physical-layer.png)

Simband is connected to the sensor module by means of a standard SPI (CLK,MOSI,MISO,CS) hardware bus and an interrupt line which runs from the sensor module to the Base Unit. This interrupt line is used for wake-up purposes. Base Unit is the SPI master and Simsense is the slave (Clock is driven by Base Unit).

From a physical layer perspective as both CPUs are able to go into a sleep mode in order to conserve power the following wakeup method should be implemented:

1. When the sensor module wants to wake up the Base Unit or to signal that there is data ready to be transferred, it will pull the interrupt line low and wait until the SPI transaction begins to pull it back high. The interrupt line will stay high until the start of the next sensor module triggered transaction.

2. When the Simband wants to start an SPI transaction towards the sensor module, it will start the SPI transaction without signaling any specific lines to the sensor module (since there are none); instead, before the sensor module goes to sleep it will need to configure the SS line (a better choice) as a wake up source, or, tie the CS line in hardware, to a free GPIO that will serve as a wake up source.

## Protocol frame structure

The general protocol frame structure is as follows:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Protocol_frame_structure.png)

>OH = number of overhead bytes
>
>MAX FRAME SIZE = user-defined number that defines the entire frame size including the overhead bytes.
>
>For the purposes of this document the maximum frame size is set to 256 bytes (payload +data) as in the Simsense hardware this is the maximum allowed transfer on the SPI bus in one transaction. This number can be revised and modified later per sensor module implementation.

## Fields breakdown by order in the packet

###Frame start/frame termination
These fields mark the start and end of a frame. 

Since in the current Simband implementation we are using SPI which is a synchronous, non-continuous, hardware interface, **these fields are removed from the current implementation of the protocol** for the sake of simplicity of implementation and bus utilization. If in the future, Simband will use a hardware interface that is continuous in its nature and requires frame start/end markings, we might need to consider introducing these fields again. In this kind of hardware interface we will also need to introduce character stuffing methods.

###Packet type
This field is used to identify a generic packet type at the early stages of protocol parsing in order to detect, categorize and route frames to different handlers or discard the packet as invalid or request re-transmission if needed.

The following packet types are defined:

| **Packet Type** | **Code** | **Direction** | **Remarks**|
|----|---|----|--------|
| Data   | 0  | Sensor Module→Simband | Carries sensor sample data + meta data|
| Firmware Download| 1 | Simband→ Sensor Module| Carries "Chunks" of firmware binary image to be downloaded to the sensor module|
| Configuration| 2 | Simband→ Sensor Module| Configuration commands and Responses|
| Query/Status | 3 | Simband→ Sensor Module | Query Requests and Status results  |

>Firmware Download packet type is not used in the Simsense sensor module as it uses a proprietary boot loader found on the sensor module CPU.

###Length
This field holds the length of the payload of the packet in bytes, from the first byte after frame control field to the last byte before the FCS field.

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Packet_length.png)

###Destination (DST)
The purpose of this field is to identify the destination entity. The field is made out of two sub-fields:

1.  **DST Addr.** – The lower 5 bits of the DST field. The purpose of this sub-field is to identify the destination entity address.
2.  **DST Port -** The upper 3 bits of the DST field. The purpose of this sub-field is to identify the destination port of an address. This sub-field can also be used for channel multiplexing purposes.

###Source (SRC)
The purpose of this field is to identify the source entity. The field is made out of two sub-fields:

1.  **SRC Addr.** – The lower 5 bits of the SRC field. The purpose of this sub-field is to identify the source entity address.
2.  **SRC Port -** The upper 3 bits of the SRC field. The purpose of this sub-field is to identify the source port of an address. This sub-field can also be used for channel multiplexing purposes.

>In the current version of the protocol the SRC/DST Port sub-fields are not used as we do not have multiplexed channels on the Simsense sensor module and the Simband CPU. These fields are reserved for future use and should be set to '0' by the user.
>
>When using the SRC/DST fields in a system, the user must provision these fields based on the system topology in a way that there are no duplications of address values. For example, it is not allowed for two entities in the system to have the same SRC/DST address values. Also, Address '0' is always reserved for the Simband CPU and must not be used by the sensor module.
>
>The meaning behind the values of the SRC/DST fields is based on Simband/sensor module interpretation of the system topology. In this version of the protocol SRC/DST addresses represent the different system CPUs communicating which each other and their relative position to the Simband CPU.

The current definition of these fields in the Simsense sensor module is as follows:

| **Address Definition**  | **Code**  | **Remarks**                                                                                                                          |
|-------------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------|
| Simband CPU main address| 0         | Values 1-7 are reserved for future use of the Simband CPU.                                                                           |
| First Level CPU         | 8         | The CPU that is attached directly to Simband CPU (for example,M4 on Simsense). Values 10-31 are reserved for sensor module future use. |
| Second Level CPU        | 9         | The CPU that is attached To the first level CPU (for example,M0 on Simsense) . Values 10-31 are reserved for sensor module future use. |

**For example:**

| **Example**                                                                                                     | **SRC Addr.**   | **DST Addr.**   |
|-----------------------------------------------------------------------------------------------------------------|-----------------|-----------------|
| One CPU sensor module, configuration packet is sent from Simband to sensor module.                              | 0               | 8               |
| One CPU sensor module, configuration response packet is sent from sensor module to Simband.                     | 8               | 0               |
| Two CPU sensor module, configuration packet is sent from Simband to sensor module second level CPU              | 0               | 9               |
| Two CPU sensor module, configuration response packet is sent from sensor module second level CPU to Simband.    | 9               | 0               |
| Two CPU sensor module, configuration packet is sent from Simband to Sensor module first level CPU               | 0               | 8               |
| Two CPU sensor module, configuration response packet is sent from sensor module first level CPU to Simband      | 8               | 0               |
| Two CPU sensor module, first Level CPU sends a message to second level CPU                                      | 8               | 9               |
| Two CPU sensor module, second Level CPU responds to first level CPU                                             | 9               | 8               |
        
###Frame control
The frame control field contains bit coded information about the current transaction.

The byte is broken down to the following sub-fields:

| 7   | 6  | 5   | 4   | 3    | 2              | 1         | 0         |
|-----|----|-----|-----|------|----------------|-----------|-----------|
|Transaction type|Transaction type| TBD | TBD | Response Req.  | Retransmit/Retransmitted  | Overflow  | Truncated |

####Transaction type
This sub-field defines the packet sub-type. It serves as additional fine-grain information on top of the **packet type** field described above. 

This field is defined the following way:

| **Transaction Type**  | **Value** | **Remarks**                                                                                                                    |
|-----------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------|
| Command/Request       | 0         | Applies to packet types of Configuration, Firmware Download and Query requests going from Simband towards the sensor module.   |
| Response/Status       | 1         | Applies to all packet types that require response. Marks an acknowledgment of a received packet ('Ack')                        |
| Error                 | 2         | Applies to all packet types that require response. When transaction type is set to value '2' this means that there was an error with the previous command/query/firmware download packet or datap acket. This Transaction type marks ('Nack'). | 
| Data                  | 3         | Applies to data packets coming from the sensor module towards the Simband.                                                     |

**For example:**

1.  When sending a configuration command from Simband to sensor module:
    1.  **Packet Type** Field would be set to '2' (configuration)
    2.  **Transaction Type** sub-field type would be set to '0' (command)
2.  When an 'Ack' response arrives from the sensor module back to Simband:
    1.  **Packet Type** Field would be set to '2' (configuration)
    2.  **Transaction Type** sub-field type would be set to '1' (Response)
3.  Based on example 1 above, when an 'Nack' response arrives from the sensor module back to Simband:
    1.  **Packet Type** Field would be set to '2' (configuration)
    2.  **Transaction Type** sub-field type would be set to '2' (error)

####Request response
This sub-field, when set to '1' notifies the receiver side that the sender side is expecting a response packet for the last packet sent. When this sub-field is set to '0', no response is expected on sender side.

**For example:**
1.  When sending a configuration command from Simband to sensor module:
    1.  **Packet Type** field would be set to '2' (configuration)
    2.  **Transaction Type** sub-field type would be set to '0' (command)
    3.  **Request Response** sub-field is set to '1' marking a response is needed from the sensor module.
2.  When sending a data packets in monitoring mode from sensor module to Simband:
    1.  **Packet Type** field would be set to '3' (data)
    2.  **Transaction Type** sub-field type would be set to '3' (data)
    3.  **Request Response** sub-field is set to '0' marking no response required per received data packet.

####Retransmit/Retransmitted
This sub-field, when set to '1' with a 'Data' **packet type** (value '0') and a 'Data' **transaction type** (value '3') means that the current packet is a retransmitted packet. When set to '1' in with 'Data' **packet type** (value '0') field along with 'Error' **transaction type** (value '2') response, signals for the sensor module to retransmit the last packet sent over to the Simband.

**For example:** 
During data collection mode while data packets are being sent from the sensor module towards the Simband, one of the packets resulted in a FCS error. The Simband response to the sensor module for this packet would set the **packet type** field to 'Data' (value '0'), the **transaction type** sub-field to 'Error' (value '2') and the '**Retransmit**' sub-field would be set to value '1' – asking the sensor module to retransmit the last packet.

Once sensor module retransmits the last packet sent, it will set the '**Retransmitted**' sub-field to '1' and the **packet type** field and **transaction type** subfield to 'Data' (values '0' and '3' respectively). This would signal the Simband that this packet is actually a retransmission of the last packet sent from the sensor module. 

####Overflow
When this sub-field is set to value '1' in a data response packet, this means that the Simband is requesting the sensor module to stop the transmission due to a lack of memory/resources. Once data transmission is stopped, it can only be resumed by sending a specific configuration command to resume the process. This sub-field is relevant only when packets of **packet type** 'Data' (value '0') are being sent from the sensor module to the Simband.

####Truncated
When this sub-field is set to '1', this means that the packet being sent has overflowed the allowed transmission packet boundaries (MAX FRAME SIZE) and had to be segmented into several packets. When the last segment of the packet arrives, or when the packet fits the transmission packet boundaries, this field should be set to value '0' by the sender.

###Payload
When it comes to the payload, every sensor module has its own specific payload packets definition.

The payload content is used to extend the 'packet type' field by providing specific context to a generic type. For example, if we take the 'Configuration' packet type, while the protocol defines the generic container for transmission of a configuration command and a response, it is up to the sensor module development team to define the specific configuration packets and the information they carry in order for the sensor module to identify, parse and act on.

###FCS
A calculated frame checksum that covers all bytes in the packet starting with the **packet type** field all the way to the last payload byte. This field verifies the integrity of data received. When FCS is found to be erroneous, an error response will be sent back to sender that might result in retransmission of the last packet depending on the settings of the retransmit sub-field in the frame control byte.

## Fields order in the packet
The order of the fields in the packet was chosen such that the parsing software can make a quick determination as to the validity and the destination of the packet. The following flow chart shows the parsing path of a packet once it arrives into the destination CPU:

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Protocol_parsing_order.png)
**Protocol parsing order**
</div>


[1]: /sensor-module/sensor-module-documentation/index.html#terminology "Terminology"