/*
 * jQuery UI Effects Bounce 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Bounce
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(l){l.effects.bounce=function(h){return this.queue(function(){var e=l(this),t=["position","top","bottom","left","right"],o=l.effects.setMode(e,h.options.mode||"effect"),i=h.options.direction||"up",s=h.options.distance||20,a=h.options.times||5,n=h.duration||250;/show|hide/.test(o)&&t.push("opacity"),l.effects.save(e,t),e.show(),l.effects.createWrapper(e);var p="up"==i||"down"==i?"top":"left",c="up"==i||"left"==i?"pos":"neg";s=h.options.distance||("top"==p?e.outerHeight({margin:!0})/3:e.outerWidth({margin:!0})/3);("view"==o&&e.css("opacity",0).css(p,"pos"==c?-s:s),"hide"==o&&(s/=2*a),"hide"!=o&&a--,"view"==o)&&((u={opacity:1})[p]=("pos"==c?"+=":"-=")+s,e.animate(u,n/2,h.options.easing),s/=2,a--);for(var f=0;f<a;f++){var r={};(d={})[p]=("pos"==c?"-=":"+=")+s,r[p]=("pos"==c?"+=":"-=")+s,e.animate(d,n/2,h.options.easing).animate(r,n/2,h.options.easing),s="hide"==o?2*s:s/2}if("hide"==o){var u;(u={opacity:0})[p]=("pos"==c?"-=":"+=")+s,e.animate(u,n/2,h.options.easing,function(){e.hide(),l.effects.restore(e,t),l.effects.removeWrapper(e),h.callback&&h.callback.apply(this,arguments)})}else{var d;r={};(d={})[p]=("pos"==c?"-=":"+=")+s,r[p]=("pos"==c?"+=":"-=")+s,e.animate(d,n/2,h.options.easing).animate(r,n/2,h.options.easing,function(){l.effects.restore(e,t),l.effects.removeWrapper(e),h.callback&&h.callback.apply(this,arguments)})}e.queue("fx",function(){e.dequeue()}),e.dequeue()})}}(jQuery);