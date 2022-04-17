/*
 * jQuery UI Effects Clip 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Clip
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(h){h.effects.clip=function(f){return this.queue(function(){var e=h(this),i=["position","top","bottom","left","right","height","width"],t=h.effects.setMode(e,f.options.mode||"hide"),o=f.options.direction||"vertical";h.effects.save(e,i),e.show();var s=h.effects.createWrapper(e).css({overflow:"hidden"}),c="IMG"==e[0].tagName?s:e,a={size:"vertical"==o?"height":"width",position:"vertical"==o?"top":"left"},n="vertical"==o?c.height():c.width();"view"==t&&(c.css(a.size,0),c.css(a.position,n/2));var r={};r[a.size]="view"==t?n:0,r[a.position]="view"==t?0:n/2,c.animate(r,{queue:!1,duration:f.duration,easing:f.options.easing,complete:function(){"hide"==t&&e.hide(),h.effects.restore(e,i),h.effects.removeWrapper(e),f.callback&&f.callback.apply(e[0],arguments),e.dequeue()}})})}}(jQuery);