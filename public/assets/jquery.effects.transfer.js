/*
 * jQuery UI Effects Transfer 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Transfer
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(f){f.effects.transfer=function(a){return this.queue(function(){var t=f(this),e=f(a.options.to),i=e.offset(),n={top:i.top,left:i.left,height:e.innerHeight(),width:e.innerWidth()},o=t.offset(),s=f('<div class="ui-effects-transfer"></div>').appendTo(document.body).addClass(a.options.className).css({top:o.top,left:o.left,height:t.innerHeight(),width:t.innerWidth(),position:"absolute"}).animate(n,a.duration,a.options.easing,function(){s.remove(),a.callback&&a.callback.apply(t[0],arguments),t.dequeue()})})}}(jQuery);