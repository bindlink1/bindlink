/*
 * jQuery UI Effects Scale 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Effects/Scale
 *
 * Depends:
 *	jquery.effects.core.js
 */
!function(g){g.effects.puff=function(f){return this.queue(function(){var t=g(this),o=g.effects.setMode(t,f.options.mode||"hide"),e=parseInt(f.options.percent,10)||150,i=e/100,h={height:t.height(),width:t.width()};g.extend(f.options,{fade:!0,mode:o,percent:"hide"==o?e:100,from:"hide"==o?h:{height:h.height*i,width:h.width*i}}),t.effect("scale",f.options,f.duration,f.callback),t.dequeue()})},g.effects.scale=function(c){return this.queue(function(){var t=g(this),o=g.extend(!0,{},c.options),e=g.effects.setMode(t,c.options.mode||"effect"),i=parseInt(c.options.percent,10)||(0==parseInt(c.options.percent,10)?0:"hide"==e?0:100),h=c.options.direction||"both",f=c.options.origin;"effect"!=e&&(o.origin=f||["middle","center"],o.restore=!0);var r={height:t.height(),width:t.width()};t.from=c.options.from||("view"==e?{height:0,width:0}:r);var n={y:"horizontal"!=h?i/100:1,x:"vertical"!=h?i/100:1};t.to={height:r.height*n.y,width:r.width*n.x},c.options.fade&&("view"==e&&(t.from.opacity=0,t.to.opacity=1),"hide"==e&&(t.from.opacity=1,t.to.opacity=0)),o.from=t.from,o.to=t.to,o.mode=e,t.effect("size",o,c.duration,c.callback),t.dequeue()})},g.effects.size=function(l){return this.queue(function(){var t=g(this),o=["position","top","bottom","left","right","width","height","overflow","opacity"],e=["position","top","bottom","left","right","overflow","opacity"],i=["width","height","overflow"],h=["fontSize"],f=["borderTopWidth","borderBottomWidth","paddingTop","paddingBottom"],r=["borderLeftWidth","borderRightWidth","paddingLeft","paddingRight"],n=g.effects.setMode(t,l.options.mode||"effect"),c=l.options.restore||!1,s=l.options.scale||"both",d=l.options.origin,a={height:t.height(),width:t.width()};if(t.from=l.options.from||a,t.to=l.options.to||a,d){var m=g.effects.getBaseline(d,a);t.from.top=(a.height-t.from.height)*m.y,t.from.left=(a.width-t.from.width)*m.x,t.to.top=(a.height-t.to.height)*m.y,t.to.left=(a.width-t.to.width)*m.x}var p={from:{y:t.from.height/a.height,x:t.from.width/a.width},to:{y:t.to.height/a.height,x:t.to.width/a.width}};"box"!=s&&"both"!=s||(p.from.y!=p.to.y&&(o=o.concat(f),t.from=g.effects.setTransition(t,f,p.from.y,t.from),t.to=g.effects.setTransition(t,f,p.to.y,t.to)),p.from.x!=p.to.x&&(o=o.concat(r),t.from=g.effects.setTransition(t,r,p.from.x,t.from),t.to=g.effects.setTransition(t,r,p.to.x,t.to))),"content"!=s&&"both"!=s||p.from.y!=p.to.y&&(o=o.concat(h),t.from=g.effects.setTransition(t,h,p.from.y,t.from),t.to=g.effects.setTransition(t,h,p.to.y,t.to)),g.effects.save(t,c?o:e),t.show(),g.effects.createWrapper(t),t.css("overflow","hidden").css(t.from),"content"!=s&&"both"!=s||(f=f.concat(["marginTop","marginBottom"]).concat(h),r=r.concat(["marginLeft","marginRight"]),i=o.concat(f).concat(r),t.find("*[width]").each(function(){child=g(this),c&&g.effects.save(child,i);var t={height:child.height(),width:child.width()};child.from={height:t.height*p.from.y,width:t.width*p.from.x},child.to={height:t.height*p.to.y,width:t.width*p.to.x},p.from.y!=p.to.y&&(child.from=g.effects.setTransition(child,f,p.from.y,child.from),child.to=g.effects.setTransition(child,f,p.to.y,child.to)),p.from.x!=p.to.x&&(child.from=g.effects.setTransition(child,r,p.from.x,child.from),child.to=g.effects.setTransition(child,r,p.to.x,child.to)),child.css(child.from),child.animate(child.to,l.duration,l.options.easing,function(){c&&g.effects.restore(child,i)})})),t.animate(t.to,{queue:!1,duration:l.duration,easing:l.options.easing,complete:function(){0===t.to.opacity&&t.css("opacity",t.from.opacity),"hide"==n&&t.hide(),g.effects.restore(t,c?o:e),g.effects.removeWrapper(t),l.callback&&l.callback.apply(this,arguments),t.dequeue()}})})}}(jQuery);