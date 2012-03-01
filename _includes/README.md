## Overview


---

## Installation

Datajam is a Ruby on Rails application designed with Heroku in mind. It can be
deployed to any Rack environment, but it's easiest to get started with
Heroku. 

We'll assume you have, at a minimum, a computer with **Ruby/Rubygems** 
and **Git** installed. You'll need more packages to run the code locally, but 
these two are enough to get started deploying. Shell examples in the steps 
below will be for UNIX environments, but Datajam should run just fine on 
Windows as well.

1. **Create an account**
    
    You'll need a free Heroku account to get started. Sign up at 
    <https://api.heroku.com/signup>.
    
    Confirm your account and take a look at Heroku's 
    [Quickstart Guide](http://devcenter.heroku.com/articles/quickstart) to get 
    setup with their toolbelt.

2. **Get the code**
    
    Create a new directory where you'd like the code to be stored (we'll put 
    ours in heroku-apps/datajam), and change into it:
    
    `mkdir ~/heroku-apps && cd ~/heroku-apps`
    
    Get a fresh clone of the source by running:
    
    `git clone https://github.com/sunlightlabs/datajam.git && cd datajam`

3. **Initialize the app**
    
    If you've installed the Heroku Toolbelt correctly, you have global access
    to the `heroku` command. Log in to your heroku account from the command 
    line if you've logged out since following the quickstart steps and create 
    a new app in the repo folder of your fresh git clone with heroku's 
    `create` command. By default, heroku will assign your application a random 
    two-word-number name such as 'sighing-lobster-4453' or 
    'catastrophic-bubblegum-2345,' and this will be the subdomain by which you
    access your app (ex: sighing-lobster-4453.herokuapp.com). You can choose
    to rename your app later, but it's simplest to provide a slug when you 
    first create the application. We also want to ensure that the newer Cedar
    stack gets used instead of the older Bamboo. So, the whole command will 
    look like: 
    
    `heroku create --stack cedar <your username>-<your site>`,
        
    where the last argument is the name you'd like the application to have

4. **Install dependencies**
    
    Datajam requires a few extra bits of tech in addition to the default Cedar
    stack, and on Heroku these come supplied in the form of Add-ons. We'll be 
    using their free versions to get started, but a 'verified account' (credit 
    card on file) is required first. Fill in your details at 
    <https://heroku.com/confirm>, and then run:
    
        heroku addons:add mongolab && 
        heroku addons:add redistogo && 
        heroku addons:add scheduler &&
        heroku addons:add sendgrid
    
    It's possible that you'll see an error message telling you that sendgrid 
    failed to install. If so, just go to your app's addons page from the 
    Heroku control panel and add it via the Web UI.

5. **Push the code**
    
    Congrats, this is the last step! Run 
    
    `git push heroku master && heroku run rake db:seed`
    
    To push your code live and install the default data. When it's all done,
    you're ready to start producing events! 
    
    You can visit your site at your-app-name.herokuapp.com, or login at
    your-app-name.herokuapp.com/admin, with the following credentials 
    (which you should obviously change):
    
    * **Email:** changeme@example.com
    * **Password:** changeme


---

## Templates

A Datajam Event is managed by publishing an event page compiled from several
templates and interactive widgets. The templates define content areas which 
can be updated in real time by event producers. There are 4 types of templates
which you'll need to create to run an event: A **Site Template**, **Event Templates**, **Embed Templates** and **Content Areas**.

### A Quick Primer on Template Tags
{% literal %}

Datajam uses Handlebars.js to render all user-editable templates. Our syntax
is really just a small subset, as there are no model-bound variables available 
to you when rendering. So, the only tags you'll need to use are:

* **Asset Tags**: `{{{ head_assets }}}`
* **Custom Fields**: `{{ my_custom_field }}`
* **Content Areas**: `{{ content_area: My Content Area }}`

### Template Types

1. **Site Template**
    
    Datajam sites have one -- and only one -- site template. By default a
    very simple template is created when you install Datajam. The site 
    template is the wrapper for all of your Datajam site's pages. It can 
    include links to assets, scripts, stylesheets -- anything in the realm of
    static HTML pages is fine, with the only caveat being that it must include
    3 tags in order for things to work properly: 
        
        * `{{{ head_assets }}}` - Stylesheets needed by Datajam & plugins
        * `{{{ content }}}` - Your page content
        * `{{{ body_assets }}}` - Scripts needed by Datajam & plugins
    
    Note that these tags are surrounded by 3 curly braces. This is important
    because it ensures the text won't be HTML-escaped.

