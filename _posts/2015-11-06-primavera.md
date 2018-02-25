---
layout: post
imagepath: resources/blog/2015-11-06-primavera
title: Primavera
shorttitle: 2015 - Primavera
---

Primavera is the image processing component of the painting robot project RAS in
involved in, called Robotticelli.

Several of us have been working on primavera
for about a month now, and it's starting to approach something useful.  We'll
take you through our process, but first a quick introduction to Robotticelli.

### Robotticelli

Joe Kristofoletti, an Austin artist was engaged by the
[<span class="bodyLink">Drawing Lines</span>][drawinglines] project to do
something interesting.  But he was feeling lazy, and since we're in the age of
robots, he asked us to make a robot to do it for him.  So our challenge: build a
robot that, given an image, spray paints it on the side of a roughly 5-story
tall building.

[drawinglines]: http://www.drawinglinesaustin.com/news-events/2015/9/18/from-the-studio-district-six

One of the limitations of doing this with a robot is that it can carry only so
many cans of spray paint with it as it climbs all over the wall.  Our current
design limits us to four colors per trip, but we will probably need more than
one round of four cans to paint the entire wall.  Still, we can't expect to be
able to use more than eight different colors of spray paint for one mural.  How
can we take a digital picture, which is represented by RGB color (which adds up
to over 16 million different colors) and represent it with just four to eight?

### Image processing

The technical term for this process is called "color quantization", or reducing
the number of distinct colors in an image.  We adapted a color quantization
algorithms using kmeans to identify the best colors of spray paint to create a
particular image.

We use Python, 
[<span class="bodyLink">scikit-learn</span>][sklearn], and
[<span class="bodyLink">OpenCV</span>][opencv]
to quantize the image and select the best colors of spray paint available.

[sklearn]: http://scikit-learn.org/stable/index.html
[opencv]: http://opencv.org

#### First iteration: KMeans for clustering

We found this
[<span class="bodyLink">example</span>][sklearn_example]
on the scikit-learn website very helpful.  It uses KMeans, a machine learning
algorithm, to cluster pixels into groups based on similarity.  An image that is
comprised of three shades of red and one shade of blue would be reduced to one,
average shade of red and the shade of blue, for example.  We can specify to
kmeans how many clusters to create, which is how many different colors it will
try to group pixels into.

[sklearn_example]: http://scikit-learn.org/stable/auto_examples/cluster/plot_color_quantization.html


```python
import cv2
from sklearn.cluster import MiniBatchKMeans

# Load and reshape the image into a list of points in a 3-D space
image = cv2.imread('samples/frog.jpg')
h, w, _ = image.shape
image = image.reshape((h * w, 3))
# Run KMeans on the pixels and get the centers
clt = MiniBatchKMeans(n_clusters=8)
labels = clt.fit_predict(image)
centers = clt.cluster_centers_.astype("uint8")
# Create a new image out of the output of KMeans
image = centers[labels].reshape((h, w, 3))
# We save the output as a PNG because JPG compression interferes with individual pixels.
cv2.imwrite('out-kmeans.png', image)
[list(reversed(color)) for color in centers]
```




    [[254, 254, 254],
     [68, 42, 11],
     [172, 184, 59],
     [120, 109, 28],
     [206, 205, 119],
     [151, 136, 90],
     [222, 222, 200],
     [13, 8, 6]]



The output looks something like this:

![Before]({{ site.baseurl }}/{{ page.imagepath }}/frog.jpg)
![After]({{ site.baseurl }}/{{ page.imagepath }}/out-kmeans.png)

The output image contains only the RGB values shown above. It looks like a frog,
but there's a problem: these colors have nothing to do with the colors of spray
paint we can purchase. We contacted our vendor and got a database of 214 colors,
but how do we tell KMeans to use those as its centers? KMeans doesn't know
anything about its input except that it can plot it on a graph and draw clusters
and find the centers; those centers are real-valued numbers.

#### Second Iteration: Finding colors in our database

We didn't want to implement our own machine learning algorithm. We discussed
several options and consulted Dr. Risto at UTCS's AI lab, but the time and
effort it would take to implement it ourselves seemed like too much. So we went
with the second best option, a slightly hack-ish solution: we convert the image
to our database _first_, producing an image with up to 214 distinct colors,
_then_ run KMeans. Once KMeans finds the clusters, we ignore the colors it
suggests (since they are somewhere in the RGB space instead of in the database).


```python
import cv2
import json
import numpy
import scipy.spatial
from sklearn.cluster import MiniBatchKMeans

# Load the color database
db = json.load(open('montana.json'))
names = numpy.array(db.keys())
database = numpy.array(db.values())

# We load and reshape the image as before
image = cv2.imread('samples/frog.jpg')
h, w, _ = image.shape
image = image.reshape((h * w, 3))
# Before we run KMeans, reduce the image onto our database by picking the color
# closest to each pixel
db_idx = numpy.argmin(scipy.spatial.distance.cdist(image, database), axis=1)
image = database[db_idx]
# Run KMeans as before
clt = MiniBatchKMeans(n_clusters=8)
labels = clt.fit_predict(image)
# Ignore the centers; instead, compare each new pixel to the color
# it came from, and pick the best color for each label
bins = numpy.zeros((8, len(database)))
for i, j in zip(labels, db_idx):
    bins[i][j] += 1
centers_to_db = numpy.argmax(bins, axis=1)
# Reconstruct the image from the colors we finally picked
image = database[centers_to_db[labels]].reshape((h, w, 3))
cv2.imwrite('out-database.png', image)
list(names[centers_to_db])
```




    [u'Shock White Pure',
     u'Mt. Fuji',
     u'Shock Blue Light',
     u'Dolphins',
     u'Deep Sea',
     u'Aqua',
     u'Fresh Blue',
     u'Fjord']


![Before]({{ site.baseurl }}/{{ page.imagepath }}/frog.jpg)
![After]({{ site.baseurl }}/{{ page.imagepath }}/out-database.png)

The core of the conversion is the same; there's just a step before and after
that we run through to get the best colors in our database. The output image has
the same form and constrasts as the original, but we can do one better:
dithering.

#### Third Iteration: Dithering

Dithering is a process which attempts to reduce the sharp lines created by color
quantization by various techniques. If you want to learn more about the various
algorithms that can be used, you should check out the Wikipedia article; there
are many options of varying cleverness and efficiency.

We implement Floyd-Steinberg (error-based) dithering and ordered dithering. The
code for these can be found on our
[<span class="bodyLink">GitHub repository</span>][github_primavera].
We're still experimenting with various dithering algorithms, so if you have any
ideas, feel free to open a GitHub issue!

[github_primavera]: https://github.com/ut-ras/primavera
[//]: # (Include dithering examples)

### The future of Robotticelli

Primavera isn't quite done, but now that we've got some idea of what colors of
spray paint to buy, the software team has to figure out how to best apply that
paint onto a wall. This project is codenamed Venus. Spoiler alter: it's a little
bit more complicated than just applying a solution to the travelling salesman
problem; stay tuned for more.

Software is all well and good, but where's the actual robot? The mechanical team
is furiously writing code to model the kinematics of the robot, and designing
the various components in CAD. If you want to help us out, you can find us at
the RAS office in the ACA. Feel free to drop by!

###### Author: Kevin George
