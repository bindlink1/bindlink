/*
 * jQuery UI Effects Explode 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Explode
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(l){l.effects.explode=function(d){return this.queue(function(){var o=d.options.pieces?Math.round(Math.sqrt(d.options.pieces)):3,i=d.options.pieces?Math.round(Math.sqrt(d.options.pieces)):3;d.options.mode="toggle"==d.options.mode?l(this).is(":visible")?"hide":"view":d.options.mode;var e=l(this).show().css("visibility","hidden"),t=e.offset();t.top-=parseInt(e.css("marginTop"),10)||0,t.left-=parseInt(e.css("marginLeft"),10)||0;for(var s=e.outerWidth(!0),p=e.outerHeight(!0),n=0;n<o;n++)for(var a=0;a<i;a++)e.clone().appendTo("body").wrap("<div></div>").css({position:"absolute",visibility:"visible",left:s/i*-a,top:p/o*-n}).parent().addClass("ui-effects-explode").css({position:"absolute",overflow:"hidden",width:s/i,height:p/o,left:t.left+a*(s/i)+("view"==d.options.mode?(a-Math.floor(i/2))*(s/i):0),top:t.top+n*(p/o)+("view"==d.options.mode?(n-Math.floor(o/2))*(p/o):0),opacity:"view"==d.options.mode?0:1}).animate({left:t.left+a*(s/i)+("view"==d.options.mode?0:(a-Math.floor(i/2))*(s/i)),top:t.top+n*(p/o)+("view"==d.options.mode?0:(n-Math.floor(o/2))*(p/o)),opacity:"view"==d.options.mode?1:0},d.duration||500);setTimeout(function(){"view"==d.options.mode?e.css({visibility:"visible"}):e.css({visibility:"visible"}).hide(),d.callback&&d.callback.apply(e[0]),e.dequeue(),l("div.ui-effects-explode").remove()},d.duration||500)})}}(jQuery);