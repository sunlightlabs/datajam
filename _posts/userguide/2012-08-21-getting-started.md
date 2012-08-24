---
title: Getting Started
layout: docs
description: Get up and running with Datajam.
permalink: userguide/getting-started/index.html
section: User Guide
breadcrumb:
  - Datajam
  - User Guide
  - Getting Started
---

##Installation

Datajam is a Ruby on Rails application designed with Heroku in mind. It can be
deployed to any Rack-compatible server, but it's easiest to get started with
Heroku.

We'll assume you have, at a minimum, a computer with **Ruby/Rubygems**
and **Git** installed. You'll need more packages to run the code locally, but
these two are enough to get started deploying. Shell examples in the steps
below will be for UNIX environments, but Datajam should run just fine on
Windows as well.

### Heroku

If you're deploying to Heroku, you should follow their
[quickstart guide](http://www.heroku.com/pages/quickstart).

### One-line install

If you're on Linux or Mac OS, you can install and deploy Datajam to Heroku
by running a single shell script:

    $ sh <(curl get.datajam.org)

By default, this will put Datajam in a folder called `.datajam/` inside
your home folder. To override this default, run the command with an env
var set:

    $ DATAJAM_ROOT=/Users/dan/code/my_datajam_site sh <(curl get.datajam.org)

The install folder you choose **does not** have to exist. Once you're done installing,
you can skip ahead to [Up and Running](#up_and_running).

### Installing Manually

In some situations, you may want to install Datajam manually. Deploying to
your own hardware or installing on a Windows machine will require that you
grab the code and run it yourself. Datajam uses Bundler for dependency management,
so fortunately it's pretty easy!

<div class="alert alert-info">
    <p>
    <strong>A note on Package managers</strong>: If you're planning to install
    on your own, it may be helpful for you to use a package manager, if one is
    available for your operating system. Some of the more popular ones:
    </p>
    <ul>
        <li><strong>Mac OS</strong>: <a href="http://mxcl.github.com/homebrew/">Homebrew</a></li>
        <li><strong>Debian/Ubuntu</strong>: <a href="https://help.ubuntu.com/community/AptGet/Howto">APT</a></li>
        <li><strong>RHEL/CentOS</strong>: <a href="https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/ch-yum.html">Yum</a></li>
        <li><strong>Windows</strong>: <a href="http://windows-get.sourceforge.net/">Win-get</a></li>
    </ul>
</div>

#### Get the Code

First, check out a copy of the Git repository. If you haven't installed Git,
[github has a great guide](https://help.github.com/articles/set-up-git).

Once you've done that, clone the repo from the parent directory of where
you'd like to put the code.

    $ git clone https://github.com/sunlightlabs/datajam.git

#### Install Dependencies

If you're planning to run Datajam locally, The easiest way to get up and running
is our Vagrant VM. See the [vagrant instructions](/userguide/vagrant/) for more information.

If you're deploying to a server, there are some dependencies to install.
Datajam relies on the following:

- **Redis** - [redis.io](http://redis.io)
- **MongoDB** - [mongodb.org](http://mongodb.org)
- **ImageMagick** - [imagemagick.org](http://www.imagemagick.org/)
- **Ruby 1.9.3 / RubyGems** - We suggest using [RVM](http://rvm.io) to install ruby.
- **An Email backend** - Datajam comes configured for [Sendgrid](http://sendgrid.com) out of the box.

#### Bundler

Once your dependencies are good to go, just run

    $ bundle

#### Bootstrap

The last step of the install process is to install the database fixtures.

    $ rake db:seed

## Up and Running

### The Development Server

To visit your new Datajam site, start the development server.

    $ rails server

If all goes well, you can visit [localhost:3000](http://localhost:3000)
and you'll be greeted with a barebones event page, with the heading
"Welcome to Datajam."

### Logging In

Visit the admin area, either by clicking the link on your homepage, or visiting
[localhost:3000/admin](http://localhost:3000/admin), and login with the following:

- **Username**: changeme@example.com
- **Password**: changeme

You'll notice that your password is 'changeme,' and you should do that now. Visit
the [Users](http://localhost/admin/users) section of the admin site, and update your
information.

## A Note on Deployment

We've gotten started using the Rails development server, but it should never be
used in a production environment. Not only is it single-threaded, but Datajam
stays fast by bypassing Rails for most end-user requests. If you're not
using Heroku, Make sure that you deploy to a proper production stack--we
recommend [Nginx](http://nginx.com) with either [Unicorn](http://unicorn.bogomips.org/)
or [Puma](http://puma.io/).

##### [**Next**: Designing your site &raquo;](/userguide/design)
