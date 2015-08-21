---
title: "Your first Simband algorithm"
---

#Your first Simband algorithm

The [**Vobio API**][18] is written in C, and a tutorial is forthcoming.<br /><br /> This tutorial requires a basic understanding of C++11 and some knowledge of [lambda functions][6]. We will also use `std::unique_ptr` and `std::vector`.
{:.info}

##Write a Heart Rate Variability (HRV) algorithm

###Concepts

Writing algorithms using the Vobio API is very intuitive. Previously, we talked about basic concepts for [understanding and working with Simband data][1] and how to [access this data][2]. Don't worry if you don't remember. This tutorial is designed to cover the required concepts and terms once again in brief.

The Vobio API describes data as a _stream_. [What is a stream?][3] A stream is a continuous sequence of time-coded numeric data. A sensor generating data (numbers) in time—or "time-coded numeric data"—produces a stream.

For example: `HeartBeat` is a stream representing single detected heartbeats, available from this list of [currently available streams][4].

###Goals
In this tutorial, we'll do the following:

* Extract the information from the `HeartBeat` stream.
* Process that information.
* Produce a new stream: `HeartRateVariability`.

Below is a visual interpretation of the `HeartBeat` stream:

![](/images/docs/simband/simband-documentation/algorithms-on-simband/writing-algorithms-using-simband-api/HB_Stream.png)
**Visual interpretation of HeartBeat stream**

Blue cells represent a `HeartBeat`, and white cells represent no `HeartBeat`, in time, as expressed by the increasing array index. We will use the API to tap into this stream and ask for the timestamps of where-there-is-a-heartbeat between the time "Now" and some valid time in the past.

As shown in the above diagram, we are requesting information from "Now = t<sub>1</sub>" to a valid time in the past "t<sub>0</sub>". The API will retrieve a list of `timestamps` where-there-is data and a total `count` of timestamps.

###Tutorial
Roll up your sleeves—it's time to dive into code and learn some cool stuff.

For our tutorial, we will create a `hrvalgorithm.h` file where we declare the `HRVAlgorithm`{:.param} class.

Since we want to get timestamps from the `HeartBeat` stream, crunch that information and write the new data into a new stream called `HeartRateVariability`, we will declare two stream IDs (`hb`{:.param} and `hrv`{:.param}) and associate each ID with its respective stream. We will also need [`Clock`][9] and [`Timer`][11] objects from the Vobio API to synchronize the streams and trigger callbacks. We will also require an `UpdateInterval`{:.param}, which will be used to start timer notification with a given interval.

Now lets define a function prototype that takes heart beats as input and calculates the HeartRateVariability. Let us call this function as `calculateHeartRateVariability`.

Stream, Clock and Timer types are defined in [`vobio.hpp`][10], a C++11 wrapper with convenience functions for using the C APIs declared in [`vobio.h`][7]. Its lightweight classes and functions take away some of the pain of dealing with C-style functions and with constructing/destructing objects.


~~~c
#include "vobio.hpp"

class HRVAlgorithm
{
public:
    void init();

private:
  bool calculateHeartRateVariability(const std::vector<double>& beats, float& result);

  vobio::stream hb;
  vobio::stream hrv;

  vobio::clock clock;
  vobio::timer timer;

};
~~~

Next, let's create a file called `hrvalgorithm.cpp`.

We will include `hrvalgorithm.h`{:.param} (the header file we just created).

So far, `hrvalgorithm.cpp` looks like this and let's start filling it step-by-step.

~~~c
#include "hrvalgorithm.h"

static const int UpdateInterval = 5;

void HRVAlgorithm::init()
{



}
~~~

Now, let's initialize the stream objects. We will use the constructor of [`vobio::stream`{:.param}][8] class to associate IDs with stream type.

~~~c
#include "hrvalgorithm.h"

static const int UpdateInterval = 5;

HRVAlgorithm::init()
{
    hb = vobio::stream(SIMBAND("heartBeat"));
    hrv = vobio::stream("com.my-adk-sample.myhrvstream");

}
~~~

