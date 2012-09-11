/*
 RequireJS step 0.0.1 Copyright (c) 2012, The Dojo Foundation All Rights Reserved.
 Available via the MIT or new BSD license.
 see: http://github.com/requirejs/step for details
*/
define(["module"],function(l){var b,d;return{version:"0.0.1",load:function(e,i,j){if(!b){var a=l.config();b={};d=a.steps;for(var c,f,h,a=0;a<d.length&&!(f=d[a],!f);a+=1);for(c=0;c<f.length;c+=1){h=f[c];if(!h)break;b[h]=a}}if(b.hasOwnProperty(e)){var k=function(){g<m?i(d[g],function(){g+=1;k()}):i([e],j)},g=0,m=b[e];k()}else j.error(Error("No step config for ID: "+e))}}});