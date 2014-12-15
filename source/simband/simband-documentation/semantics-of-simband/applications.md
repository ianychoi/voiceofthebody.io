---
title: "Applications"
---

# Applications

## Monitor
The monitor is an application that enables a sensor-module or algorithm developer or researcher to view the raw signals as they come
out of the sensor module. It is separated by rows, each row showing current data over a period of 5 seconds.

The monitor application is configurable via `monitor.json`, as the data displayed in the monitor is custom for a particular sensor/algorithm pack.


<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/monitor01.png)
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/monitor02.png)
 **Monitor application**

</div>

## Spot Check
The spot check is a wizard-style application that guides the user to make sure they are holding the band correctly and that they are steady and level before a 30-second measurement is taken. The spot-check application relies on confidence indications from various streams and on the Simband accelerometer to decide whether the conditions are met for a test. During the test, a "spot-check" enum stream receives "on" data that can be used by algorithms that want spot-check data only.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/spotcheck01.png)
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/spotcheck02.png)
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/spotcheck05.png)
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/spotcheck06.png)
 **Spot Check application**

</div>

## Dashboard
The myTrends screen takes selected streams from Simband and displays them in a chart over a day. This is the first instance of data visualization that is geared more toward users than developers.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/semantics-of-simband/applications/dashboard.png)
**Dashboard application**
</div>

## Simband Settings
While Simband comes with the usual device settings such as WiFi, display and power, the Simband settings enable calibrating the actual guts of Simband.

To open the settings, open `Settings` -> `Simband` -> `Advanced`. Once you are connected to WiFi, you will see a dialog referring to a URL. Point your browser to that URL.

The web-based application allows you to set all the different options in Simband that are configurable. For example, it allows you to switch Simband to a simulation mode where the data is generated from a sine wave rather than from real sensors.

The following settings are available:

1. **SAMI token/device-id:** Set up the connection to SAMI.
1. **Simband mode:** Switch between real and simulated modes. In the future this will also allow replay mode.
1. **Algorithm calibration:** Allows the user to input personal data that can be used by algorithms such as blood-pressure.

## Data Collection Tool
Simband exposes a web interface called the Data Collection Tool. It is available via `http://[simband-IP-address]:2263/collect.html`.

In this tool, a researcher can collect data from all the streams available in Simband, and save them in the following formats:

- Can format, a recording of the data that allows you to later replay it in a loop.
- CSV format, a 2D table of time/stream that can be used for analysis with tools like Matlab.

Data can be accessed when the sensors are active.
