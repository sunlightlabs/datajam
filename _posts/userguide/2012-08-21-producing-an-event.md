---
title: Producing an Event
layout: docs
description: How to run live events with Datajam.
permalink: userguide/events/index.html
section: User Guide
breadcrumb:
  - Datajam
  - User Guide
  - Producing an Event
---

## The Edit form

By default, an event was created for you when you installed Datajam. Your
event page should look something like this:

![Event page screenshot](/img/userguide/your-first-event.jpg)

Let's go through these fields one at a time:

### Event Name

The name of the event shows up in several places. First, it is the basis for
automatically generating your event's __slug__. The slug is the url path at
which your event will be archived once it's off the homepage. This means that,
like static pages, you can't use a reserved word such as "admin" as an event name.

You may also want to display your event name as a heading above the event page via a template tag.
By default, our template instead uses a custom field for this, so that your names
can stay short and url-friendly.

### Tag String

This is an auto-suggesting field for adding tags to your event. Tags are used to
filter what content is available to producers during an event; for example,
the Data Card plugin uses tags to shorten the list of datacards that can be selected
during an event--without tags, you could have hundreds or thousands of datacards
to sift through over time!

### Event Template

All of the event templates you've created will show up in this drop-down list;
just pick the on you want to use for this event. This determines what custom
template fields are available to your event as well.

### Embed Templates

Check the boxes next to which event templates (which you create) should be
published with this event. Their urls will be your event url plus the
slug of each embed template.

### Scheduled At

Free-form text representing the time of the event. You can use the examples on the form,
'this Tuesday at Noon', or 'May 25, 2013 at 4:00PM' as guidelines for the types of
formats the form will understand. You can also enter a plain date such as
'05/25/2013, 4:00PM'

<div class="alert alert-warning">
    <p>
        <strong>Timezones and Heroku</strong> By default, Heroku servers are on UTC time.
        Be sure to set your time zone via <code>$ heroku config:add TZ=America/New_York</code>
        or your equivalent in order to get accurate times!
    </p>
</div>

### Custom Template Fields

These are created by the event template you select, and can be filled out individually
for each event. They do not accept HTML.

## Running the Event

Once your event is set up, you're ready to run it. Visit the homepage of your
Datajam site. If you're logged in to the admin (you can do so at /admin if not),
you'll see the On-Air toolbar atop the page in addition to your event.

### The On-Air Toolbar

![On Air toolbar](/img/userguide/onair-toolbar.png)

The on-air toolbar gives you control of all of your content areas while an
event is going on. Click the name of the content area you'd like to change,
and its modal will pop up. Make your changes, and click update if required,
and your content area will update for all your viewers in just a few seconds.

### Embedding Video

By default, your template will have a content area called "Video Embed." This
name has no real significance, but we'll use it to embed a video of our event.

![Content area modal](/img/userguide/content-area.jpg)

When you click the "Video Embed" link in the toolbar, you'll see that the
dialog is prepopulated. This is the YouTube embed code for the video that you
see on your event page now. Select all of it, and replace it with the video embed
for your event. This embed can be an `<iframe>`, `<embed>` or `<video>` tag, or you
can use something like swfobject, so long as you include the script tag in the
dialog box. Click update when you're done, and you should see your new video feed
in just a couple seconds.

### Content Updates

Other content updates work the same way as our video embed. Try creating new
content areas in your event template and adding HTML to them.

### Using Plugins

Plugins are Ruby applications that hook into and extend the functionality of
Datajam.

You can install plugins to Datajam by editing a file in your repository called
`Pluginfile`. If you're familiar with Ruby and Bundler for installing Ruby Gems,
Pluginfile is just like a Gemfile, but specifically for Datajam plugins. You can
install plugins from rubygems.org, or from a git/svn repo.

Plugins are able to render their own modal dialogs, and will likely have
a different interface than the standard content area dialog. The plugin's
maintainer should provide instructions in the admin, on the plugin's main
page.

More information on plugins can be found in the [plugins section](/plugins/)
of this site.

## After the Event
### The Archive

Events can be archived when they are over, simply click the 'archive' button
in the event list.

![Archiving an event](/img/userguide/archive-event.png)

This will publish the event to the top of the Archives page, and populate
the homepage with the next upcoming event, if one is available. when many
events are set to occur in succession, it is desirable to set up several at a time,
so you can advertise your next event as soon as one is over.

##### [**Next**: Site Administration &raquo;](/userguide/administration)
##### [&laquo; **Previous**: Designing Your Site](/userguide/design)