Note: All Simband system streams are available [here](/semantics-of-simband/types-streams/stream-list.html)

Algorithms are time-driven. For a timer, you need a clock, and we define the clock based on the data we want to work on.

We want to work on the `HeartBeat` (`hb`{:.param}) stream, and this stream needs to be time-synchronized in this algorithms context. [`vobio::clock`{:.param}][9] is the class that wraps `vobio_clock_h`. We will create an object of that class and store it in the `clock`{:.param} declared in `hrvalgorithm.h`.

To receive periodic callbacks, we will use a timer. To do that, let's create an object of the class [`vobio::timer`][11] that is a wrapper around `vobio_timer_h`{:.param}.

The [`vobio::timer`{:.param}][11] constructor expects a pointer to an object of class [`vobio::clock`{:.param}][9] as a parameter and a callback with no parameters. We will create an object of [`vobio::timer`{:.param}][11] and store it in the `timer`{:.param} declared in `hrvalgorithm.h`.

In this example, as a callback we use C++11 [lambda][6].

~~~c
#include "hrvalgorithm.h"

static const int UpdateInterval = 5;

HRVAlgorithm::init()
{
    hb = vobio::stream(SIMBAND("heartBeat"));
    hrv = vobio::stream("com.my-adk-sample.myhrvstream");

    clock = vobio::clock(hb);

    timer = vobio::timer(clock, [&] {
        ...
        ...
    });
...
}

~~~

We will receive a callback when all the streams in the context have data equivalent to the timeout. For this example, we are working with only one stream.

First, we have to start the timer. We will call the function `start`{:.param} of the [`vobio::timer`{:.param}][11] class, which is a wrapper for  [`vobio_timer_start`][15]. It expects a timeout interval in milliseconds.

~~~c
#include "hrvalgorithm.h"

static const int UpdateInterval = 5;

HRVAlgorithm::init()
{
    hb = vobio::stream(SIMBAND("heartBeat"));
    hrv = vobio::stream("com.my-adk-sample.myhrvstream");

  clock = vobio::clock(hb);

  timer = vobio::timer(clock, [&] {
      ...
      ...
  });

  timer.start(UpdateInterval);
}
~~~

When we get the callback, all the code inside the [lambda][6] function will execute.

Since we now have the data available in the `hb`{:.param} stream, we should use the API [`vobio::get_samples()`{:.param}][21] to get the data & timestamps of where-there-is-a-heartbeat and use this information to calculate `HeartRateVariability`.

To get data from the stream, [`vobio::get_samples()`{:.param}][21] API expects the lower and upper bounds of the time period. The upper bound of the time period is basically "Now = t<sub>1</sub>" to some valid time in past "Now - `Seconds`".

To get the current time in the context's clock, we will call the function `now()`{:.param} of [`vobio::clock`{:.param}][9] class, which is a wrapper for  [`vobio_get_current_time()`][16].

~~~c
auto now = clock->now();
~~~

[`vobio::get_samples()`{:.param}][21] API on success will return a vector containing samples of type [`vobio_sample_s`][20], which holds data and timestamp variables. [`vobio_sample_s`][20] structure is defined in [`vobio.h`][17].

We will use a `vector`{:.param} of type `double`{:.param} to save the retrieved timestamps, as it is advisable to free the list.

The following code snippet demonstrates as explained.

~~~c
      timer = vobio::timer(clock, [&] {
        ...
        auto now = clock.now();
        std::vector<vobio_sample_s> samples = vobio::get_samples(hb, now - UpdateInterval, now);

        std::vector<double> beats;
        for (auto i = 0; i < samples.size(); ++i)
            beats.push_back(samples[i].timestamp);

        float result(0);
        if (calculateHeartRateVariability(beats, result)) {
            vobio::send(hrv, now, result);
        }
        ...
    });

~~~

