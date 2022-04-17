/*
 * jQuery UI Effects Blind 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Blind
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(f){f.effects.blind=function(n){return this.queue(function(){var e=f(this),t=["position","top","bottom","left","right"],i=f.effects.setMode(e,n.options.mode||"hide"),o=n.options.direction||"vertical";f.effects.save(e,t),e.show();var c=f.effects.createWrapper(e).css({overflow:"hidden"}),r="vertical"==o?"height":"width",s="vertical"==o?c.height():c.width();"view"==i&&c.css(r,0);var a={};a[r]="view"==i?s:0,c.animate(a,n.duration,n.options.easing,function(){"hide"==i&&e.hide(),f.effects.restore(e,t),f.effects.removeWrapper(e),n.callback&&n.callback.apply(e[0],arguments),e.dequeue()})})}}(jQuery);