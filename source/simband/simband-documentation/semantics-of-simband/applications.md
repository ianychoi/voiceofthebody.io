---
title: "Simband applications"
cors: true
nav:
  - 'settings'
---

# Applications

Simband comes equipped with 4 very basic applications. On this page we cover them in depth, along with device settings and some hidden/advanced settings.

## Monitor

Monitor is an application that allows a user to look at their data in real-time. The app provides basic metrics like daily `steps`, current `activity` status and current heart rate (`HR`), and it graphs the data as it comes in from the sensors. Monitor is ideal for developers and researchers to monitor the current status of the device in daily use and when collecting data for a new algorithm or a trial.

Each signal is separated by rows, each row showing current data in a 5-second window.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/monitor1.gif)
 ![](/images/docs/simband/simband-documentation/applications/monitor2.gif)
 **Monitor application**
</div>

As an algorithm developer you will be able to configure the Monitor app to also display your data. At this time, we show the results of the following algorithms:

- Heart rate (`HR`), optimized for static conditions.
- `LBHR`, an HR algorithm optimized for physical activity that takes advantage of motion artifact reduction. This algorithm was developed and licensed from [LifeBeam](http://life-beam.com/), one our early partners.
- Pulse Arrival Time (`PAT`). 

In addition, `Channel` selection shows the channel that is selected for computing the heart rate.

The application also displays whether or not Simband is on the `Wrist`. When you touch Simband's active clasp with your other hand, making an electrical loop around the heart, the ECG `Lead` signal goes ON and one lead `ECG` is computed and displayed. When ECG is computed, `PAT` (Pulse Arrival Time) is also computed and displayed. PAT is the interval between R-peak in ECG and pulse arrival in PPG. PAT is dynamic and changes every few seconds. Skin temperature (`SkTEMP`) displays the computed outside skin temperature in Celsius.

**Brighter colors** in the charts mean higher confidence in the signal and algorithms. In each chart is presented a little number (e.g., x4/x25) that indicates scale. The number represents amplitude, or number of units per pixel. The **bigger** the number is, the stronger the signal.

`PPG01` is for PPG channels "0" and "1" where channel 0 is the blue PPG and channel 1 is green signal. List of all PPG channels is listed [here](/sensor-module/sensor-module-documentation/simsense.html#ppg).

## Spot Check
Spot Check is an example of how a developer can create an application to guide a user through a few steps to collect data. In this case we calculate `PAT`. Spot Check guides the user to make sure they are holding the band correctly and that Simband is steady and level on the wrist before a 20-second measurement is taken. This application relies on confidence indications from various streams and the Simband accelerometer to decide whether conditions are met for a test. The collected data can be reviewed in the Dashboard application (see below).

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/spotcheck.gif)
 **Spot Check application**
</div>

## Dashboard
The Dashboard application takes selected streams from Simband and displays them in a chart of My Trends over a day. This is the first instance of data visualization that is geared more toward users than developers.

Currently it displays data trends including: Daily steps, heart rate (HR) and pulse arrival time (PAT). The heart rate displayed here is a collection of heart rate data collected from different [modes of operation][2]. A simple smoothing function is applied to the outputs before they are displayed in Dashboard.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/dashboard.png)
**Dashboard application**
</div>

## Fitness
During [Fitness mode][1], the Fitness application will display your heart rate periodically (every 1 sec) using the LBHR algorithm's output. Data from Fitness is automatically aggregated and displayed in Dashboard. The Fitness application launches automatically whenever Simband transitions into Fitness mode. The application will run in the background and will be displayed when the screen is turned on.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/fitness.png)
 ![](/images/docs/simband/simband-documentation/applications/fitnessWithChart.png)
**Fitness application**
</div>

[1]: /simband/simband-documentation/operation-modes.html#fitness-mode "Fitness Mode"
[2]: /simband/simband-documentation/operation-modes.html "Simband operation modes"