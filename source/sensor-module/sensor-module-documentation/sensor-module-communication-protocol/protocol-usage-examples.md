---
title: "Protocol usage example"
---

# Protocol usage examples
The following section consists of several scenarios that demonstrate the protocol usage.

Please refer to the following table header color legend:

1. Green - Simband to sensor module.
2. Blue - sensor module to Simband.

Please refer to the following cell color highlighting legend:

1. Pink - Change of field(s) during a transaction.
2. Blue - Subtle change of field(s) during a transaction.

## Configuration command and response
Simband sends a configuration command to first level CPU, receives 'Ack'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Configuration_command.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Configuration_command_response.png)
    

## Configuration command and response – error response
Same scenario as above, Simband receives 'Nack'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Configuration_command_and_response_error_response.png)

* Simband reads configuration response error parameters and acts accordingly—this is done as part of the application layer.


## Query command and response

Simband sends a query request to second level CPU, receives 'Ack'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Query_command.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Query_command_response.png)


## Query command and response – error response

Same scenario as above, Simband receives 'Nack'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Query_command_error_response.png)

* Simband reads query response error parameters and acts accordingly – this is done as part of the application layer.


##Query command and response – segmented packet
Same scenario as above, Query response is segmented over 2 packets (using truncated sub-field)

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Query_command_and_response_segmented_packet.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads the second part of the response packet (truncated goes to '0')

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Query_command_and_response_segmented_packet2.png)


##Monitoring mode data transfer
Simband in monitoring mode, receives data from second level CPU (relayed by first level CPU)
    * Sensor module pulls INT line low
    *Simband reads packet:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Monitoring_mode_data_transfer.png)

* No response required for Data in monitoring mode.


##Data collection mode – FCS failure and retransmission

Simband in data collection mode, sensor module sends data packets, Frame fails FCS, Simband sends 'Nack' with retransmission request

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_FCS_failure_command.png)

* Received data packet fails FCS
* Simband sends 'Nack' with retransmission request – retransmit flag set to '1'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_FCS_failure_command_response.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads the retransmitted packet (retransmitted flag set to '1'):

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_FCS_failure_command_retransmit.png)

* Simband sends 'Ack' response for the retransmitted packet

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_FCS_failure_command_retransmit_response.png)


## Data collection mode - packet segmentation
Same scenario as above, data packet is segmented over 3 packets (using truncated sub-field)

* Sensor module pulls INT line low
* Simband reads packet:


![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation.png)

* Simband sends 'Ack' response packet for the first segment:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation_response.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads the second part of the data packet (truncated still is '1'):

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation_segmented_packet1.png)

* Simband sends 'Ack' response packet for the second segment:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation_segmented_packet1_response.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads the last part of the data packet (truncated set to '0'):

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation_segmented_packet2.png)

* Simband sends 'Ack' response packet for the last segment :

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_packet_segmentation_segmented_packet2_response.png)


## Data collection mode - overflow

Simband signals overflow while collecting data (using overflow sub-field)

* Sensor module pulls INT line low
* Simband reads packet:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_overflow.png)

* Simband sends 'Ack' response packet, however, overflow field is set to prevent sensor module from sending more data :

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_overflow_response.png)

*  Sensor module stops sending data until it receives specific configuration command to resume.
*  Simband sends a configuration command to resume data collection:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_overflow_response2.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Data_collection_mode_overflow_command2.png)

* Sensor module pulls INT line low
* Data packets flow resumes


##Firmware download from Simband to first level CPU

*  Simband sends the firmware download command to first level CPU

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_command.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_command_response.png)

* Simband starts sending the FW packets first level CPU (truncated subfield is set to '1'):

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response time
* Simband reads response packet – 'Ack' received:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command_response.png)

.

.

.

Packet download continues

.

.

.



* Simband sends firmware packet #m to first level CPU:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command2.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet – Instead of 'Ack', 'Error' transaction type is set and retransmit sub-field is set to '1':

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command2_response.png)

*  Simband retransmits packet #m to first level CPU (retransmitted subfield is set to '1'):

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command3.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet –'Ack' received for retransmission, retransmit sub-field is back to '0'

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command3_response.png)
.

.

.

Packet download continues

.

.

.


* Simband sends last firmware packet to first level CPU, truncate subfield is set to '0' to mark end of FW download:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command4.png)

* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet – 'Ack' received:

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command4_response.png)

* Simband sends 'RESET' configuration command:
     
![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command5_reset.png)
 
* Start response timer
* Sensor module pulls INT line low
* Stop response timer
* Simband reads response packet

![](/images/docs/sensor-module/sensor-module-documentation/sensor-module-communication-protocol/Firmware_Download_FW_packet_command5_reset_response.png)

At this point first level CPU resets itself and start running again with new firmware.
Simband will poll for the version string, once received this would an indication that the sensor module is up and running.

>We might need to change the startup from reset procedure to a more elaborate handshake protocol. This could be done separately with different sensor module vendors.

## Corner case scenarios

Although the protocol defined above defines the data exchange over the hardware interface, there are some corner case scenarios that are not directly related to the protocol and need to be addressed.

The following is a list of such scenarios and the recommendations on how to handle them. Most corner case scenarios should be handled by a user defined policy per sensor module.

###Timeouts
As can be understood from the usage examples in the previous section, there it is implied that the Simband/sensor module implementation of the protocol uses timeouts and timers to track requested responses from the receiver side. The usage of timeouts and response tracking timers on the sensor module side is highly recommended, however, not a must.
From the Simband side, timeouts will be used to track configuration requests and query results as well as firmware download packets. In the case of no response from the sensor module timer within a predefined timeout, Simband will try to retransmit the configuration command/query request/last firmware packet up to N (TBD) times before reporting to the upper layers that the sensor module is not responsive. The handing of an unresponsive sensor module is application-dependent and might be different per sensor module.

###Multithreading
Most scenarios described in the previous section assume a serialized access to the hardware interface. In a multithreaded environment it is up to the user to provide mutual exclusion or serialization mechanisms (Semaphores, Queues…) in order to ensure atomic access to the hardware bus.

###Multiple configuration commands/query requests*
While the protocol implements a command response type of transactions, there is no hard requirement or limitation for sending a batch of configuration commands/query requests one after the other (assuming that access to the hardware bus is packet atomic and protected by the one of the mechanisms described in section 2 above). In such cases, it is up to application layer to differentiate the between the different responses coming back to the sender as they can be out of order due to different processing times on the sensor module. One possible option to handle these situations is to utilize the **SRC/DST port** bits in order to multiplex different responses as they come. For the sake of Simplicity, the current Simband implementation does not allow multiple configuration commands/query requests.


[1]: /sensor-module/sensor-module-documentation/index.html#terminology "Terminology"