/*
 * jQuery UI Effects Fold 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Fold
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(w){w.effects.fold=function(u){return this.queue(function(){var e=w(this),t=["position","top","bottom","left","right"],i=w.effects.setMode(e,u.options.mode||"hide"),o=u.options.size||15,s=!!u.options.horizFirst,h=u.duration?u.duration/2:w.fx.speeds._default/2;w.effects.save(e,t),e.show();var n=w.effects.createWrapper(e).css({overflow:"hidden"}),a="view"==i!=s,f=a?["width","height"]:["height","width"],r=a?[n.width(),n.height()]:[n.height(),n.width()],d=/([0-9]+)%/.exec(o);d&&(o=parseInt(d[1],10)/100*r["hide"==i?0:1]),"view"==i&&n.css(s?{height:0,width:o}:{height:o,width:0});var c={},p={};c[f[0]]="view"==i?r[0]:o,p[f[1]]="view"==i?r[1]:0,n.animate(c,h,u.options.easing).animate(p,h,u.options.easing,function(){"hide"==i&&e.hide(),w.effects.restore(e,t),w.effects.removeWrapper(e),u.callback&&u.callback.apply(e[0],arguments),e.dequeue()})})}}(jQuery);