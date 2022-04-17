/*
 * jQuery UI Effects Slide 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Slide
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(p){p.effects.slide=function(f){return this.queue(function(){var e=p(this),t=["position","top","bottom","left","right"],o=p.effects.setMode(e,f.options.mode||"view"),i=f.options.direction||"left";p.effects.save(e,t),e.show(),p.effects.createWrapper(e).css({overflow:"hidden"});var s="up"==i||"down"==i?"top":"left",n="up"==i||"left"==i?"pos":"neg",r=f.options.distance||("top"==s?e.outerHeight({margin:!0}):e.outerWidth({margin:!0}));"view"==o&&e.css(s,"pos"==n?isNaN(r)?"-"+r:-r:r);var a={};a[s]=("view"==o?"pos"==n?"+=":"-=":"pos"==n?"-=":"+=")+r,e.animate(a,{queue:!1,duration:f.duration,easing:f.options.easing,complete:function(){"hide"==o&&e.hide(),p.effects.restore(e,t),p.effects.removeWrapper(e),f.callback&&f.callback.apply(this,arguments),e.dequeue()}})})}}(jQuery);