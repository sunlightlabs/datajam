---
title: Authoring
layout: docs
description: A guide to authoring plugins for Datajam
permalink: plugins/authoring/index.html
section: Plugins
breadcrumb:
  - Datajam
  - Plugins
  - Authoring
---

## Rails Engines

**Datajam plugins are Rails engines.**

_Engines_ are how Ruby on Rails
allows a third-party application to wrap and share functionality with
your code. Each Datajam plugin is an engine that can be installed as a
gem in the user's `Pluginfile`, to create new admin pages, content_area
types, or really any functionality at all.

### Basic Setup

The sky's the limit, but there are some conventions we hope you'll follow
when creating your own plugins.

#### Conventions

There's a pretty full stack of software bundled with Datajam, and it's
our hope that you won't go way overboard in introducing unnecessary or
impossible-to-configure dependencies. We chose **Heroku** as a deployment
target because it's a great guide in keeping dependencies portable and
straightforward to run. **We ask that you not introduce dependencies
in your plugins that are unavailable using Heroku's default buildpacks**.

Included in the default stack are:

- MongoDB, using Mongoid 2.x
- Redis
- SendGrid for emails
- CarrierWave on GridFS for file uploads
- Heroku scheduler for cron
- Foreman for process management
- jQuery
- Backbone.js / Underscore.js
- Handlebars.js for templates
-- Underscore templates are ok here too, so long as they are not
   user-editable.
- RSpec, Mocha and Jasmine for testing

The easiest way to get started creating a Datajam plugin is to fork the
example scaffold, at https://github.com/sunlightlabs/datajam-plugin-scaffold.git

#### Datajam as the spec app

