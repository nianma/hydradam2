# HydraDAM

HydraDAM is Rails app built using [Sufia](github.com/projecthydra/sufia),
tailored for handling audio and video.

# Table of Contents

TODO: use `gh-md-toc` tool

# Installing

When we say "installing" here, what we mean is setting up a development
instance, where the assumed Rails environment is the `development`. We
do _not_ mean setting up a prodution instance. That is covered in
[Deploying](#deploying)

While Sufia is a Rails engine that provides generators to initialize your app
and perform upgrades to later Sufia versions, HydraDAM is the result of having
run those generators. As such, there is no need to run them again.

That said, the HydraDAM code base does not contain _all_ of the the Sufia installation instructions contain several steps that you
must also have to do to set up a HydraDAM instance. So if it looks like we
merely copied the Sufia installation instructions in places, and changed the
name to "HydraDAM", that's probably what happened.

## Prerequisites

HydraDAM requires the following software to work:

1. Ruby is the language.
1. [Solr](http://lucene.apache.org/solr/) for the search index and [Fedora](http://www.fedora-commons.org/) for the data repository (both included as part of hydra-jetty).
1. [Redis](http://redis.io/) key-value store for processing asynchronous jobs using the [Resque](https://github.com/resque/resque) gem.
1. [ImageMagick](http://www.imagemagick.org/) for thumbnail generation.
1. FITS for file characterization.
1. FFMPEG for audio-visual transcoding.

> **NOTE:** If you do not already have Solr and Fedora instances you can use in your
> development environment, you may use hydra-jetty (instructions are provided
> below to get you up and running quickly and with minimal hassle).

## Install Ruby

First, you'll need a working Ruby installation. You can install this via your
operating system's package manager -- you are likely to get farther with OSX,
Linux, or UNIX than Windows but your mileage may vary -- but we recommend
using a Ruby version manager such as [RVM](https://rvm.io/) or
[rbenv](https://github.com/sstephenson/rbenv).

The version of Ruby that HydraDAM supports may change over time. But you can
check which versions we test agains in our [Travis CI configuration](./.travis.yml).
Any version listed under the `rvm` entry is one we test against.

## Install Solr and Fedora via hydra-jetty

If you already have instances of Solr and Fedora that you would like to use,
you may skip this step. Otherwise feel free to use [hydra-jetty](https://github.com/projecthydra/hydra-jetty),
the bundled copy of Jetty, a Java servlet container that is configured to run
versions of Solr and Fedora that are known to work with Sufia. Hydra-jetty
(since v8.4.0) requires Java 8.

The following rake tasks will install hydra-jetty and start up Jetty with Solr and Fedora.

```
# downloads the latest hydra-jetty from the web.
rake jetty:clean
# copies the HydraDAM solr and fedora config into the newly downloaded hydra-jetty.
rake sufia:jetty:config 
```

## Install Redis

**TODO**

## Install ImageMagick

**TODO**

## Install FITS

File characterization is done using FITS (File Information Tool Set).

1. Go to http://projects.iq.harvard.edu/fits/downloads and download a copy of
   FITS & unpack it somewhere on your machine.  You can also install FITS on OSX
   with homebrew `brew install fits` (you may also have to create a symlink from
   `fits.sh -> fits` in the next step).
1. Mark fits.sh as executable (`chmod a+x fits.sh`)
1. Run "fits.sh -h" from the command line and see a help message to ensure
   FITS is properly installed
1. Give your Sufia app access to FITS by:
    1. Adding the full fits.sh path to your PATH (e.g., in your .bash_profile), **OR**
    1. Changing `config/initializers/sufia.rb` to point to your FITS location:  `config.fits_path = "/<your full path>/fits.sh"`


## Install FFMPEG

Sufia includes support for transcoding audio and video files.  To enable this, make sure to have ffmpeg > 1.0 installed.

On OSX, you can use homebrew for this.

```
brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis
```

# Running HydraDAM Development Instance

When we say "running HydraDAM" what we mean is starting the Rails app server,
and all dependent services, which includes:

1. Solr and Fedora (via jetty)
1. redis-server
1. resque


## Start Solr and Fedora via Jetty

The Rails app server will run without Solr or Fedora, but HydraDAM will not
work properly as a result. Generally, you may start and stop jetty
independently of starting or stopping the Rails app server.

```
rake jetty:start # this will start jetty
rake jetty:stop # this will stop jetty
rake jetty:restart # this will fill your hard disk with cat pics. Just kidding, it will restart jetty. 
```

## Start Redis and Resque

To start Redis, simply run:

```
redis-server
```

And after Redis is running, you can start the Resque processes like so:
```
QUEUE=* rake environment resque:work
```

**NOTE:** Both the Redis and Resque processes will run until you kill them, so you will need to run them in dedicated terminal windows,
or run them in the background.

# Deploying

TODO