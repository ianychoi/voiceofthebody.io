---
title: "Design essentials"
---

# Design essentials

If you're part of the sensor module developer community, this is the right place. Unlike other wearable health devices, Simband is a modular reference platform for wearable health sensors. You can modify Simsense or build and integrate your own custom health sensors.

![](/images/docs/sensor-module/sensor-module-documentation/design-essentials/simband-angular-top-view3.png)

## Simband design philosophy

Since both hardware and software in digital health are advancing rapidly, Simband is designed to allow developers to focus on creating and integrating new sensor technologies—such as spectroscopy, electromagnetic, lab-on-a-chip and more—while Simband solves the other critical challenges of platform design, middleware, cloud connectivity, power and human-machine interface.

Simband is designed as an open platform. It includes open software, open hardware and even open mechanical design.

Simsense can theoretically be replaced by a store technician. We think this will help focus efforts and accelerate innovation.

![](/images/docs/sensor-module/sensor-module-documentation/design-essentials/simband-modularity-bottom.png)

## Constraints

### Wearability

Simband is designed for comfortable, continuous wear. The sensor module should follow ergonomic design practices, and use materials that are safe to have in contact with human skin. Materials should be breathable (allowing air circulation) yet durable. See the [mechanical overview][1] for a complete breakdown of the Simsense components and materials that we chose to ensure long-term comfort.

The current Simband design equipped with Simsense is designed for left-hand use only, due to sensor position and wrist anatomy.
{:.info}

### Sensor position and wrist anatomy

A sensor's relative location to an anatomical feature (e.g., ulnar artery or radial artery) will vary from person to person. There are several ways to address this:

* Solution 1: Use sensors that do not require exact anatomical matching. This is the best option, but some sensor types have stricter anatomical requirements to function properly.
* Solution 2: A different sensor strap size for each wrist size. This option will help reduce mismatch between the sensor module and different wrist sizes and anatomical positions, but may not be perfect.
* Solution 3: Implement array sensors. Place multiple sensors so that at least one matches the desired location, and pick one based on signal quality. This gives lot of freedom while designing your sensor module.

### Freedom of movement

Simband is not intrusive to wrist motion. It enables small wrist movements (several millimeters) and applies delicate pressure on the wrist.

### Activity and environment

**Activity reliability:** Simband is designed to survive day-to-day use in a non-aquatic athletic environment. 

**Water-resistant:** Simband is not designed to be water-resistant.

**Operating and storing temperature:** Ambient temperature.

[1]: /sensor-module/sensor-module-documentation/mechanical-overview.html#simsense-mechanical-parts "Simsense parts"
[2]: /sensor-module/sensor-module-documentation/simsense.html "Simsense"


