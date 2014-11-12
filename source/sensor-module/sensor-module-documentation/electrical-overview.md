---
title: "Electrical overview"
---

# Electrical overview

In [Mechanical overview](/sensor-module/sensor-module-documentation/mechanical-overview.html), we mentioned that the Simsense bucket connector provides an electrical connection between the Simsense and Base Unit. This article covers the electrical constraints to keep in mind when designing a sensor module.

Below is the schematic snippet for the connector connecting Simsense and Base Unit with the table containing associated pin functions.

![](/images/docs/sensor-module/sensor-module-documentation/electrical-overview/simsense-connector-electrical.png)
**Connector schematic snippet** 

| Pin#      |Associated Function       | Net name|
|-----------|--------------------------|---------| 
| 1         | Master Output Slave Input|S_MOSI|
| 2         | Master Input Slave Output|S_MISO|
| 3         | Reset (Active low)       |S_RST_n |
| 4         | Clock                    |S_CLK |
| 5         | Chip Select              |S_CS  |
| 6         | Interrupt (Active low)   |S_INT_n |
| 7         | Power Source             |VDD   |
| 8         | Reserved for future use* |RSVD  |
| 9         | Reserved for future use* |RSVD  |
| 10        | Ground                   |GND   |
| 11        | Reserved for future use* |RSVD  |
| 12        | ECG Lead 2 on clasp      |ECGN2 |

  
## Power

Power is conveyed to Simsense via pin 7, which operates at a nominal single cell Lithium Ion battery voltage range of 3.0V to 4.2V. Power supplied to the module is routed through a power integration function on the base module which provides an accurate measurement of the instantaneous power and total energy consumed by Simsense.
 
Although there is no active current limit or fuse function between the Base Unit and Simsense, an instantaneous limit of 100mA is the maximum allowed. An average limit of 50mW over a 24-hour period is the maximum power draw allowed for Simsense.

| Description                           | Min.  | Typ.  | Max.  | Units |
|---------------------------------------|-------|-------|-------|-------|
| **Input voltage to Simsense**         | 2.94  | 3.60  | 4.45  | V     |
| **Current limit (max. 3.2hrs)**       |       |       | 100   | mA    |
| **Power limit (Ave. over 24hrs.)**    |       |       | 50    | mWh   |

Shutdown voltage for the entire band is nominally 3.0V, but for 100mA peaks at 3.0V, the calculated voltage drop between the base module and Simsense is 60mV worst case. The maximum charge termination voltage for most LiIon cells is 4.20V, but for some high-capacity cells reaches 4.45V. It is recommended that an Abs. Max. tolerance for Simsense is 4.6V minimum.

### Power usage example

As the above table indicates, average power must be below 50mW but peaks to above 400mW are allowed depending on the supplied voltage (100mA * 4.45V). How does this work in practice? Most sensing systems will have small periods of high power use surrounded by longer periods of very low power use. 

Let's take one second and divide it into 10 100mS slices. For most of the second, power to the sensor is between 3mW to 10mW, but for 100mS a high-power-consuming component is switched on and it consumes 360mW. This is shown in the following graph:

![](/images/docs/sensor-module/sensor-module-documentation/electrical-overview/Power_graph.png)
**Example of one second of power consumption**

The average power consumption for the full second is 39.8mW. If this second is repeated for 24 hours, again the average power consumption for that 24 hours will be 39.8mW, which is under the 50mW limit allowed for a sensor module. 

![](/images/docs/sensor-module/sensor-module-documentation/electrical-overview/60sec_power_graph.png)
**60 seconds, each the same as in the previous table**

Now typically the sensor is not active for the full 24 hours, so the power usage is more complex. The average of 24 hours is simply the linear fraction of the total, so for example if the sensor is used 8hrs out of 24, the average power is 39.8mW * 8/24, or 13.3mW.

## Sensor module security

In order for the sensor module to be aligned with Samsung's security protocols for Simband, the sensor module must incorporate a security element. The sensor module authentication process ensures that only genuine Samsung-licensed sensor modules can communicate with SAMI. 

Cryptographic keys are stored inside a secure element (an authorized semiconductor chip), supplied pre-programmed to Samsung licensees. These keys are needed to sign into SAMI. Without a sensor module containing a genuine secure element, the Simband cannot access a user account, upload data to SAMI, or receive software and algorithm updates.

## Data interface signals

Data is transferred between Simsense and the Base Unit by a serial peripheral interconnect (SPI) interface that operates in the slave mode (clock originates from the Base Unit). In addition to the required data in, data out, clock and chip select signals, an interrupt from the sensor unit to the base module allows the sensor unit to alert the base module to activity requiring attention. A reset signal input provides a hard reset capability from the base module to reinitialize Simsense. 

The clock rate currently used in the system is 2MHz.

All signals operate at 1.8V nominal CMOS limits.
   
| Parameter  |                           | Conditions    | Min.       | Typ.       | Max        | Unit       |
|------------|---------------------------|---------------|------------|------------|------------|------------|
| **Vih**    | High level input voltage  | VDD +- 10%    |            |            |            | V          |
| **Vil**    | Low level input voltage   | VDD +- 10%    |            |            | 0.3×VDD    | V          |
|  **∆V**        | Hysteresis                |               | 0.15       |            |            | V          |
| **Iih**    | High level input current  | Vin = VDD     | -3         |            | 3          | µA         |
| **Iil**    | Low level input current   | Vin = VSS     | -3         |            | 3          | µA         |
| **Voh**    | High level output voltage | Ioh = -1.8mA  | 0.8×VDD    |            |            | V          |
| **Vol**    | Low level output voltage  |  Iol = 1.8mA  |            |            | 0.2×VDD    | V          |
| **Cin**    | Input capacitance         | Any input     |            |            | 5          | pF         |
 


## Timing diagrams
In order for Simsense to communicate properly with the base, SPI communications should be followed by the given timing constraints.

![](/images/docs/sensor-module/sensor-module-documentation/electrical-overview/SPI_Timings_A7.PNG)
**SPI interface timing (CPHA = 0, CPOL = 1)**


|Parameter|Symbol|Min.|Typ.|Max.|Unit|
|---------|------|----|----|----|-----|
|**SPI MOSI Master Output Delay time**|t<sub>SPIMOD</sub>|-|-|4|ns|
|**SPI MISO Master Input Setup time (FB_CLK_SEL = 11)**|t<sub>SPIMIS</sub>|-2|-|-|ns|
|**SPI MISO Master Input Hold time**|t<sub>SPIMIH</sub>|5|-|-|ns|
|**SPI MOSI Slave Input Setup time**|t<sub>SPISIS</sub>|3|-|-|ns|
|**SPI MOSI Slave Input Hold time**|t<sub>SPISIH</sub>|5|-|-|ns|
|**SPI MISO Slave Output Delay time**|t<sub>SPISOD</sub>|-|-|18|ns|
|**SPI nSS Master Output Delay time**|t<sub>SPICSSD</sub>|7|-|-|ns|
|**SPI nSS Slave Input Setup time**|t<sub>SPICSSS</sub>|5|-|-|ns|

>Measurement conditions: VDDINT = 1.0V +-5%, T<sub>A</sub> = -25<sup>0</sup>C to 85<sup>0</sup>C, VDDext = 1.8V +- 10%, load = 15pF


## Reserved pins
There are three pins (8, 9, 11) marked as _RSVD_ and may not be used without the permission of Samsung. Pads for these pins should be placed on your PCB and should be left unconnected.