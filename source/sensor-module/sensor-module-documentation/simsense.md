---
title: "Simsense: Sensor overview"
---

# Simsense: Sensor overview

Simsense is an example of a multi-sensor module that has been developed for Simband. Here we describe its sensors as an aid to future sensor module development. 

Simsense includes six types of sensors:

- Electrocardiogram (ECG)
- Bio-Impedance (Bio-Z)
- Photoplethysmogram (PPG)
- Galvanic Skin Response (GSR)
- Accelerometer
- Skin Temperature (thermometer)


![](/images/docs/sensor-module/sensor-module-documentation/simsense/simsense-layout.png){:.lightbox}


## Sensor overview & electrical characteristics

###ECG

The Electrocardiogram (ECG) sensor measures the electrical activity of the heart. The electrodes need to be placed across the heart, or in practical terms, one on each side of the heart. A clinical lead 1 signal measures from the left wrist to the right wrist. A surrogate for this measure can be done using the index finger of the right hand touching the left wrist, with the electrodes in between. The position of electrodes on the band is less important. So long as the electrodes enable this connection of the left and right arms/wrists/hands.

| **Parameter**| **Options**| **Value**|**Units**|
|--------------|------------|----------|---------|
| IA gain      |25/70/220   |25        | V/V     |
| PGA gain     | 1/2/4      | 1        | V/V     |
| ADC sampling rate |128/256/512| 512  |Hz       |
|ADC resolution | Fixed |18| bit (signed) |
|ADC ENOB | Fixed | 13.5 | bit |
|FIR filter enable | Yes/No | Yes ||
|FIR filter bandwidth | Depending on sampling rate | 40| Hz|

###Bio-Z

For heartrate measurement, the bio-impedance sensor aims to measure the pulse wave of blood flow in an artery. This can be achieved because the blood has different impedance to the surrounding tissue, such that the variation in impedance as the volume of blood changes can be measured.

| **Parameter**| **Options**| **Value**| **Units**|
|--------------|------------|----------|----------|
|Current frequency| 2/20/40 | 40       | KHz      |
|Current amplitude| Fixed   | 200      | µA(peak-peak)|
|                 | Fixed   | 100      |µA(RMS)   |
|Current shape    | Fixed   | Square   |          |
|IA gain          | 100/200 | 200      | V/V      |
|PGA gain         | 1.2/1.5/2/3|1.2    | V/V      |
|ADC sampling rate| Fixed   | 1024     | Hz       |
|ADC resolution   | Fixed   | 12       | bit (unsigned)|
|ADC ENOB         | Fixed   | 11       | bit      |
|FIR filter enable| Yes/No  | Yes      |          |
|FIR filter bandwidth| Depending on sampling rate | 80|Hz|

###PPG

The Photoplethysmogram (PPG) sensor measures blood-volume changes in the blood tissue. PPG is a plethysogram obtained using optics. A plethysmogram is volumetric measurement of an organ. In Simsense we use PPG to detect blood-volume change at microvascular level. This technique is non-invasive and it is obtained by illuminating light into the body and measuring the change in light absorption.

| **Parameter**| **Options**| **Value**|**Units**| **Notes**|
|--------------|------------|----------|---------|----------|
|Resistor for TIA gain setting| 50/100/200| 50   | KOhm(Ω)  |  |
|LED Pulse width|0 to 15µs (in theory)| 3 |µs|In practice only 2/3/4µs makes sense|
|LED Pulse period|0 to 255            |20 | µs           |   |
|LED Pulse count | 0 to 22 (in theory)| 1 to 12| |Will be optimized as trade-0ff SNR vs. power|
|LED current     | 10 to 250mA | _vary_ | mA | Due to ACC (Automatic current control)|
|ADC sampling rate| 0.125 to 8192Hz (in theory)| 50 +/- 5Hz| Hz/LEDs|Asynchronous clock, M0 interrupt handling will limit sample rate in practice|
|ADC resolution|Fixed|14| bit|   |
|ADC ENOB|Determined by LED pulse count and ADC oversampling/decimator factor|14 + 0.5 log <sub>2</sub>(LED pulse count) + 0.5 log <sub>2</sub>(ADC oversampling factor)| bit||
|Automatic LED current control enable| Yes/No | Yes               |||

###GSR

The Galvanic Skin Response (GSR) sensor measures conductucivity of skin. The skin conductivity changes with both changes in the underlying amount of sweat released onto the skin from the sweat glands, and the number of active sweat glands.

| **Parameter**   | **Options**| **Value** | **Units** | **Notes** |
|-----------------|------------|-----------|-----------|-----------|
|Measurement range|Fixed       |0.0002 to 20|µSiemens  |           |
|Measurement range|Fixed       |50k to 5G   |Ohm(Ω)    |           |
|Applied DC differential voltage|-0.57 to +0.57| 0.285 typ.| V| Will be controlled by automatic gain control|
|Transimpedance gain (tonic + phasic channels)|2/10/50|10 typ.|MOhm(Ω)|Will be controlled by automatic gain control|
|Additional gain phasic channel|Fixed|-15.5|V/V||
|Bandwidth tonic channel|Fixed|0 to 4.8|Hz||
|Bandwidth phasic channel|Fixed|0.48 to 4.8|Hz||

###Accelerometer

The accelerometer is an instrument which senses and measures tilt and motion.

| **Parameter**   | **Options**| **Value** | **Units** | **Notes** |
|-----------------|------------|-----------|-----------|-----------|
|ADC sampling rate|12.5/25/50/100/200/400| Approx. 100 | Hz| Asynchronous clock|
|ADC resolution   |Fixed       |12         | bit       |           |
|Measure Range    | +/-2, +/-4, +/-8| +/-8 |g          |           |
|Worst case sensitivity error|Fixed|+/-10|%|6-position rest calibration (against gravity) could compensate  sensitivity and offset errors if needed|
|Worst case offset|Fixed|+/-0.15 (X/Y), +/-0.25 (Z)|g|Same as above|

###Skin Temperature

The skin temperature sensor senses temperature of the skin enclosed by the sensor module.

| **Parameter**   | **Options**| **Value** | **Units** | **Notes** |
|-----------------|------------|-----------|-----------|-----------|
|Thermistor value|Fixed|100|kOhm||
|Thermistor value precision|Fixed|+/-1|%||
|Thermistor Beta|Fixed|4100|K||
|Thermistor Beta precision|Fixed|+/-1|%||
|Thermistor stabilization time|Fixed|Approx. 5|Minutes|To reach thermal equilibrium after putting band on skin.|
|Measurement range|Fixed|-40 to +85|<sup>o</sup>C||

###Bias

The bias electrode is not a sensor channel in its own right, but it is a reference electrode for the electrical measurements ECG, GSR and BioZ. Its purpose is to maintain the correct DC bias potential between the human body and the electronics. This bias potential is approximately 0.6V with respect to system ground potential. The bias electrode needs good contact to the skin to ensure a good signal quality for the above mentioned measurements.


![](/images/docs/sensor-module/sensor-module-documentation/simsense/Simsense-display01.png)
**Simsense: Sensor Module Concept**









