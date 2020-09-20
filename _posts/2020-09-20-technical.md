---
layout: post
title: Technical Blog Post - Designing a Software Filter
imagepath: resources/blog/2020-09-20-technical
shorttitle: 2020 - Technical
---

## Table of Contents

1. Designing a Software Filter in C++
   1. What is a software filter?
   2. What should a software filter do?
   3. Alright, let's get cracking!
      1. SMA (Simple Moving Average) Filter
      2. Setup
      3. Adding a sample
      4. Getting the result
      5. Shutting down the filter
   4. Usage
   5. Optimization
2. Other Filter Types
3. Conclusion

## Designing a Software Filter in C++

This little guide is meant to teach you the following concepts:

- C++ syntax
- Software filtering techniques
- Sensor interfacing

### What is a software filter?

A software filter is a program or a subset of a program meant to sanitize data input, transforming it into something that is more useful for the end user.

We see software filters all over the place, from image processing to machine learning and down into smoothing out sensor data.

### What should a software filter do?

In our application, we will be designing a software filter for the last task: smoothing out data from the voltage and current sensors on our PV Curve Tracer.

That means an ideal software filter will have the following qualities:

- noise from the input data should be minimized and removed as much as possible.
- the time difference between our input and output streams should be near instantaneous (the fewer cycles it takes to get smoothed output the better).
- the filter should attempt to reflect the true value of our input data.

### Alright, let's get cracking!

#### [SMA (Simple Moving Average) Filter](https://hackaday.com/2019/09/06/sensor-filters-for-coders/)

In this tutorial I'll show you a C++ implementation of a [SMA](https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average) filter class. This is a very simple and intuitive filter: essentially we're taking the average of the last X samples and spitting that out. This filter is decent at removing noise from the dataset, especially cyclic variations in the data, as well as identifying trends.

There are drawbacks with this filter, though, including:

- the true value of the data lags behind the most recent sample by half the sample width,
- fluctuations can be caused by data points dropping into or out of the data set, and
- how many samples are included in your average adversely affects the noisiness and accuracy of your output.

Starting off, we want a couple methods for our filter class:

- a setup method
- a method to add a sample
- a method to retrieve a filtered sample

Simple, right?
Here's the bare skeleton of our class and we'll begin filling it in.

```c++
class SMAFilter {
   protected:
      // a buffer that will hold the history of samples added to it
      double * _dataBuffer;
      // the maximum number of samples that our filter can hold
      int _maxSamples;
      // the number of samples we currently have (saturates at _maxSamples)
      int _numSamples;
      // the current index of the buffer we want to add a sample at
      int _idx;
    public:
      // our setup method
      SMAFilter(int maxSamples);
      // method to add a sample of type double
      void addSample(double sample);
      // method to retrieve a filtered sample
      double getResult();
      // shutdown method
      void shutdown();
}
```

#### Setup

In our setup method, we're going to initialize some variables, including setting
the size of our buffer.

```c++
SMAFilter(int maxSamples) {
     // setup the data buffer
     _maxSamples = maxSamples + 1;
     _dataBuffer = new (std::nothrow) double [_maxSamples];
     _idx = 0;
     _numSamples = 0;
}
```

You can see that we set the data buffer to a variable array allocated on the heap; we will need to deallocate that when we shut down the SMAFilter. Notice that we need to include the header `#include <new>` to not throw an exception if we are unable to allocate memory to the data buffer.

#### Adding a sample

Now in our `addSample` method, we want to add a value to our buffer:

```c++
// method to add a sample of type double
void addSample(double sample) {
    // check for exception
    if (_dataBuffer == nullptr) { return; }

    _dataBuffer[_idx] = sample;
    _idx = (_idx + 1) % _maxSamples;

    // saturate counter at max samples
    if ((_numSamples + 1) < _maxSamples) {
        _numSamples ++;
    }
}
```

We see here a couple of things:

- we check that if we were unable to allocate memory to the data buffer, we'll just early exit.
- then we'll set the sample at a spot in the buffer, and set the index to the next available spot in the buffer.
  - notice the line `_idx = (_idx + 1) % _maxSamples;`. This code increments our index until it exceeds \_maxSamples and wraps back around to 0. This indicates that the buffer is a circular buffer. This saves us space and doesn't require us to check if the array is full or to allocate more memory.
