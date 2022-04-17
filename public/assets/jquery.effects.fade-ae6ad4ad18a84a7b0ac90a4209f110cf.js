/*
 * jQuery UI Effects Fade 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Fade
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(n){n.effects.fade=function(i){return this.queue(function(){var e=n(this),t=n.effects.setMode(e,i.options.mode||"hide");e.animate({opacity:t},{queue:!1,duration:i.duration,easing:i.options.easing,complete:function(){i.callback&&i.callback.apply(this,arguments),e.dequeue()}})})}}(jQuery);