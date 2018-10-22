---
layout: post
title: Micromouse - so it begins
imagepath: resources/blog/2018-10-21-micromouse
shorttitle: 2018 - Micromouse
---

RAS is proud to introduce a new committee called micromouse.

This consists of an autonomous maze mapping and solving robot. This year the competition that we are going to will be in California. Currently, our committee is experimenting with sensors, a new micro-controller, and algorithms for the robot.

![maze schematic]({{ site.baseurl }}/{{ page.imagepath }}/1.jpg)

### Sensors

For micromouse, we are planning to build our own distance sensors. They are going to use an IR LED Emitter and Receiver to measure the distance between the robot and walls. Our goal with the sensors will be to use them to help the robot understand its current location in the maze and to not crash into walls.

![LEDs]({{ site.baseurl }}/{{ page.imagepath }}/2.jpg)

### Microcontroller

The micro controller that  we are using is the ESP-12. This will give us the ability to debug and upload code without connecting to the board. We are currently working on wrapping their ADC Code and PWM code into versions that will be easier for us to use.

![microcontroller]({{ site.baseurl }}/{{ page.imagepath }}/3.jpg)

### Algorithms

To map and solve the maze, we are investigating different algorithms for the mouse to map the maze. Our algorithms are being tested on a micromouse simulator and we are trying to understand what would be the best way to solve the maze.

Author: Vamsi Ghorakavi