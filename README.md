# Datajam

A real-time, data-driven platform for reporting live events on the Web.

* Homepage at [Datajam.org](http://datajam.org) *(coming soon)*
* Stories at [Pivotal Tracker](https://www.pivotaltracker.com/projects/226205)

## Product Goals

1. A platform for reporting live events, with a focus on displaying data and information in accessible ways.
2. Function as a live CMS. Dynamically populate content areas on an event page for the viewers.
3. Establish events as core functionality. A public-facing page on Datajam corresponds to an event. Events are created, produced, and ultimately archived.
4. Embed events on third-party sites.
5. Comprehensively track metrics for events.

## Dependencies and Installation

Datajam is a Rails 3.0 app. It depends on [Ruby](http://ruby-lang.org), [RVM](http://rvm.beginrescueend.com), and [MongoDB](http://mongodb.org).

After those external dependencies are installed, the app can be installed with:

    $ rvm use 1.9.2
    $ gem install bundler
    $ git clone https://github.com/sunlightlabs/datajam.git
    $ cd datajam/
    $ bundle install --binstubs
    $ bin/rails start

## Third-Party Libraries

Bundler takes care of installing all the other Ruby libraries used by Datajam, and the JS libraries are included in the project. But it's still important to know about them:

* JavaScript
  * [jQuery](http://jquery.com/) for DOM manipulation and XHR
  * [Underscore.js](http://documentcloud.github.com/underscore/) for its helper utilities
  * [Backbone.js](http://documentcloud.github.com/backbone/) for client-side MVC
  * [Jasmine](https://github.com/pivotal/jasmine) for client-side unit testing
  * [Protovis](http://vis.stanford.edu/protovis/) to generate visualizations
* Testing:
  * [RSpec](http://rspec.info/) for unit and functional tests
  * [RR](https://github.com/btakita/rr) for test doubles
  * [Capybara](https://github.com/jnicklas/capybara) to simulate the browser
  * [Akephalos](https://github.com/bernerdschaefer/akephalos) for an interface with a headless browser
* Persistence:
  * [Mongoid](http://mongoid.org) as an object mapper to MongoDB
* Deployment:
  * [Jammit](http://documentcloud.github.com/jammit/) for static asset packaging
* Documentation:
  * [Rocco](https://github.com/rtomayko/rocco) for literate programming

## Development Guidelines

Datajam is intended to be reused and extended by third parties. As such, certain development guidelines are strictly enforced:

* Unit test coverage for all files in `/app/models` and `/lib` with RSpec.
* Unit test coverage for all non-DOM, non-IO JavaScript with Jasmine.
* Acceptance test coverage for all user stories with Capybara.
* A best effort at JavaScript integration testing with Capybara and Akephalos.
* All new source files produced (`.rb` and `.js`) follow literate programming via Rocco.

## Product Architecture

Datajam consists of three pieces:

1. Front-end: Public-facing part of the app. Presents a view of the event as defined by the back-end. The home page displays the current event (or a message announcing the current event). Alternate views of the current event are available to third parties via the embed mechanism. Archive pages display past events.
2. Back-end: Administrative area that reporters use. Includes the interface for creating and editing events. Powers the front-end by defining templates for the event views.
3. Content Plugins: Define a data model and provide UI elements for the back-end and front-end. Both the back-end and front-end are architected to provide hooks for the plugins. Content plugins define specific implementations of content areas for the front-end, and administrative functionality in the back-end.

## Custom Content Plugins

Datajam ships with three content plugins: Data Card, Live Chat, and Tweet Stream, which are implemented through [Rails Engines](http://api.rubyonrails.org/classes/Rails/Engine.html). Custom plugin development is possible via hooks provided by Datajam.

More documentation coming soon.

## Deploying on Heroku

*Note: Not currently functional.*

1. Fork the project on [GitHub](https://github.com/sunlightlabs/datajam)
2. Create a `/config/settings.yml` based off of `/config/settings.yml.example`
3. Sign up on [Heroku](http://heroku.com)
4. Follow steps 1-4 of Heroku's [quickstart instructions](http://docs.heroku.com/quickstart)
5. Set up the [MongoHQ](http://docs.heroku.com/mongohq) add-on

## License

Copyright (c) 2011 by the Sunlight Foundation.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