- finally, the last couple of lines is a saturating counter. This tells us in the `getResult()` function how many elements are in the data buffer to divide our sum by to get the average.

#### Getting the result

```c++
// method to retrieve a filtered sample
double getResult() {
    // check for exception
    if (_dataBuffer == nullptr) { return 0.0; }

    double sum = 0.0;
    for (int i = (_idx - _numSamples + _maxSamples) % _maxSamples; i != _idx; i = (i + 1) % _maxSamples) {
        sum += _dataBuffer[i];
    }
    return sum / _numSamples;
}
```

Here as well, we perform the exception checking to make sure we can access valid values in our buffer. If our buffer is unallocated, we get a null pointer and then return a default 0.0 value.

We then take every filled value in the buffer and sum it up, then divide it by the number of samples to get the average. There's a little bit of pointer math here to follow to get every filled value. First we start at the index of the stalest value `(_idx - _numSamples + _maxSamples) % _maxSamples`. This code means that we're starting at the stalest value `(_idx - _numSamples)`, plus the upper bound of the buffer `+ _maxSamples` to keep the index positive, and then modulo by the upper bound `% _maxSamples` to truncate any overflow.

#### Shutting down the filter

Finally, here's a one line for deallocating the data buffer from setup.

```c++
void shutdown() { delete[] _dataBuffer; }
```

### Usage

In order to use this filter, we can allocate it on the stack like so:

```c++
printf("Hello World\n");
// setup
SMAFilter filter(5); // 5 sample buffer
// add 20 samples, increasing linearly by 10, and then some noisy 100s every 5 cycles.
for (int i = 0; i < 20; i++) {
   if (i%5 == 0) { filter.addSample(100); }
   else { filter.addSample(i*10.0); }

   // read the filter output at every point
   printf("%i:\t%f\n", i, filter.getResult());
}
// shutdown
filter.shutdown();
```

The whole code is provided here:

```c++
#include <stdio.h>
#include <new>

class SMAFilter {
    protected:
        // a buffer that will hold the history of samples added to it
        double * _dataBuffer;
        // the maximum number of samples that our filter can hold
        int _maxSamples;
        // the number of samples we currently have (saturates at _maxSamples)
        int _numSamples;
        // the current index of the buffer we want to add a sample at
        int _idx;
    public:
        // our setup method
        SMAFilter(int maxSamples) {
             // setup the data buffer
             _maxSamples = maxSamples + 1;
             _dataBuffer = new (std::nothrow) double [_maxSamples];
             _idx = 0;
             _numSamples = 0;
        }

        // method to add a sample of type double
        void addSample(double sample) {
            // check for exception
            if (_dataBuffer == nullptr) { return; }

            _dataBuffer[_idx] = sample;
            _idx = (_idx + 1) % _maxSamples;

            // saturate counter at max samples
            if ((_numSamples + 1) < _maxSamples) {
                _numSamples ++;
            }
        }

        // method to retrieve a filtered sample
        double getResult() {
            // check for exception
            if (_dataBuffer == nullptr) { return 0.0; }

            double sum = 0.0;
            for (int i = (_idx - _numSamples + _maxSamples) % _maxSamples; i != _idx; i = (i + 1) % _maxSamples
            ) {
                sum += _dataBuffer[i];
            }
            return sum / _numSamples;
        }

        // shutdown method
        void shutdown() { delete[] _dataBuffer; }
};


int main()
{
    printf("Hello World\n");
    // setup
    SMAFilter filter(5); // 5 sample buffer
    // add 20 samples, increasing linearly by 10, and then some noisy 100s every 5 cycles.
    for (int i = 0; i < 20; i++) {
       if (i%5 == 0) { filter.addSample(100); }
       else { filter.addSample(i*10.0); }

       // read the filter output at every point
       printf("%i:\t%f\n", i, filter.getResult());
    }
    // shutdown
    filter.shutdown();

    return 0;
}
```

