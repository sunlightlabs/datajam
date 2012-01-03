(function(define, require){
define(function(){return{load:function(c,d,a){function e(b){"function"==typeof a.resolve?a.resolve(b):a(b)}function f(b){"function"==typeof a.reject&&a.reject(b)}d([c],function(b){"function"==typeof b.then?b.then(function(a){0==arguments.length&&(a=b);e(a)},f):e(b)})},analyze:function(c,d,a){a(c)}}});
})(curl.define, curl);