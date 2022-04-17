/*
 * jQuery UI Effects Highlight 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Highlight
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(n){n.effects.highlight=function(c){return this.queue(function(){var e=n(this),o=["backgroundImage","backgroundColor","opacity"],t=n.effects.setMode(e,c.options.mode||"view"),i={backgroundColor:e.css("backgroundColor")};"hide"==t&&(i.opacity=0),n.effects.save(e,o),e.show().css({backgroundImage:"none",backgroundColor:c.options.color||"#ffff99"}).animate(i,{queue:!1,duration:c.duration,easing:c.options.easing,complete:function(){"hide"==t&&e.hide(),n.effects.restore(e,o),"view"==t&&!n.support.opacity&&this.style.removeAttribute("filter"),c.callback&&c.callback.apply(this,arguments),e.dequeue()}})})}}(jQuery);