---
layout: post
imagepath: resources/blog/2016-01-29-robotathon-recap
title: Robotathon Recap!
shorttitle: 2016 - Robotathon
---

This year’s Robotathon wrapped up this past November with amazing showings from
all of our teams.

This years challenge was RASBall, a competition requiring your
robot to sort ping-pong balls and marbles into two separate goals. The rules for
the competition can be found here. We had an amazing turn out this year with
over 100 students, in 17 teams, participating in the competition. Most of the
participants were freshman college students and most had little prior robotics
experience. 

## The Challenge

The goal of Robotathon is to give an opportunity to students new to robotics to
design a simple autonomous robot that is capable of performing a straightforward
task. All teams are assigned a mentor in RAS who already has experience in
robotics and has typically competed in Robotathon in a previous year. We also
offered weekly workshops, hosted by an experienced member of RAS, to get teams
prepared for the weekly checkpoints. 

![This year's Robotathon field]({{ site.baseurl }}/{{ page.imagepath }}/field.png)

The first step of the competition this year was to introduce teams to their
mentors for the competition and to begin mechanical design. All teams had to get
their design approved by our faculty mentor, Dr. Valvano, before proceeding with
building their robot. This gives teams a chance to work together to plan out
their strategy for the competition. Many teams began by sketching out their
design on our whiteboards and brainstorming possible strategies, but many upped
the ante by creating full CAD models of their designs. 

After the robots were based out mechanically, teams began setting up their
electrical components. Their first goal with electrical components was to set up
an LED and make it blink using the TI LM4F micro controller we gave every team.
This was to get acquainted with the micro controller and using RASBox, a Ubuntu
virtual machine we had set up for the competition with LM4Flash and RASLib (the
library we’ve created for LM4F microcontrollers). Using this system, the teams
had the opportunity to learn basic linux command line, directory setup, vim,
GCC/GDB usage, and Github version control. 

Soon after the teams had gotten their LEDs to blink we hosted battery day, an
event where every team got to create their battery packs for use in the
competition. They soldered their batteries together, heat shrunk the pack, and
attached anderson connectors and a switch for ease of use. 

The next week of the competition was dedicated to building the robots. The goal
was to complete a moving base within a week, but many made it far past that
objective. Teams used a variety of materials to create their designs including
acrylic, lexan, wood, metal, cloth, plastic, and cardboard. Many teams this year
chose to laser cut their designs out of acrylic or wood as it was a very
mechanical-design heavy competition. Some teams even 3D printed parts for their
sorting mechanisms. 

![Turbolifts member Mark working on Robot]({{ site.baseurl }}/{{ page.imagepath }}/turbolifts.jpg)

After the mechanical portion of the robots was completed, teams began work on
their autonomous algorithms. Their three goals over the next few weeks were to
complete wall following, line following, and object detection algorithms. RAS
gave multiple workshops on algorithm design for this portion of the competition
and many of the teams managed to put out some pretty impressive wall and line
followers. 

## The Competition

The Robotathon 2015 competition was held November 16th 2015 and 7pm. We had a
panel of talented judges: Dr. Jon Valvano (professor at UT Austin), Cruz
Monrreal (MCU Applications Engineer at Silicon Labs), and Austin Blackstone
(Applications Engineer at ARM) to evaluate the teams’ software and mechanical
design. The Vice President of RAS, Sid Desai, emcee’d the event, and after a
short opening speech from him, the robots were off. 

The Avengers (Daniel Teal, Shrikar Murthy, Yazan Alatrach, Alex Smith, Angelique
Bautista, and Daniela Barrios), had a sweeping victory, nearly clearing the
course every round they participated in. Their robot had an impressive
mechanical design, based off of a roomba, that would sort the balls into two
difference compartments by hoovering them up then sorting them by size using a
lowered gate. The robot would then find a goal, back towards it, then pull
forward using the inertia of the balls themselves to drive the balls into the
goal. 

![The Avenger’s robot]({{ site.baseurl }}/{{ page.imagepath }}/avengers.jpg)

This year’s Robotathon was a huge success, and we hope to make it even bigger in
future years. Hope to see you all there next year!

![Robotathon 2015]({{ site.baseurl }}/{{ page.imagepath }}/group.jpg)

## Critics rave!

Our RASLets had a great time.  Here are some of the responses to the
post-competition survey:

#### “I had fun creating a real functioning autonomous system.”

###### “My favorite part about Robotathon was the freedom to do what we wanted along with the guidance from great mentors. Also, working in a team with other, different people.”

#### “I was so privileged to work with these people and to learn about robotics.”

### “The mentors are awesome!!!”

###### “My favorite part about Robotathon was learning about the difference sensors and reverse engineering other people’s code and designs.”

###### Author: Sarah Muschinske