It's important to confirm that both your plugin will work when installed
into Datajam, and that it won't break any existing functionality. To
this end, you should submodule in Datajam as your spec app. If you've
forked the scaffold, this is done for you. Otherwise, a basic
`spec_helper.rb` can be found in the [scaffold repo](https://github.com/sunlightlabs/datajam-plugin-scaffold)
on github, as well as at the end of this document in the section on [testing](#testing)

#### The Readme

Datajam builds out a section in the admin site for your plugin automatically.
This includes a main page, a settings page, and some links to actions that can
be performed by your plugin, such as for installation/uninstallation, and maintenance
tasks.

The main page of your plugin's admin area is actually a render of your README.md.
Keep this in mind as you write it, that it should be primarily a guide for your users.
Also be sure to format with markdown, as that's what Datajam expects. Finally,
it's encouraged to use [Travis CI](http://travis-ci.org) to run your specs, and to
include their build status bug in your README.

#### Environment and script/rails

A few tweaks to your environment.rb and script/rails should be made to
make `rails (c|s)` runnable from the plugin's root folder:

<script src="https://gist.github.com/a024e0bbb65c113aba2c.js"> </script>
<script src="https://gist.github.com/3e19d0535d9d66a34d27.js"> </script>

### Structure & Namespacing

#### Models

Unless you have a special use case, models generally will live in the application's
namespace. Datajam will expect to see any content areas you define, for one, in
the root namespace. Due to the way plugins are initialized on boot, it is also
possible to reopen existing models and add or override functionality.

**Content Areas & Callbacks**

By default, ContentArea is always marked dirty, to ensure that save callbacks
run whenever the parent event is saved. Bear this in mind if you override `changed?`
in whatever custom content area your plugin may define.

Below is a gist of a sample content area, taken from the Chat plugin. Content
areas implement methods that will be called by Datajam, so it's worthwhile to go
over them here:

`self.modal_class`

This class method defines the name of the modal prototype that backbone will
instantiate for your content area when found in a template. If it's not
`Datajam.views.Modal`, you'll need to supply the necessary backbone code
and install it to GridFS in your plugin's install method. We'll cover this
in more depth in the section on static assets.

`render_head`, `render_body`, `render`, `render_update`

These methods are called when Datajam needs various bits of HTML to fill in
holes in your event template. `render_head` and `render_body` are filled into
`{{ '{{' }}{ head_assets }}}` and `{{ '{{' }}{ body_assets }}}`, respectively;
`render` and `render_update` are filled into your `{{ '{{' }}{ content_area: Foo }}}`
tag. For most purposes, `render_update` can just call `render`, but there may
be cases where you need to differentiate.

<script src="https://gist.github.com/eaaaaaa94946fa590e5f.js"> </script>

#### Controllers

Controllers generally will live in the `Datajam::<Myplugin>` namespace, with the
exception of the admin site. `Admin` has its own namespace and should inherit `AdminController`

If you're using the plugin scaffold, you'll see `Datajam::<Myplugin>::EngineController`
and `Datajam::<Myplugin>::PluginController` are already created.

`EngineController` is the base for any controllers you may need to define, and
`PluginController` is called by Datajam to perform actions from the plugin's
settings page.

<div class="alert alert-info">
    <p>Because of the caching architecture of Datajam, controllers don't do a
        ton of legwork. In a content-oriented plugin, most of the work will
        involve caching JSON or HTML into redis in response to various events.
    </p>
</div>

#### Routes

If you're using the scaffold, the basis for your routes is already laid out, but
as expected, they should mirror your controller setup:

<script src="https://gist.github.com/b2956b4222767d70fbe6.js"> </script>

#### Views

**Layouts**

It's unlikely that you'll need to define your own layouts in a plugin. The
most likely case that you may would be if you've got a content area that includes
an `<iframe>`, and you need to exclude the admin chrome. If you do this, be
sure to include all of the necessary assets. Chat's admin layout is about the
simplest implementation of a plugin layout:

<script src="https://gist.github.com/d76ba824926c409da9d5.js"> </script>

**Rendering Templates (From models)**

There's a mixin available in the global namespace, RendersTemplates, that
can render erb templates via a dummy controller. Because models frequently
push to cache on save, and are served via rack middleware without invoking rails
at all, traditional controllers don't make much sense. Declaring `include RendersTemplates`
in your model provides you with a few public methods:

- `get_renderer`: Returns an instance of `DummyController`, an instance of
    `AbstractController::Base`, including all the paths, layout access, helpers,
    etc that you might need.
- `render_to_string`: Renders a template to a string the same way a controller would.
- `head_assets`: Renders the stock Datajam head assets to a string.
- `body_assets`: Same as head_assets, but with body assets.
- `add_body_class_to`: Accepts two arguments, `html` and `classname`. Finds the
    body tag in `html` and appends the passed in classname string. Use this to
    add CSS hooks to your pages if necessary.

#### Static Assets

If you're adding anything more than the most basic functionality, it may be necessary
to bundle static assets. Currently Datajam does not use the asset pipeline, and
stores plugin assets in GridFS. This may change in the future, but at present the
recommendation is to provide a job and/or rake task that glob through your plugin's
public or assets directory and copy assets to GridFS:

<script src="https://gist.github.com/e56bd3393556856770ef.js"> </script>

The official plugins incorporate a build step to concatenate
and minify all necessary scripts into a single `application-compiled.min.js`,
called via git pre-commit hook. How you do this is up to you, but an example of
ours, using rake and a manifest file can be found in Chat or Datacard's source.
More discussion of asset packaging will be included in lower sections of this guide.

## Caching

Much has been made of caching in this documentation, and for good reason since
the cache provides a ton of throughput for a heavily polling-based architecture
such as Datajam's. Below are a few details about cache implementation for your
plugin.

### The REDIS Global

The Redis instance connected to the cache middleware is available to you in a
global called REDIS. You'll want to write to a namespace based on the current
environment. Below is the main Datajam namespace:

    Redis::Namespace.new(Rails.env.to_s, redis: REDIS)

If you need to prevent collisions, you should append an underscored version of
your plugin name to the name of your namespace.

### Reset!

Datajam's `Cacher` class exposes a `reset!` method which rebuilds all of the
system's cache. If your plugin makes use of the cache middleware, you should
implement `Datajam::Myplugin::CacheResetJob`, which will be called by Datajam
when the cache is reset. Of course the logic therein is up to you and depends
on what your plugin does. An example from Chat is below:

<script src="https://gist.github.com/6f768b55f8c0f160d688.js"> </script>

## Settings

Whether API keys, adjustable polling intervals, or extra user-customized text,
most plugins will probably need to store some settings. There is a settings
framework built into Datajam that will create a settings page and manage
CRUD automatically for you.

### Namespacing

All settings have a namespace to determine which application they belong to
and prevent collisions. Your settings namespace should be the same as the
name of your gem as defined in `myplugin.gemspec`; so, if your gem is
called 'datajam-foo', your namespace should be the same string.

You can then acess your setting via an \[\] accessor method:

    Datajam::Settings[:"datajam-foo"][:mysetting]

Settings are memoized, so after changing a setting programatically,
you'll need to call the `flush` class method with your namespace:

    Datajam::Settings.flush(":datajam-foo")

This ensures that the next read will return the updated value. This is done
automatically when settings are changed via the Admin interface.

### Seeds

To bootstrap some settings for your plugin, just create them in your plugin's
`seeds.rb`. For example, chat allows you to store your bitly credentials to
use your custom short url when shortening links:

    Setting.find_or_create_by(:namespace => 'datajam-chat', :name => 'bitly_username')
    Setting.find_or_create_by(:namespace => 'datajam-chat', :name => 'bitly_api_key')

This yields a settings form like this:

![Settings form](/img/plugins/settings.png)

From which you could retrieve the values like this:

    Datajam::Settings[:"datajam-chat"][:bitly_api_key]
    Datajam::Settings[:"datajam-chat"][:bitly_username]

### Coercion

All settings' values are stored as strings, so if you need boolean or integer
values back, you'll need to cast them yourself.

## Hooks

There are a few spots where Datajam will attempt to call your code in response
to life cycle or user events. Of course your models are mongoid models, and respond
to all of the ActiveModel hooks, but there are a few additional ways that
Datajam will attempt to interact via a standard interface.

### Action Methods

The first are your `PluginController`'s action methods.

![Actions](/img/plugins/actions.png)

Each plugin detail page will include an `actions` dropdown, allowing users to
call various methods from the Datajam interface. This detail page comes
for free; there is no need to implement anything into the admin site if
you don't need users to do more than adjust settings and call argumentless
action methods.

The contents of the actions list are determined by your `PluginController`.
Any method you define there will be listed as an available action, unless the
method name is prefixed with an underscore (\_). An example `PluginController`
looks like this:

<script src="https://gist.github.com/9f618aba0d4bc1a5d367.js"> </script>

### Callback Cascading

Content Areas will have their callbacks cascaded down from Events, meaning
any callbacks around create, save or destroy declared on a subclass of `ContentArea`
will be called, where Mongoid would not do so by default. Additionally, `ContentArea`
overrides the `changed?` method to always return `true`, meaning your callbacks will
be run on any persistence operation on `Event` by default.

To change this behavior you'll need to override `changed?` on your custom content area.

## Content Areas & Modals

Content Areas are the holes in your template into which live updates or plugin content
gets populated. The type of area(s) you embed determines what the producer's modal interface
looks like, and what javascripts get included in the event page. To create new
modals and introduce new functionality, you'll want to define your own class of
content area. We've already discussed in the section on [models](#models) what
content areas look like on the ruby side, now we'll address the javascript.

### Backbone.js

User-facing javascript functionality in Datajam is built on Backbone.js, a library
that introduces easy MVC-like structure for your javascript code. An exhaustive
reference for Backbone is well outside the scope of this document, but fortunately
the [official documentation](http://backbonejs.org) is phenomenal.

What you need to know for the purposes of this documentation is that your javascript
code should include at a minimum a view that implements the modal class you specified
as `self.modal_class` in your content area's ruby model. This will be called by
Datajam as the on-air toolbar is built.

The rest of your Application does not need to use backbone at all, but it
is available to you, as is a global installation of [require.js](http://requirejs.org)
and [jQuery](http://jquery.com).

### Require.js

[Require.js](http://requirejs.org) is an <abbr title="Asynchronous Model Definition">AMD</abbr>-
style dependency loader for javascript. It is a great companion to Backbone, as
it makes it simple for you to define your models, views and templates in a familiar
and maintainable file structure similar to that of other MVC frameworks, with
one class per file. Each declares its dependencies, and the code waits to
execute until they are downloaded. Chat and Datacard both use this convention
to some degree, and the steps are pretty well-defined:

1. **Asset paths**: Your plugin needs to tell require where its assets are located.
  A chat area's `head_assets`, for instance, make sure the require global object
  exists, and then set up a path for the application 'chat':
  <script src="https://gist.github.com/23ec53adf763ba3b74ec.js"> </script>
  Note that the path is the GridFS mount point where chat's assets will
  be copied to on install. When require.js is included down lower on the page,
  it will read the `require` object and configure itself accordingly.

2. **Content Area markup**: The next thing added to the page by your plugin should be
  a div or other tag that will be the target element of your base view, typically done
  in a partial called \_content.html.erb. There's no
  need to instantiate containers for your admin modals; Datajam will handle this for you.

3. **Bootstrap the code**: Include whatever code is needed to require dependencies
  and start things up. This should be done in _body_assets.html.erb in your plugin,
  so that all of the dependencies not managed by require will be loaded. A simple
  (non-concatenated) bootstrap might look like this:

  <script src="https://gist.github.com/a22322e534bd933b4c59.js"> </script>

  This code requires files called init.js, and views/chat.js, both
  relative to the 'chat' root, and executes when they have loaded.

  Notice that $, define and require are being passed in by reference. This
  is not particularly necessary, but if a different AMD loader were to be
  used at some point, (say curl.js for example) making the change would be as
  simple as replacing `(jQuery, define, require)` with `(jQuery, curl.define, curl)`.

### Build Step & Asset Refreshing

Some description of the build process used in Chat and Datacard has already
been covered, but it's worthwhile to step through the files involved.

- `.pre-commit.sh`: The official plugins implement the build process as a
  pre-commit hook, so that js assets are built automatically. This shell script
  is symlinked into the .git/hooks folder as `pre-commit`, and is the first
  execution point for the build process.

  <script src="https://gist.github.com/2f56cb4f5ba2b3489daa.js"> </script>

- `lib/tasks/chat.rake#build_javascripts`: This rake task does the concatenation
  and then minifies with google closure compiler.

  <script src="https://gist.github.com/0dcbde6c0d8cb5fd1c19.js"> </script>

- `.javascripts-manifest`: This file contains a line-by-line list of the javascript
  files that should be concatenated by the rake task. Order is significant with
  the chat setup, so using a manifest file makes sure there are no problems there.

  <script src="https://gist.github.com/2bb1363c3445e8ffee1b.js"> </script>


## Testing

It's important to include specs for both the ruby and javascript code of your
plugin when you publish it for others to use. First, to make sure your code is
working as it should, and second, to ensure that it is compatible with Datajam.

### Rspec

Datajam uses rspec to run ruby tests, and it is suggested that you include
specs for your models, controllers and modules at a minimum. An example `spec_helper.rb`
could look like this:

<script src="https://gist.github.com/0ce2a024dc7d45b708ee.js"> </script>

### Jasmine

If your plugin makes heavy use of javascript, you should also include jasmine
specs. How you integrate jasmine is up to you, but here are some tools you might
find helpful:

- [Sinon.js](http://sinonjs.org) for spies, mocks and stubs
- [Jasmine matchers for Sinon](https://github.com/froots/jasmine-sinon)

You'll need to set up all of your js dependencies with jasmine.
`spec/javascripts/support/jasmine.yml` is the place to set that up. A jasmine.yml
that includes all of the core Datajam js dependencies is here:

<script src="https://gist.github.com/94343d4257e042299503.js"> </script>

Note that the first file, environment.js is where your require paths should be set up if
you're using require.


## Questions and Feedback

That's the high-level overview of plugin authoring. This document is of course
a work in progress and if you have feedback please open a ticket on the
[Datajam repo](https://github.com/sunlightlabs/datajam/issues) with the label
'documentation.'
