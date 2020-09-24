---
layout: post
title: Micromouse Fall Plans
imagepath: resources/blog/2020-09-22-micromouse
shorttitle: 2020 - Micromouse
excerpt_separator: <!--more-->
---

The fall semester has begun, and our micromouse team is hard at work! Even though we're only meeting up online this semester, we're still able to make significant progress on our robot. <!--more--> Our goal for this Fall is to design and code as much as we can without testing. Once the Spring comes along, we'll be able to assemble our PCB and test and tune our code on real hardware! Our hardware team is revising and finalizing the schematic from the spring. They will be determining the final PCB layout, and we'll hopefully get a board out before the end of the fall, ready for assembly in the spring. Our software team has been divided into three parts: Firmware, Algorithm, and GUI.

Our firmware team is switching over and learning how to use Code Composer Studio and TI-RTOS to program the TM4C. They will be writing as much driver code as they can without testing on actual hardware.

The Algorithm team is developing the micromouse algorithm, which consists of maze searching, decision making, and maze solving. They are developing a simulator and the micromouse algorithm in Python, and once finalized, they will port the algorithm into C and layer it on top of the firmware.
The GUI team is using Python to develop a visual telemetry interface that will run on a laptop. The laptop will connect to the TM4C through an ESP8266 wifi module, and the micromouse will be uploading telemetry data to the GUI. The GUI team will also be responsible for developing the communication protocol and working with the firmware team to correctly integrate wifi communication. This semester is shaping up to be an interesting season, and we can't wait to see what we'll accomplish this Fall! If you'd like join, check out the micromouse channel on the UT RAS Microsoft Teams, or contact [alljiang@utexas.edu](mailto:alljiang@utexas.edu). We meet on Saturdays at 7PM on our micromouse Discord server.

Author: Allen Jiang
