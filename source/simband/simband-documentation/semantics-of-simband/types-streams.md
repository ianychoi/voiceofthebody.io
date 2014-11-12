---
title: "Types of streams"
---

# Types of streams

There are currently 7 primary streams available on Simband and a few derived streams. Below is the list of all available data sources on Simband. We are working to add more derived streams in the platform.

## Simsense data sources

Simsense supports a number of sensors. In our [Simsense reference implementation][2], six sensor types are included. Some sensors run continuously, while others are activated contextually or by user request. 

The following streams are available from the Simsense module. All the streams originating from Simsense are brought to 128 Hz, except GSR, which is at 32 Hz using the sample-rate converter algorithm.

1. [**PPG:**][3] The Simsense module sends 8 PPG streams to Simband, with corresponding stream indices.
        Note that not all PPGs may be available at any moment; the availability depends on power profile. Based on the confidence indicator of the PPG channel, an algorithm may choose the best PPG.

1. [**ECG:**][4] A stream representing the raw ECG data coming from Simsense.
1. [**Accelerometer:**](/sensor-module/sensor-module-documentation/simsense.html#accelerometer) 3 streams representing the x, y, z accelerometer values from Simsense.
1. [**Bio-Z:**][5] 2 streams representing the I & Q bio-impedance from Simsense.
1. [**GSR:**][6] 2 streams representing the tonic and phasic galvanic skin response.
1. [**Skin temperature:**][7] A Celsius value of the measured skin temperature.
1. [**ECG lead:**][4] An enum value representing whether the user is currently touching the ECG clasp.

## Algorithm data sources

1. **HeartBeat:** A beat-detection stream derived from PPG.
1. **HR:** A beat-to-beat heartrate stream based on PPG.
1. **Blood pressure:** Two discrete streams—systolic and diastolic, representing blood pressure computed at the end of a [spot check][1].
1. **Visual, confidence and beat overlays:** PPG and ECG channels may have those overlays. (See [stream metadata][8] for more information.)
1. **PAT:** A discrete Pulse Arrival Time computed during spot check, later used as a precursor to calculate blood pressure.  
1. **HRV:** Heart rate variability computed at the end of a spot check. (Learn how to [write an HRV algorithm][9] )

## Simband data sources

1. **Steps (increments):** A stream representing number of steps since last measurements, based on the Tizen pedometer.
1. **Steps (daily):** A cumulative version of the incremental step counter, which resets itself every day.
1. **Activity:** An enum stream representing the result of the Tizen activity recognizer. May be walking, running, stationary, in-vehicle or unknown.

## Stream metadata
Apart from the numeric data, every stream has metadata that classifies it.
The following characteristics may classify a stream:

1. **Rate:** Sample rate of the stream (in Hz).
1. **Category:** One of the following:
   1. **signal:** A continuous stream of analog numeric data, e.g., PPG.
   1. **rate:** A number that is averaged over a given time period, e.g., heart rate.
   1. **discrete:** A single numeric value, e.g., blood pressure.
   1. **increment:** An integer that is added to the previous data point, e.g., step count.
   1. **enum:** An integer where every value has a separate meaning, e.g., activity (stationary, walking, running, etc).
   1. **feature:** A point in time when an event occured, and the value does not matter, e.g., a detected heartbeat.
   1. **quality:** A fraction between 0 and 1 representing the level of accuracy of a different value, e.g., ECG confidence indication.
1. **Type:** A URI representing the unique identifier for this type of stream. URI can be `com.somecompany.someplatform.somealgorithm`. For example, all PPG channels have the same type: `com.samsung.simband.ppg` is the type defined in `simsense.json`. 
1. **Index:** If several streams exist with the same type, the index would differentiate between them.
    For example, accelerometer streams would have the same type (`com.samsung.simband.accelerometer`) but each would have a different index.
1. **Origin:** Represents the module that collected this stream; either "base" or "sense".
1. **Time denominator:** For rate streams; this represents the time period over which the rate is calculated. Can be second, minute, hour, or day.
1. **Values:** For enum streams; this represents the description for each possible value in the stream.
1. **Visibility:** Can be "debug", "base", or "sami". "debug" streams are available only in the debug tools. "sami" streams are collected to the cloud. "base" streams are available for installable algorithms.
1. **Overlays:** Every stream may have "overlays". An overlay is a different stream, with data derived from this stream.
   The types of overlays are defined by the platform:
   1. **visual:** A derivative of the stream that is filtered to better suit visual representation, e.g., by applying a band-pass filter.
   1. **beats:** A **feature** stream representing detected beats from the original stream.
   1. **confidence:** A **quality** stream representing the estimated accuracy of the original stream.
   1. **raw:** A stream representing the data of the stream prior to any sample-rate conversion.
1. **Description:** A human-readable text describing the stream.



[1]: /simband/simband-documentation/semantics-of-simband/applications.html#spot-check "What is a spot check?"
[2]: /sensor-module/sensor-module-documentation/simsense.html "Simsense"
[3]: /sensor-module/sensor-module-documentation/simsense.html#ppg "What is PPG?"
[4]: /sensor-module/sensor-module-documentation/simsense.html#ecg "What is ECG?"
[5]: /sensor-module/sensor-module-documentation/simsense.html#bio-z "What is Bio-Z?"
[6]: /sensor-module/sensor-module-documentation/simsense.html#gsr "What is GSR?"
[7]: /sensor-module/sensor-module-documentation/simsense.html#skin-temperature "What is Skin temperature?"
[8]:/simband/simband-documentation/semantics-of-simband/types-streams.html#stream-metadata "Meta data"
[9]: /simband/simband-documentation/writing-algorithms-using-simband-api.html "Your first Simband algorithm"