/*
 * jQuery UI Effects Pulsate 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Pulsate
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(o){o.effects.pulsate=function(a){return this.queue(function(){var i=o(this),e=o.effects.setMode(i,a.options.mode||"view");times=2*(a.options.times||5)-1,duration=a.duration?a.duration/2:o.fx.speeds._default/2,isVisible=i.is(":visible"),animateTo=0,isVisible||(i.css("opacity",0).show(),animateTo=1),("hide"==e&&isVisible||"view"==e&&!isVisible)&&times--;for(var t=0;t<times;t++)i.animate({opacity:animateTo},duration,a.options.easing),animateTo=(animateTo+1)%2;i.animate({opacity:animateTo},duration,a.options.easing,function(){0==animateTo&&i.hide(),a.callback&&a.callback.apply(this,arguments)}),i.queue("fx",function(){i.dequeue()}).dequeue()})}}(jQuery);