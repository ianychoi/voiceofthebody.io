---
title: "Documentation"
nav:
  - 'simband-sami'
  - 'semantics-of-simband'
  - 'writing-algorithms-using-simband-api'
  - 'simband-api'
  - 'simband-source-code'
---

# Documentation

Simband is our concept of what a smart health device should be. 

An open developer platform, Simband consists of a watch unit running [Tizen][1] and a wristband connector that holds a custom sensor module.

![](/images/docs/simband/simband-documentation/simband-angular-top-view.png)

Because Simband is modular, you can easily connect sensor modules with new configurations. Samsung provides a reference implementation called [Simsense][2] that supports multiple sensors, each generating a [unique data stream][3]. 

You can develop new algorithms to read and analyze this data in real-time, or access historical data through our data exchange platform [SAMI][4]. While the sensor module collects biophysical data, the Simband watch unit has several important roles: 

- It connects automatically with SAMI, to make the sensor data available to cloud intelligence. 
- It runs installable algorithms that analyze the data and give immediate insights. 
- Its touch display allows control, feedback and monitoring by the user. 
![](/images/docs/simband/simband-documentation/simband-angular-bottom-view.png)

Simband acts as a window into its wearer. Devices based on the Simband platform can continuously monitor your health and physical activity, as well as educate, coach and provide helpful feedback on your wellness. For the first time, you can ask specific health questions and get clear, insightful answers directly from the source: your body.

On these pages, we provide the tools you need to create hardware and software on the Simband platform. We always welcome [discussion][5] on how to make Simband better and more useful for people, and we're here to work with you to accelerate innovation in digital health.

![](/images/docs/simband/simband-documentation/simband-bottom-view.png)

## What this documentation covers

- The [Simband API][8], supported by [doxygen][6].
- An introduction to [how data flows through Simband][7], from [sensor and algorithm sources][9] to [accessing and analyzing streams][10].
- Tutorials on writing some [basic Simband algorithms][11].
- Information on [ordering a hardware development kit][12].
- [Frequently Asked Questions][13] about using and developing for Simband.

[1]: https://www.tizen.org/ "Tizen"
[2]: /sensor-module/sensor-module-documentation/simsense.html "Simsense"
[3]: /simband/simband-documentation/semantics-of-simband/ "Semantics of Simband"
[4]: http://developer.samsungsami.io/ "SAMI"
[5]: /community/ "Community"
[6]: http://www.doxygen.org "Doxygen"
[7]: /simband/simband-documentation/semantics-of-simband/#the-flow-of-data "Flow of data"
[8]: /simband/simband-documentation/simband-api.html "Simband API"
[9]: /simband/simband-documentation/semantics-of-simband/types-streams.html " Types of streams"
[10]: /simband/simband-documentation/semantics-of-simband/accessing-data-from-stream.html "Accessing data"
[11]: /simband/simband-documentation/writing-algorithms-using-simband-api.html "Your first Simband algorithm"
[12]: /simband/development-kits.html "Hardware development kit"
[13]: /simband/faq.html "FAQ"