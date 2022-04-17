/*
 * jQuery UI Effects Shake 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Shake
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(l){l.effects.shake=function(d){return this.queue(function(){var e=l(this),t=["position","top","bottom","left","right"],o=(l.effects.setMode(e,d.options.mode||"effect"),d.options.direction||"left"),n=d.options.distance||20,i=d.options.times||3,s=d.duration||d.options.duration||140;l.effects.save(e,t),e.show(),l.effects.createWrapper(e);var a="up"==o||"down"==o?"top":"left",f="up"==o||"left"==o?"pos":"neg",p={},c={},r={};p[a]=("pos"==f?"-=":"+=")+n,c[a]=("pos"==f?"+=":"-=")+2*n,r[a]=("pos"==f?"-=":"+=")+2*n,e.animate(p,s,d.options.easing);for(var u=1;u<i;u++)e.animate(c,s,d.options.easing).animate(r,s,d.options.easing);e.animate(c,s,d.options.easing).animate(p,s/2,d.options.easing,function(){l.effects.restore(e,t),l.effects.removeWrapper(e),d.callback&&d.callback.apply(this,arguments)}),e.queue("fx",function(){e.dequeue()}),e.dequeue()})}}(jQuery);