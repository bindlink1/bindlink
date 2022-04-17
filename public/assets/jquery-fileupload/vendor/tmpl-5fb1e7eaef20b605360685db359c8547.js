/*
 * JavaScript Templates 2.1.0
 * https://github.com/blueimp/JavaScript-Templates
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 *
 * Inspired by John Resig's JavaScript Micro-Templating:
 * http://ejohn.org/blog/javascript-micro-templating/
 */
!function(e){"use strict";var r=function(e,n){var t=/[^\w\-\.:]/.test(e)?new Function(r.arg+",tmpl","var _e=tmpl.encode"+r.helper+",_s='"+e.replace(r.regexp,r.func)+"';return _s;"):r.cache[e]=r.cache[e]||r(r.load(e));return n?t(n,r):function(e){return t(e,r)}};r.cache={},r.load=function(e){return document.getElementById(e).innerHTML},r.regexp=/([\s'\\])(?![^%]*%\})|(?:\{%(=|#)([\s\S]+?)%\})|(\{%)|(%\})/g,r.func=function(e,n,t,r,c,u){return n?{"\n":"\\n","\r":"\\r","\t":"\\t"," ":" "}[e]||"\\"+e:t?"="===t?"'+_e("+r+")+'":"'+("+r+"||'')+'":c?"';":u?"_s+='":void 0},r.encReg=/[<>&"'\x00]/g,r.encMap={"<":"&lt;",">":"&gt;","&":"&amp;",'"':"&quot;","'":"&#39;"},r.encode=function(e){return String(e||"").replace(r.encReg,function(e){return r.encMap[e]||""})},r.arg="o",r.helper=",print=function(s,e){_s+=e&&(s||'')||_e(s);},include=function(s,d){_s+=tmpl(s,d);}","function"==typeof define&&define.amd?define(function(){return r}):e.tmpl=r}(this);