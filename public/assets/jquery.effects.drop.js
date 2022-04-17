/*
 * jQuery UI Effects Drop 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Drop
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(r){r.effects.drop=function(c){return this.queue(function(){var e=r(this),t=["position","top","bottom","left","right","opacity"],o=r.effects.setMode(e,c.options.mode||"hide"),i=c.options.direction||"left";r.effects.save(e,t),e.show(),r.effects.createWrapper(e);var s="up"==i||"down"==i?"top":"left",n="up"==i||"left"==i?"pos":"neg",p=c.options.distance||("top"==s?e.outerHeight({margin:!0})/2:e.outerWidth({margin:!0})/2);"view"==o&&e.css("opacity",0).css(s,"pos"==n?-p:p);var a={opacity:"view"==o?1:0};a[s]=("view"==o?"pos"==n?"+=":"-=":"pos"==n?"-=":"+=")+p,e.animate(a,{queue:!1,duration:c.duration,easing:c.options.easing,complete:function(){"hide"==o&&e.hide(),r.effects.restore(e,t),r.effects.removeWrapper(e),c.callback&&c.callback.apply(this,arguments),e.dequeue()}})})}}(jQuery);