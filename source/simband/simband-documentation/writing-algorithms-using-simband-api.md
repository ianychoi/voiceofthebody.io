---
title: "Your first Simband algorithm"
---

#Your first Simband algorithm

The [**Simband API**][18] is written in C, and a tutorial in C is forthcoming.<br /><br /> This tutorial requires a basic understanding of C++11 and some knowledge of [lambda functions][6]. We will also use `std::unique_ptr` and `std::vector`. 
{:.info}

##Write a Heart Rate Variability (HRV) algorithm

###Concepts

Writing algorithms using the Simband API is very intuitive. Previously, we talked about basic concepts for [understanding and working with Simband data][1] and how to [access this data][2]. Don't worry if you don't remember. This tutorial is designed to cover the required concepts and terms once again in brief. 

The Simband API describes data as a _stream_. [What is a stream?][3] A stream is a continuous sequence of time-coded numeric data. A sensor generating data (numbers) in time—or "time-coded numeric data"—produces a stream.

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

Three primary APIs are used to read data from existing streams: 

[`simband_io_get_samples()`][12] gets the numerical "data" from the stream.

[`simband_io_get_timestamps()`][13] gets the "timestamps" of the occurred-events in the stream.

[`simband_io_circular_buffer_sample_get()`][19] is out of the scope of this tutorial, but we encourage curious souls to read about [Circular Buffers][5].

For this tutorial, since we are *only* interested in "occurrence of the event", we will use [`simband_io_get_timestamps()`][13] to extract the information from the `HeartBeat` stream.

###Tutorial
Roll up your sleeves—it's time to dive into code and learn some cool stuff.

For our tutorial, we will create a `hrvalgorithm.h` file where we declare the `HRVAlgorithm`{:.param} class. Private members are two `std::unique_ptr`{:.param} of type [`simband::io_context`{:.param}][9] and [`simband::timer`{:.param}][11]. 

These types are defined in [`simband-io.hpp`][10], a C++11 wrapper with convenience functions for using the C APIs in declared in [`simband-io.h`][7]. Its lightweight classes and functions take away some of the pain of dealing with C-style functions and with constructing/destructing objects.

~~~c
#include "simband-io.hpp"

namespace algo {
class HRVAlgorithm
{
public:
    HRVAlgorithm();

private:
    std::unique_ptr<simband::io_context> m_ioContext;
    std::unique_ptr<simband::timer> m_timer;
};
}
~~~

Next, let's create a file called `hrvalgorithm.cpp` and start filling it step-by-step.

We will include `hrvalgorithm.h`{:.param} (the header file we just created) and `HeartRateVariability.h`{:.param}, which contains the class `HeartRateVariability`{:.param}. This is the class that will take the collected `HeartBeats` and process them.

We will define `Seconds`{:.param}, which will be used as valid time in the past; and we will define `UpdateInterval`{:.param}, which will be used to start timer notification with a given interval. 

So far, `hrvalgorithm.h` looks like this:

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{



}
}
~~~

Since we want to get timestamps from the `HeartBeat` stream, crunch that information and write the new data into a new stream called `HeartRateVariability`, we will declare two stream IDs (`hb`{:.param} and `hrv`{:.param}) and associate each ID with its respective stream. We will use [`simband_io_stream_get_default_by_type()`{:.param}][8] to associate IDs with stream type.

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{
...
    simband_io_stream_id_h hb, hrv;
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_BEAT, &hb);
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_RATE_VARIABILITY, &hrv);
...

}
}
~~~

Algorithms are time-driven. For a timer, you need a clock, and we define the clock based on the data we want to work on. This is what the context represents.

We want to work on the `HeartBeat` (`hb`{:.param}) stream, and the stream needs to be time-synchronized in this algorithms context. [`simband::io_context`{:.param}][9] is the class that wraps `simband_io_context_h`. We will create an object of that class and store it in the `unique_ptr m_ioContext`{:.param} declared in `hrvalgorithm.h`.

We will also assign the stored pointer that is pointing to the newly assigned object [`simband::io_context`{:.param}][9] to an auto type variable `io`{:.param}.

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{
    simband_io_stream_id_h hb, hrv;
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_BEAT, &hb);
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_RATE_VARIABILITY, &hrv);
...
    m_ioContext.reset(new simband::io_context({ hb }));
    auto io = m_ioContext.get();
...   

}
}
~~~

To receive periodic callbacks, we will use a timer. To do that, let's create an object of the class [`simband::timer`][11] that is a wrapper around `simband_io_timer_h`{:.param}.

The [`simband::timer`{:.param}][11] constructor expects a pointer to an object of class [`simband::io_context`{:.param}][9] as a parameter and a callback with no parameters. We will create an object of [`simband::timer`{:.param}][11] and store it in the `unique_ptr m_timer`{:.param} declared in `hrvalgorithm.h`.

In this example, as a callback we use C++11 [lambda][7].

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{
    simband_io_stream_id_h hb, hrv;
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_BEAT, &hb);
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_RATE_VARIABILITY, &hrv);

    m_ioContext.reset(new simband::io_context({ hb }));
    auto io = m_ioContext.get();
...   
    m_timer.reset(new simband::timer(*io, [this, hb, hrv, io] {
        ...
        ...
    }));
...
}
}

~~~

We will receive a callback when all the streams in the context have data equivalent to the timeout. 

First, we have to start the timer. We will call the function `start`{:.param} of the [`simband::timer`{:.param}][11] class, which is a wrapper for  [`simband_io_timer_start`][15]. It expects a timeout interval in milliseconds.

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{
    simband_io_stream_id_h hb, hrv;
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_BEAT, &hb);
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_RATE_VARIABILITY, &hrv);

    m_ioContext.reset(new simband::io_context({ hb }));
    auto io = m_ioContext.get();

    m_timer.reset(new simband::timer(*io, [this, hb, hrv, io] {
        ...
        ...
    }));