I highly recommend popping it into an online [compiler](https://www.onlinegdb.com/online_c_compiler) and seeing the output and checking it out for yourself.

### Optimization

Alright, some of you readers may have realized that there's probably a better way to calculate the average of the data buffer. This way we don't need to loop all of the elements every time to get the sum.

Instead, what we can do is maintain the previous sum and the previous number of elements, and use that to get our new average.

Our new `addSample()` and `getResult()` should look like this:

```c++
// method to add a sample of type double
void addSample(double sample) {
    // check for exception
    if (_dataBuffer == nullptr) { return; }

    // saturate counter at max samples
    if ((_numSamples + 1) <= _maxSamples) {
        _numSamples ++;
        _sum += sample;
    } else {
        // add the new value but remove the value at the
        // current index we're overwriting
        _sum += sample - _dataBuffer[_idx];
    }

    _dataBuffer[_idx] = sample;
    _idx = (_idx + 1) % _maxSamples;
}

// method to retrieve a filtered sample
double getResult() {
    // check for exception
    if (_dataBuffer == nullptr) { return 0.0; }
    return _sum / _numSamples;
}
```

As you can see, `getResult()` is reduced to a simple sum / number of valid samples in the window. We've added some code to `addSample()`, which is essentially getting the cumulative sum over the window. We just add the sample to the sum if we haven't overflowed, and if we do overflow, then we'll add the sample but remove the sum of the next value that'll be overwritten.

The full code for this optimization is here:

```c++
#include <stdio.h>
#include <new>

class SMAFilter {
    protected:
        // a buffer that will hold the history of samples added to it
        double * _dataBuffer;
        // the maximum number of samples that our filter can hold
        int _maxSamples;
        // the number of samples we currently have (saturates at _maxSamples)
        int _numSamples;
        // the current index of the buffer we want to add a sample at
        int _idx;
        // sum over all elements in the window
        double _sum;
    public:
        // our setup method
        SMAFilter(int maxSamples) {
             // setup the data buffer
             _maxSamples = maxSamples;
             _dataBuffer = new (std::nothrow) double [_maxSamples];
             _idx = 0;
             _numSamples = 0;
             _sum = 0;
        }

        // method to add a sample of type double
        void addSample(double sample) {
            // check for exception
            if (_dataBuffer == nullptr) { return; }

            // saturate counter at max samples
            if ((_numSamples + 1) <= _maxSamples) {
                _numSamples ++;
                _sum += sample;
            } else {
                // add the new value but remove the value at the
                // current index we're overwriting
                _sum += sample - _dataBuffer[_idx];
            }

            _dataBuffer[_idx] = sample;
            _idx = (_idx + 1) % _maxSamples;
        }

        // method to retrieve a filtered sample
        double getResult() {
            // check for exception
            if (_dataBuffer == nullptr) { return 0.0; }
            return _sum / _numSamples;
        }

        // shutdown method
        void shutdown() { delete[] _dataBuffer; }
};


int main()
{
    printf("Hello World\n");
    // setup
    SMAFilter filter(5); // 5 sample buffer
    // add 20 samples, increasing linearly by 10, and then some noisy 100s every 5 cycles.
    for (int i = 0; i < 20; i++) {
        if (i%5 == 0) { filter.addSample(100); }
        else { filter.addSample(i*10.0); }

        // read the filter output at every point
        printf("output:\t%f\n\n", filter.getResult());
    }
    // shutdown
    filter.shutdown();

    return 0;
}
```

## Other Filter Types

There's one more section here as a postnote: SMA filtering is probably the lowest apple on the tree. There are many more filtering techniques that you can explore, and I highly encourage you to do so.
One you'll probably hear about is the Kalman filter; I've linked a couple of
different tutorials on how to possibly implement this filter:

- [Instructables \| Stabilize Sensor Readings with Kalman Filter](https://www.instructables.com/id/Stabilize-Sensor-Readings-With-Kalman-Filter/)
- [Medium \| The Kalman Filter: An algorithm for making sense of fused sensor insight](https://towardsdatascience.com/kalman-filter-an-algorithm-for-making-sense-from-the-insights-of-various-sensors-fused-together-ddf67597f35e)
- [intechopen \| Introduction to Kalman Filter and Its Applications](https://www.intechopen.com/books/introduction-and-implementations-of-the-kalman-filter/introduction-to-kalman-filter-and-its-applications)
- [Wikipedia \| Kalman Filters](https://en.wikipedia.org/wiki/Kalman_filter)

## Conclusion

This is the end of the sensor filter development tutorial. Hopefully what you should have gotten out of this is how SMA filtering works, how to implement it in code, how to use it, as well as potential ways to optimize it.

This might be the first in a series of technical blog posts, so any feedback
for future posts are greatly appreciated!

---

Author: Matthew Yu
