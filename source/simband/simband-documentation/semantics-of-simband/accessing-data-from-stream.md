---
title: "Accessing data from a stream"
---

# Accessing data from a stream

Since data is the main ingredient in Simband, and streams are the main flavor of that data, the streams API is a single point of producing or consuming data in Simband.

The streams API is used by the Simband applications, the Simsense driver, the validation tools and any installable algorithm.
This API is available in the file [`vobio.h`][1], and is made to be fully IPC. The IO API is divided into the following categories:

## System
System APIs will allow developers to interact with Simband runtime, for eg registering their algorithms in the system, run them, stop them.

System-related APIs:

 - `vobio_initialize()`
 - `vobio_is_active()`
 - `vobio_run()`
 - `vobio_stop()`
 - `vobio_main()`

## Data access
Data access APIs will enable algorithms to access or produce data into Simband.
The function `vobio_send()` is the main function to produce data into Simband.
`vobio_get_samples()` and `vobio_get_timestamps()` allow reading existing data in Simband based on a time period. `vobio_get_samples_to()` and `vobio_get_samples_from()` are more powerful APIs where developers can define a time to access or produce data from specific streams.

## Pack receiver
The function `vobio_receiver_create()` is the most basic way to handle Simband streams. You receive a callback with a data array when another client has produced data.
Though this is a simple API, using it effectively in algorithms requires a basic understanding of how the original streams are going to send their data.

## Clock
Clock allows accessing the data using a data-driven clock, or time-gate. Unlike the regular wall-clock, a data-driven clock only "ticks" when data is available in all the streams that were used to create that clock.

Clock-related APIs:

- `vobio_clock_create()`
- `vobio_clock_destroy()`
- `vobio_clock_add_stream()`
- `vobio_clock_remove_stream()`
- `vobio_clock_set_gap_reset_threshold()`
- `vobio_clock_create_receiver()`
- `vobio_clock_destroy_receiver()`

## Buffers
When using large amounts of data for live analysis, a buffer enables an efficient way of continuously reading that data. Use of buffer is effective and reuses the memory more efficiently.

Some of the buffer APIs:

- `vobio_buffer_create()`
- `vobio_buffer_sample_get()`
- `vobio_buffer_update_to()`

## Discovery and Metadata
These APIs allow accessing the stream registry, providing information about the stream's metadata. This allows an algorithm developer to discover which streams are actually available on the system, and use that information to plug into the right streams. 

Some discovery and metadata APIs:

- `vobio_stream_get_all()`
- `vobio_stream_get_all_by_type()`
- `vobio_stream_type_get()`

[1]: /simband/simband-documentation/simband-api.html "Simband API"
