---
title: "Accessing data from a stream"
---

# Accessing data from a stream

Since data is the main ingredient in Simband, and streams are the main flavor of that data, the streams API is a single point of producing or consuming data in Simband.

The streams API is used by the Simband applications, the Simsense driver, the validation tools and any installable algorithm.
This API is available in the file [`simband-io.h`][1], and is made to be fully IPC. The IO API is divided into the following categories:

## General data access
The function `simband_io_send()` is the main function to produce data into Simband.
`simband_io_get_samples()` and `simband_io_get_timestamps()` allow reading existing data in Simband based on a time period.

## Pack receiver
The function `simband_io_set_receive_cb()` is the most basic way to handle Simband streams. You receive a callback with a data array when another client has produced data.
Though this is a simple API, using it effectively in algorithms requires a basic understanding of how the original streams are going to send their data.

## Timers
Timers allow accessing the data using a data-driven clock, or time-gate. Unlike the regular wall-clock, a data-driven clock only "ticks" when data is available in all the streams that were used to create that clock. 
Timer-related APIs:

- `simband_io_timer_create()`
- `simband_io_timer_destroy()`
- `simband_io_timer_start()`
- `simband_io_timer_stop()`
- `simband_io_get_current_time()`

## Circular buffers
When using large amounts of data for live analysis, a circular buffer enables an efficient way of continuously reading that data. Use of circular buffer is effective and reuses the memory more efficiently.
Some of the circular buffer APIs:

- `simband_io_circular_buffer_create()`
- `simband_io_circular_buffer_sample_get()`
- `simband_io_circular_buffer_update_to()`

## Discovery and metadata
These APIs allow accessing the stream registry, providing information about the stream's metadata. This allows an algorithm or app developer to discover which streams are actually available on the system, and use that information to plug into the right streams. Some discovery and metadata APIs:

- `simband_io_stream_get_all()`
- `simband_io_stream_get_all_by_type()`
- `simband_io_stream_get_default_by_type()`

[1]: /simband/simband-documentation/simband-api.html "Simband API"