Now, since we have the timestamps in our `beats`{:.param} vector, it's time to crunch the data. To do so, we will create a structure called `result`{:.param} declared in `HeartRateVariability.h` which will hold the calculated data.

We will pass this structure along with the timestamps in beats and the count to `HeartRateVariability::Calculate`{:.param}. On success, the passed structure will hold the result.

We will use [`vobio_send()`{:.param}][17] API to send the result to our o/p stream: `hrv`{:.param}.

Below is the complete code for `hrvalgorithm.cpp`.

~~~c
#include "hrvalgorithm.h"

static const int UpdateInterval = 5;

void HRVAlgorithm::init()
{
    hb = vobio::stream(SIMBAND("heartBeat"));
    hrv = vobio::stream("com.my-adk-sample.myhrvstream");

    clock = vobio::clock(hb);

    timer = vobio::timer(clock, [&] {
        auto now = clock.now();


        std::vector<vobio_sample_s> samples = vobio::get_samples(hb, now - UpdateInterval, now);

        std::vector<double> beats;
        for (auto i = 0; i < samples.size(); ++i)
            beats.push_back(samples[i].timestamp);

        float result(0);
        if (calculateHeartRateVariability(beats, result)) {
            vobio::send(hrv, now, result);
        }
    });

    timer.start(UpdateInterval);
}

~~~

Now, lets add the function that holds the computation of HRV from the obtained beats.

~~~c

bool HRVAlgorithm::calculateHeartRateVariability(const std::vector<double>& beats, float& result)
{
    result = 0;
    return true;
}

~~~

Finally, the last step is to add the main function. Here, we will call the `vobio_main` function by passing a function

~~~c

int main(int argc, char** argv) {
    HRVAlgorithm algo;

    return vobio_main(argc, argv, [] (void* userData) {
        HRVAlgorithm* algo = (HRVAlgorithm*)userData;
        algo->init();
    } , &algo);
}

~~~


[1]: /simband/simband-documentation/semantics-of-simband/index.html "Semantics of Simband data"
[2]: /simband/simband-documentation/semantics-of-simband/accessing-data-from-stream.html "Accessing data"
[3]: /simband/simband-documentation/semantics-of-simband/index.html#what-is-a-stream "What is a stream?"
[4]: /simband/simband-documentation/semantics-of-simband/types-streams/stream-list.html "Examples of streams"
[5]: /simband/simband-documentation/semantics-of-simband/accessing-data-from-stream.html#circular-buffers "Buffers"
[6]: http://www.cprogramming.com/c++11/c++11-lambda-closures.html "C++ Lambda Function"
[7]: /simband-api/vobio_8h_source.html "vobio.h"
[8]: /simband-api/classvobio_1_1stream.html "vobio::stream"
[9]: /simband-api/classvobio_1_1clock.html "vobio::clock Class Reference"
[10]: /simband-api/vobio_8hpp_source.html "vobio.hpp"
[11]: /simband-api/classvobio_1_1timer.html "vobio::timer Class Reference"
[12]: /simband-api/vobio_8h.html#af99c943deb2ccc1e77394c6d2753c849 "vobio_get_samples()"
[13]: /simband-api/vobio_8h.html#ae1119b9e4e6f0117339c6ad717462a5a "vobio_get_timestamps()"
[15]: /simband-api/vobio_8h.html#a191c3841d16026b0e82610184994be76 "vobio_timer_start()"
[16]: /simband-api/vobio_8h.html#adbde3180bff3991b82fbf9a7b4daa173 "vobio_get_current_time()"
[17]: /simband-api/vobio_8h.html#adb2c7fbe8b8e4ba9fc9db2c7059c3ac4 "vobio_send()"
[18]: /simband/simband-documentation/simband-api.html "Vobio API"
[19]: /simband-api/simband-io_8h.html#a0195ea464ea5907e58b31c50d408736c "vobio_circular_buffer_sample_get"
[20]: /simband-api/structvobio__sample__s.html "vobio_sample_s"
[21]: /simband-api/vobio_8hpp.html "vobio::get_samples"
