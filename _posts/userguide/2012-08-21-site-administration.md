---
title: Site Administration
layout: docs
description: Managing your Datajam-powered site.
permalink: userguide/administration/index.html
section: User Guide
breadcrumb:
  - Datajam
  - User Guide
  - Site Administration
---

## Users

You can add authorized users to manage content on your Datajam site, as well
as to produce events as a team. All users are able to log in to the admin site
and get the on-air toolbar when viewing an event.

### Adding / Editing Users

To create a user, just visit the 'users' link in the admin site and toggle
the 'create new' tab. Fill in the appropriate details and click 'Create User'

![Creating a user](/img/userguide/create-user.png)

### A Note on Privileges

<div class="alert alert-warning">
    <p>Be aware that there are no privilege levels in Datajam. Each user
       has the all of the capabilities of an administrator, so be sure
       that your users are suitably familiar with the system.
    </p>
</div>

## The Site Cache
### How Datajam Uses Redis

As alluded to in the design section, Datajam serves all user-facing content
directly from redis to maximize concurrency and performance. Because the
pages are all generated, it may be necessary from time to time to rebuild
the cache. There's a `reset!` rake task that is hooked into the admin
to help with just that.

### Rebuilding the Cache

To delete items or completely rebuild the site cache, visit the 'site cache'
page in the admin. You'll see a list of all of the urls currently in the
cache and can delete each one individually by clicking the red delete button.

To rebuild the cache, select 'rebuild cache' from the actions menu. It may
take several seconds to rebuild the cache.

![Rebuilding the cache](/img/userguide/rebuild-cache.png)

## Scaling & Deployment
### Heroku

Deployment and managing scale are trivial with Heroku--just make your changes,
commit them into your working copy of Datajam
( <abbr title="A hidden folder named .datajam in your home folder"><code>~/.datajam</code></abbr> by default ),
and run `git push heroku master`. Heroku will take care of the rest.

To scale, you can use heroku's scale command:

    heroku ps:scale web=n

Where _n_ is the number of _dynos_ to run. Each dyno will run 3 server processes.

<div class="alert alert-error">
    <p><strong>Note:</strong> any more than 1 dyno running on an instance all the
    time will incur cost from Heroku. Generally, you're credited with enough CPU
    time to run a single dyno constantly, plus a little extra.</p>
</div>

**Addons**

The service level of the various addons that Datajam uses will also need
to increase as you scale up. In general, it's important to check the number of
connections available in various plans of RedisToGo and MongoLab after you surpass
3 dynos. These services can also be scaled up and down on demand, and only bill
for time used.

### Recommendations for Custom Deployments

Running on custom hardware is outside the scope of this documentation, but
we recommend a few specifics in your stack that we think will make it easier:

- **[Capistrano](http://capify.org)** for deployment
- **[Unicorn](http://unicorn.bogomips.org) or [Puma](http://puma.io)** as an application server
- **[Nginx](http://nginx.org)** as a front-end HTTP proxy
- **[Foreman](http://theforeman.org)** for managing heroku-style environment-based config

## Extending Datajam

Datajam includes a plugin architecture for adding new functionality. You can write
plugins yourself, or use existing ones right out of the box.

### Where to Get Plugins

A list of plugins is kept at <http://datajam.org/plugins/>

### Plugin Authoring

See the [plugin creator's guide](/plugins/authoring/) for information on writing your own plugins.

##### [**Next**: All About Plugins &raquo;](/plugins/)
##### [&laquo; **Previous**: Producing an Event](/userguide/events)