...
    m_timer->start(UpdateInterval * 1000);
...    
}
}
~~~

When we get the callback, all the code inside the [lambda][7] function will execute.

Since we now have the data available in the `hb`{:.param} stream, we should use the API [`simband_io_get_timestamps()`{:.param}][13] to get the timestamps of where-there-is-a-heartbeat and send this data to calculate `HeartRateVariability`.

To get data from the stream, [`simband_io_get_timestamps()`{:.param}][13] API expects the lower and upper bounds of the time period. The upper bound of the time period is basically "Now = t<sub>1</sub>" to some valid time in past "Now - `Seconds`".

To get the current time in the context's clock, we will call the function `now()`{:.param} of [`simband::io_context`{:.param}][9] class, which is a wrapper for  [`simband_io_get_current_time()`][16].

~~~c
auto now = io->now();
~~~

[`simband_io_get_timestamps()`{:.param}][13] API on success will hold `timestamps`, which are of type `double**`; and will hold the size of the timestamps list as `count`, which are of type `int*`. 

We will use a `vector`{:.param} of type `double`{:.param} to save the retrieved timestamps, as it is advisable to free the list.

The following code snippet demonstrates as explained. 

~~~c
    m_timer.reset(new simband::timer(*io, [this, hb, hrv, io] {
        ...
        auto now = io->now();
        std::vector<double> beats;
        double* timestamps;
        int count;
        if (simband_io_get_timestamps(*io, hb, now - Seconds, now, &timestamps, &count))
            return;
        for (int i = 0; i < count; ++i)
            beats.push_back(timestamps[i]);
        delete timestamps;
        ...
    }));

~~~

Now, since we have the timestamps in our `beats`{:.param} vector, it's time to crunch the data. To do so, we will create a structure called `result`{:.param} declared in `HeartRateVariability.h` which will hold the calculated data.

We will pass this structure along with the timestamps in beats and the count to `HeartRateVariability::Calculate`{:.param}. On success, the passed structure will hold the result. 

We will use [`simband_io_send()`{:.param}][17] API to send the result to our o/p stream: `hrv`{:.param}.

Below is the complete code for `hrvalgorithm.cpp`.

~~~c
#include "hrvalgorithm.h"
#include "HeartRateVariability/HeartRateVariability.h"
#include <logging.h>

static const int Seconds = algo::HeartRateVariability::RequiredTimePeriodSec;
static const int UpdateInterval = 5;

namespace algo {
HRVAlgorithm::HRVAlgorithm()
{
    simband_io_stream_id_h hb, hrv;
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_BEAT, &hb);
    simband_io_stream_get_default_by_type(SIMBAND_STREAM_TYPE_HEART_RATE_VARIABILITY, &hrv);
    m_ioContext.reset(new simband::io_context({ hb }));

    auto io = m_ioContext.get();
    m_timer.reset(new simband::timer(*io, [this, hb, hrv, io] {
        auto now = io->now();
        std::vector<double> beats;
        double* timestamps;
        int count;
        if (simband_io_get_timestamps(*io, hb, now - Seconds, now, &timestamps, &count))
            return;
        for (int i = 0; i < count; ++i)
            beats.push_back(timestamps[i]);
        delete timestamps;

        HeartRateVariability::Result result;
        if (HeartRateVariability::Calculate(beats.data(), count, result))
        {
            float value = 100 * result.m_SDNN;
            if (value < 100)
                simband_io_send(*io, hrv, now, &value, 1);
        }
    }));

    m_timer->start(UpdateInterval * 1000);
}

}

~~~




[1]: /simband/simband-documentation/semantics-of-simband/index.html "Semantics of Simband data"
[2]: /simband/simband-documentation/semantics-of-simband/accessing-data-from-stream.html "Accessing data"
[3]: /simband/simband-documentation/semantics-of-simband/index.html#what-is-a-stream "What is a stream?"
[4]: /simband/simband-documentation/semantics-of-simband/types-streams.html "Examples of streams"
[5]: /simband/simband-documentation/semantics-of-simband/accessing-data-from-stream.html#circular-buffers "Circular buffers"
[6]: http://www.cprogramming.com/c++11/c++11-lambda-closures.html "C++ Lambda Function"
[7]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html "simband-io.hpp"
[8]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#ae5cddbc25e3fbd5fb0058834fe4389c4 "simband_io_stream_get_default_by_type()"
[9]: http://www.voiceofthebody.io/simband-api/classsimband_1_1io__context.html "simband::io_context Class Reference"
[10]: http://www.voiceofthebody.io/simband-api/simband-io_8hpp.html "simband-io.hpp"
[11]: http://www.voiceofthebody.io/simband-api/classsimband_1_1timer.html "simband::timer Class Reference"
[12]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#a8490f8d4416de9c40f78e19700e41dcb "simband_io_get_samples()"
[13]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#a8db864ae96e6b120554f208752b151ac "simband_io_get_timestamps()"
[14]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#aae7d57b74f3221acb3370276bf7de6b5 "simband_io_context_open()"
[15]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#afdc348dd0cf465da26fc2724798e26e3 "simband_io_timer_start()"
[16]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#a12d3b49c5ef1ac68ae20c2af60dcce51 "simband_io_get_current_time()"
[17]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#a3cded131b8f68e7331ade44fc7f6d00c "simband_io_send()"
[18]: /simband/simband-documentation/simband-api.html "Simband API"
[19]: http://www.voiceofthebody.io/simband-api/simband-io_8h.html#a0195ea464ea5907e58b31c50d408736c "simband_io_circular_buffer_sample_get"
