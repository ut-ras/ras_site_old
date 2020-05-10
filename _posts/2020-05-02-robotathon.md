---
layout: post
title: Robotathon Steering Committee - Your Second Program Update
imagepath: resources/blog/2020-05-02-robotathon
shorttitle: 2020 - Robotathon Steering Committee
---
Hey y'all, this is Matthew, co-head of Robotathon, here again. This is the second update this semester from our Robotathon steering committee.

Recently, we've gone through our semesterly meeting of hell and have secured funding for next semester's Robotathon.

I thought it would be interesting to describe how RAS will organize the competition (and to document it somewhere, for personal reference), so I'll have a second and third post, labeled *Robotathon Steering Committee - How It's Made*, posted today or tomorrow detailing how we decided to allocate the money, what needs to be done to host a competition, and logistic challenges that past competitions have faced.

---
So status updates on where we're at, split into general categories:

## Robotathon Field

We've made updates to the design, namely artistic and in implementation details. We were originally looking at wooden skewers to connect our field tiles(??) together, but our VP Reiko came up with a good idea to use magnets or velcro to attach the tiles. This will prevent poking holes in the tiles.

Another part of the Robotathon field will be a centerpiece structure, the UT Tower of (William C.) Power(s). I can't disclose its specific function in relation to the field, but I can say that it'll perform functions like lighting up the tower when a goal is accomplished, or general score keeping. Electrical components have been figured out, and mechanical design is underway. We hope that the Tower of Power will be used a general showpiece, like our Marquee Signboard, after Robotathon, or maybe even put in the WCP on display.

We're hoping that the designs for the field and tower are completed and parts are ordered by the end of the summer so we can construct it before kickoff. Of course, that won't stop me from developing prototype software on my Arduino to get some basic functions working, like LED strips and a large, $100 LED matrix used for displaying carousel text.

---

## Documentation

So, our Robotathon Guide is in the works! Spoiler image below (I've whited out competition specific pages). About one third to a half of the pages are completed, with a lot of them needing codebase development and testing to validate that they work. Again, we hope that this guide will be mostly reusable year over year, and that it'll be useful outside of Robotathon for anyone interested in embedded development with the TM4C or robots in general.

I don't anticipate releasing the entire guide onto the site until Kickoff, but you may see a couple of pages during update posts in the summer.

![Robotathon Guide Table of Contents]({{ site.baseurl }}/{{ page.imagepath }}/toc.png)

---

## Development Setup

We're still waiting on Windows to release version 2004 with the WSL2 update to begin setting up development instructions that'll work with the TM4C seamlessly. However, work is beginning in the next week or two to go over and revise the development guide in Ubuntu/Linux to make sure it works. You'll hear more about this over the summer.

---

## Codebase

After a month of procrastinating (Spring Break) and a month of dying to Algorithm and Comp Arch labs, I've started looking at the source code for the current RASWare repository. I'm looking to start writing pull requests and changes to this within the next two weeks. This will be an ongoing project throughout the summer, so progress will be incremental.

Some of the things I'll be looking at:

* Designing a top down hierarchy view of the various files to promote functional understanding. I'll be organizing it by sensors and actuators, delineating any relationship between files.

* Improving comments and code signatures (like javadocs). I want to make it explicit what are the interfaces for the various functions and components, easily readable by beginners.

* Adding support for new sensors and motors. Also, updating the I2C interface and making sure it's up to snuff (hint hint).

* Updating the documentation and demos. I want to be able to have fully compilable, flashable code that users can plug and play and use as a base for their robot software. There is a RASDemo folder in the RASWare repo, but I somewhat remember some of the demos, like linesensor.c being only semi functional.

---

## Prototype Bot

We've come to the conclusion that we won't be able to make a prototype bot to test sensor integration this semester, mainly since we can't get the team together in person to develop it. That's not to say that we aren't doing component level validation to make sure you can run IR sensors, motors, etc. That'll be continuing over the summer at my place after I get all the parts I need.

---

Finally, if you're attending UT next fall (we can only hope the pandemic subsides and the university reopens by then), and this competition sounds interesting, please feel free to contact us! We're also open for any contributors who might want to help with design and software development over the summer.

You can join our slack at utras.slack.com and message me (@RoboticFish) or the other co-lead (@Burak Biyikli) or email me at matthewjkyu@gmail.com.

Author: Matthew Yu
