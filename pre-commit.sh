#!/usr/bin/env sh
bundle exec rake build_javascripts
git add public/javascripts/application-compiled.js
git add public/javascripts/application-compiled.min.js