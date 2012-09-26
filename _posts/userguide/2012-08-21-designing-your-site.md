---
title: Designing Your Site
layout: docs
description: How to build out the front end of your datajam-powered site.
permalink: userguide/design/index.html
section: User Guide
breadcrumb:
  - Datajam
  - User Guide
  - Designing Your Site
---

## Introduction

So, you've got your site up and running, but it's pretty sparse, and pretty
generic. It's easy to customize the look and feel of your Datajam site using
the powerful built-in template system.

### Anatomy of a Datajam Site

A site running on Datajam has a few types of pages:

- Home Page
- Event Pages
- Archives
- Static Pages

#### Homepage

By default, the homepage shows the first upcoming event in your event list.
When an event is over, it can be archived, so that the next event will display.
You can populate the event with a 'Coming Soon' message, and let users sign up
to get an email reminder before the event starts.

#### Event Pages

Even though your users will interact most with the homepage, each event has
a permalink as well. These pages are linked automatically from the archive page
when you click the 'archive' button in the admin event list.

#### Archives

The archive page contains a list of your past events, so that they can be
found later and watched again. Keep in mind that some live video streams
aren't archived automatically, and you may need to locate an alternative
video source after the fact.

#### Static Pages

You can create and publish static pages as part of your Datajam site using HTML.
Static pages allow you to set their url, and will be rendered into your [site template](#site_template).

### Handlebars.js

Datajam pages are published by rendering __templates__--a shell into which
data can be inserted--against your events. Datajam templates are stored
in your instance's database, and use a language called *handlebars.js*
to generate the HTML of your pages. Have a look at [their website](http://handlebarjs.com)
for more information about how to use handlebars.

### Template Tags

Beyond the basics of Handlebars, there are some template tags that come
with Datajam that you should know about:

#### Custom Fields

Custom fields are defined in your [event templates](#event_templates), and look
like this: `{{'{{'}} my-custom-field-name }}`. Adding this to your event template
will create a "custom area" in the edit page of any event that uses this template.
So, if you wanted to have a different title on each event, or different open
graph tags, css, etc, you could create custom fields in the event template to
add those.

<div class="alert alert-info">
<p>
    <strong>Note:</strong> Custom fields are <em>only</em> for elements that
    are different for each event. Anything that should be the same across
    all events using a template should just be coded directly into the template.
</p>
</div>

#### Content Areas

Content areas are the parts of your template that are updated in real time
throughout your event. Where you'd have go to your event's edit page, change
the value, and then refresh the page to see a change with a custom field,
you can edit a content area right from the event page, and all your viewers
will see your update without refreshing. Content areas are also defined in
[event templates](#event_templates), and look like this:

    {{'{{'}} content_area: My Content Area }}

The words `content_area` to the left of the colon signify the content area's
_type_. By default, there is only one type, _content\_area_. It defines
what is essentially a hole in your page into which you can insert HTML, in real
time. Plugins add other types, such as _data\_card\_area_ or _chat\_area_.

To the right of the colon is the name of the content area. This is not displayed
to viewers, but determines the text of the link in your producers' toolbar that
can be clicked to bring up the dialog box in which you manage the area's content.

<div class="alert alert-warning">
    <p>
        <strong>Caution!</strong> Changing the name of a content area will create a new
        instance of it, and delete the old one. This is unimportant
        in most cases, but with the chat plugin, any message history will
        be deleted.
    </p>
</div>

#### Asset tags

There are a couple of pre-defined 'asset tags' that should be included in every
[site template](#site_template). These tags embed the css and javascripts that datajam needs in
order to work. They contain plain html and therefore need 3 curly braces:

    {{'{{{'}} head_assets }}}
    {{'{{{'}} content }}}
    {{'{{{'}} body_assets }}}

These tags should go in your [site template](#site_template) only, `head_assets` in the `<head>`
of the document, and `body_assets` near (but before) the `</body>` tag.
The `content` tag denotes where the content from your [event pages](#event_pages),
[static pages](#static_pages), and [archives](#archives) will be rendered into your site template.

## Templates

There are three kinds of templates managed by Datajam, each used to describe a
different part of your site.

### Site Template

Each Datajam install has a single site template, essentially a layout for all
of the pages on the site. The overall structure of the page is defined here.
As mentioned [above](#asset_tags), the site template must contain 3 asset tags:

    {{'{{{'}} head_assets }}}
    {{'{{{'}} content }}}
    {{'{{{'}} body_assets }}}

Changing the site template will re-render all of the pages on your site, essentially
rebuilding the cache for all HTML files.

### Event Templates

Event templates determine the look and feel--and features--of your events. When
you create a new event, you select one of your available event templates to apply
to it. In this way you can brand your events in several different ways from a
single Datajam install, by including different css files at this level.