2. **Event Templates**

    Event templates are reusable pages for rendering different types of 
    events. You may have, for example, a template that includes just a 
    video area and content bubble for providing annotations in time
    with a live video, or one that includes only video and chat. Each
    unique configuration of your event broadcast should have its
    own template, because changes to an event template will reflect in 
    all events -- past or present -- that use it.
    
    Event templates implement the remaining two handlebars tags that we
    saw earlier. Custom fields are holes in your template into which you
    can put unique text for each event. You may have a custom field 
    `{{ heading }}` which displays the title of the event at the top of the
    page, or even a custom field `{{ google_analytics_id }}` which you might 
    fill out with a different account number from one event to the next.
    Custom fields can use either two or three curly braces, depending on 
    whether or not you need html escaping.

3. **Embed Templates**
    
    Embed Templates are 'whole-page' templates which wrap iframe content, such
    as data cards. These templates can include the `{{{ head_assets }}}` and 
    `{{{ body_assets }}}` tags, content areas, and also custom fields. If you
    define an embed template, it will be available in the drop-down list when
    you create your data cards.
    
    Embed templates designed for data cards should include a `data_card_area`
    tag.

4. **Content Areas**
    
    Content areas are template tags that allow you to manipulate their content
    during the event. The default content area is called `content_area`, and
    it simply represents a textarea that you can paste HTLM into. A video 
    embed would be one example of a plain content area.
    
    Plugins may implement their own types of content area with extra 
    functionality. Each type of content area maps to a distinct interface
    in on-air mode that an editor can use to manipulate its content.  
    
    `data_card_area` and `chat_area` are two examples of
    this -- a data card area provides a drop-down menu from which a producer
    can select a pre-prepared card to display, and a chat area provides
    a moderation panel for approving, rejecting and editing messages from
    users.
    
{% endliteral %}


---

## Producing an Event

Once you have a site template and at least one event template set up, you're
ready to create your first event. When you installed Datajam, a sample event
was created for you. It may be simplest to edit that one first. Clicking the
'Events' link in the header will take you to a list of the events you've 
created. Choose the event you'd like to edit (it should be the only one), and 
you'll be presented with a form that lets you edit the event's details, as
well as any custom fields defined in the template you've selected. Change the
template, and if it has different fields, you'll see a different form.

The 'scheduled at' field will parse natural language dates, so instead of
hunting around a calendar for the date you want, you can just type something
like 'next tuesday at 8:00 pm' and it will do its best to figure out what you
mean.

### On-Air Editing

Save your event and click the 'live site' link in the upper right corner, and
you should see your new event all ready to go. At the top of the page you'll 
see a black toolbar with the text 'On Air,' and all of the content areas from 
your event template. You're looking at the same page your viewers will see, 
and to manipulate its content, just choose one of the content areas from that
toolbar.

If you haven't made any changes to your default event template, 'Video Embed' 
will be the only content area. Type in 'Hello, World!' and click update. 
Within 3 seconds, your text will appear. It's that simple!


---

## Extending Datajam with Plugins

There is quite a bit of customization that can be achieved just by editing
your site and event templates, but for times when server-side processing or
new URL endpoints are necessary, Datajam can be extended with plugins. Plugins
are Rails 3 engines that add functionality to your Datajam site. They can 
store settings, and even override or replace existing Datajam functionality.

### Installing plugins

Installing a plugin is easy -- just add it to your `Gemfile` and re-deploy 
your site. You can see your plugins by clicking the 'Plugins' menu item in 
the admin, or by visiting /admin/plugins.

Each plugin should include instructions on its detail page -- for example, 
/admin/plugins/datajam\_chat -- and some plugins may include static files or 
settings that need to be initialized. If this is the case, the plugin's detail 
page will include an 'install' link at the top. Once installed, there may also 
be links for other administrative tasks the plugin is capable of performing.

### Creating Your Own

Currently, [chat](http://github.com/sunlightlabs/datajam-chat) is the only 
available plugin, but you're free to create your own, and we'll be adding
new ones as development continues. You can read more about plugin authoring [here](/plugins/).


---

## Contributing

If you've got an idea for Datajam, we'd love to hear from you. You can
[fork the code on github](https://github.com/sunlightlabs/datajam/) or
[open an issue](https://github.com/sunlightlabs/datajam/issues/) to
request a feature or report a bug. The README file gives a great overview of 
how to get up and running with a local instance, and what technologies
we're using in the project.

### Get Involved in Open Government!

If you like Datajam and want to get involved in the Open Government community,
please subscribe to the Sunlight Labs 
[Google group](http://groups.google.com/group/sunlightlabs)! 
We've got a great group of civic hackers and data enthusiasts and a pretty 
reasonable message volume.

These are other ways to get involved...
