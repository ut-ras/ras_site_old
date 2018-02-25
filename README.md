ras_site
========

The official source for the official website of the UT Austin student branch of
the IEEE Robotics & Automation Society [here](https://ras.ece.utexas.edu).

This website uses Bootstrap 4.0 to look pretty.

### Building

This website is statically built using [Jekyll](https://jekyllrb.com/). Quick
start: install Jekyll, then run "jekyll serve" in the main directory. The site
will be compiled to the directory "_site" while Jekyll locally hosts the site
at 127.0.0.1:4000.

Related posts are calculated via Jekyll's latent semantic indexing. For this
to work properly, Jekyll claims it requires the "classifier-reborn" Ruby gem.

### Tips

Jekyll is scripted in the [Liquid](https://jekyllrb.com/docs/templates/)
templating language. A good Liquid cheatsheet may be found
[here](https://gist.github.com/JJediny/a466eed62cee30ad45e2).
