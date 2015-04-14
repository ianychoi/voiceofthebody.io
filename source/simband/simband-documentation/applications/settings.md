---
title: "Simband settings"
---

# Simband Settings
While Simband comes with the usual device settings such as WiFi, display and motion(gesture), Simband Settings enables calibration of some internal device settings.

The following settings are available under this category:

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/simbandSettings.png)
**Simband Settings**
</div>

## Register to SAMI
All the data that Simband generates can be visualized and extracted from SAMI. Visit [go.simband.io](http://go.simband.io) with Google Chrome on your computer to pair your Simband with SAMI and get access to your data.

We recommend that all developers **pair Simband with SAMI**, or you won't be able to extract any data!
{:.info}

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/samiRegistration.png)
**SAMI Registration**
</div>

## Version
This displays the Simband software version.

## Sensor Calibration
We know that every skin tone reflects light at a different intensity, so we came up with a dynamic skin modeling approach. In sensor calibration we calibrate PPG light intensity based on the user's skin tone and reflection levels. The user needs to wear the band and tap on `calibrate`. The brightness of the PPG LEDs will be calibrated based on the user that is wearing the band, and each LED's forward drive current will be displayed for information purposes.

<div  class="photo-grid" style="max-width: 512px;">
 ![](/images/docs/simband/simband-documentation/applications/sensorCal.png)
**Sensor Calibration**
</div>

## Advanced
If you're connected to WiFi, you will see a dialog referring to a URL. Point your browser to that URL. This is the same configuration page the user will encounter when setting up Simband at [go.simband.io](http://go.simband.io). The web page will expose some hidden guts of Simband. This is sub-classified into Basic Configuration and Advanced Configuration.

### Basic Configuration
Basic configuration contains basic user information:


![](/images/docs/simband/simband-documentation/applications/basicConfig.png)
**Basic Configuration**


### Advanced Configuration
This option is for the geeks. This section contains basic device information like device ID, token and other stuff related to SAMI.

![](/images/docs/simband/simband-documentation/applications/advancedConfig.png)
**Advanced Configuration**

It is **not** recommended that you change the settings here unless you're absolutely confident about what you intend to happen.
{:.warning}

It also contains some hidden Simband options that are configurable. There are options to enable some experimental UI features, enable/disable automatic upgrades and more. Advanced Configuration also allows you to switch Simband to a simulation mode where the data is generated from a sine wave rather than from real sensors.

## Purge Data

Simband automatically uploads data to SAMI and we are currently implementing a system to automatically remove it from the device. For the time being, you can manually delete data with the Purge Data function. 

Simband has 4 GB of local storage for data. This should be more than sufficient for days' worth of use. But if in some instance the local disk gets full, Purge Data can wipe local data to let Simband collect new data.

At 70% disk capacity, a Simband user will be notified with a warning pop-up. After 80% disk capacity, Simband will stop storing and displaying new data. To make room for more data, either connect the device to WiFi to upload the data and empty the disk, or use Purge Data.