An event template defines the [content areas](#content_areas) and [custom fields](#custom_fields)
in each event that uses it.

Changing an event template will re-render all of the event pages on your site
that use that template, including the homepage if the current event uses the
template in question.

### Embed Templates

Embed templates are portable representations of a Datajam event meant to be
embedded on other sites in an iframe. For instance, an embed could be used to
just display the chat element of a live event on another page, or just a
video and a content area. Individual embed templates can be associated with an
event when it is created.

## Static Assets (HTML, CSS & Images)

To provide the best performance possible, Datajam makes heavy use of caching
and avoids the rails stack almost entirely for the vast majority of end-user
web requests. In fact, most public-facing urls aren't mapped at all to the
back end. Instead, we publish to a redis cache, and serve directly from it.
As such, there are a few peculiarities with static assets that are important
to know about.

### GridFS

To make getting up and running with Datajam as simple and inexpensive as possible,
we strongly recommend [Heroku](http://heroku.com) as a deployment target.
The majority of users will be fine with a free heroku instance, and it's simple
to scale up to more capacity, even on a temporary basis, if needed.

Because of this preference, we designed static file management to use a technology
called [GridFS](http://www.mongodb.org/display/DOCS/GridFS).

<div class="alert alert-info">
    <p>
        Heroku's file system is <em>ephemeral</em>, which is to say that
        files you write to disk will not be around 10 minutes later. GridFS
        allows us to store files directly in MongoDB, and serve them as though
        they were on disk through rack.
    </p>
</div>

GridFS is a file system spec for MongoDB, Datajam's database. All CSS, JavaScript
and image files uploaded through the admin site will be stored in GridFS, and
served at a path like this:

    http://your-site.com/static/your-file.png

GridFS is plenty fast, and works great for us. Bear in mind that as you scale up
your Datajam site, you may need to scale your MongoLab instance as well, to
ensure you have enough connections to MongoDB. You'll also need to keep an
eye on your storage limits if you're uploading big files to Datajam.

### Caching

As mentioned above, Datajam uses redis for caching, and to serve almost all
user-facing requests. Generally, the cache is maintained by the system, and
is transparent to users. There may be some circumstances (for example, in the
case of a heroku disruption) where the cache may need to be manually recreated.
There is a site "cache page" in the admin just for this purpose. It displays a
list of all of the urls that can be served from cache, and you can delete them
individually, or rebuild all of them.

## Static Pages

Datajam implements the concept of flat pages for 'about' pages,
contact forms, or whatever you can think of. Static pages are rendered into
your site template, and are written in plain HTML or
[markdown](http://daringfireball.net/projects/markdown).

### CSS Hooks

Static pages can be styled individually via classnames added to the `<body>`
tag. All pages will get the class `page`, and additionally each page will
be classed with each url part of its slug. These hooks can be used to highlight
navigation items, change background images, etc.

### Choosing a Slug

The slug you set for your page determines its url. For that reason, your page
slugs cannot collide with any of the event slugs you create, or use any
urls that might otherwise be reserved by the system, such as 'admin'. You'll
be warned if you choose an ineligible slug when you try to save.

### Markdown Syntax

Static pages are rendered with [markdown](http://daringfireball.net/projects/markdown),
a simple text format that aims to make html-compilable text straightforward to
write, and easy to read. In fact, all of the pages of this user guide are written in
markdown. A full syntax guide is available [here](http://daringfireball.net/projects/markdown/syntax),
but the basics are as follows:

    ---
    <!--
        Three or more hyphens on their own line make a horizontal rule.
        Comments use normal HTML syntax.
    -->

    # H1 tag
    ## H2 tag
    ### H3 tag
    #### H4 tag
    ##### H5 tag
    ###### H6 tag

    **bold text**

    _italic text_

    - use hyphens
    - to denote
    - an unordered list

    1. or numerals
    2. to denote
    3. an ordered list
    3. note that the actual numbers used do not correlate to the
       numbers that will be displayed.

    separate multiple paragraphs

    with two new lines.
    single new lines will be ignored;
    all the text will flow together.

    [link text in square braces](http://urls.in/parenthesis/immediately/following)

    [links can also point to](#ids_on_a_page)

    ![images are links preceded by an exclamation point](http://placekitten.com/400/200)

    ---

Here is the above example rendered to HTML:

<style>
#h1_tag,#h2_tag,#h3_tag,#h4_tag,#h5_tag,#h6_tag{float:none;margin:0 0 10px;padding:0;}
</style>

---
<!--
    Three or more hyphens on their own line make a horizontal rule.
    Comments use normal HTML syntax.
-->

# H1 tag
## H2 tag
### H3 tag
#### H4 tag
##### H5 tag
###### H6 tag

**bold text**

_italic text_

- use hyphens
- to denote
- an unordered list

1. or numerals
2. to denote
3. an ordered list
3. note that the actual numbers used do not correlate to the
   numbers that will be displayed.

separate multiple paragraphs

with two new lines.
single new lines will be ignored;
all the text will flow together.

[link text in square braces](http://urls.in/parenthesis/immediately/following)

[links can also point to](#ids_on_a_page)

![images are links preceded by an exclamation point](http://placekitten.com/400/200)

---

##### [**Next**: Producing an Event &raquo;](/userguide/events)
##### [&laquo; **Previous**: Getting Started](/userguide/getting-started)
