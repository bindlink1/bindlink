/*
 * Lazy Load - jQuery plugin for lazy loading images
 *
 * Copyright (c) 2007-2012 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   http://www.appelsiini.net/projects/lazyload
 *
 * Version:  1.8.3
 *
 */
!function(f,n,e,l){var a=f(n);f.fn.lazyload=function(e){function t(){var t=0;i.each(function(){var e=f(this);if((!r.skip_invisible||e.is(":visible"))&&!f.abovethetop(this,r)&&!f.leftofbegin(this,r))if(f.belowthefold(this,r)||f.rightoffold(this,r)){if(++t>r.failure_limit)return!1}else e.trigger("appear"),t=0})}var o,i=this,r={threshold:0,failure_limit:0,event:"scroll",effect:"show",container:n,data_attribute:"original",skip_invisible:!0,appear:null,load:null};return e&&(l!==e.failurelimit&&(e.failure_limit=e.failurelimit,delete e.failurelimit),l!==e.effectspeed&&(e.effect_speed=e.effectspeed,delete e.effectspeed),f.extend(r,e)),o=r.container===l||r.container===n?a:f(r.container),0===r.event.indexOf("scroll")&&o.bind(r.event,function(){return t()}),this.each(function(){var o=this,n=f(o);o.loaded=!1,n.one("appear",function(){if(!this.loaded){if(r.appear){var e=i.length;r.appear.call(o,e,r)}f("<img />").bind("load",function(){n.hide().attr("src",n.data(r.data_attribute))[r.effect](r.effect_speed),o.loaded=!0;var e=f.grep(i,function(e){return!e.loaded});if(i=f(e),r.load){var t=i.length;r.load.call(o,t,r)}}).attr("src",n.data(r.data_attribute))}}),0!==r.event.indexOf("scroll")&&n.bind(r.event,function(){o.loaded||n.trigger("appear")})}),a.bind("resize",function(){t()}),/iphone|ipod|ipad.*os 5/gi.test(navigator.appVersion)&&a.bind("pageshow",function(e){e.originalEvent.persisted&&i.each(function(){f(this).trigger("appear")})}),f(n).load(function(){t()}),this},f.belowthefold=function(e,t){return(t.container===l||t.container===n?a.height()+a.scrollTop():f(t.container).offset().top+f(t.container).height())<=f(e).offset().top-t.threshold},f.rightoffold=function(e,t){return(t.container===l||t.container===n?a.width()+a.scrollLeft():f(t.container).offset().left+f(t.container).width())<=f(e).offset().left-t.threshold},f.abovethetop=function(e,t){return(t.container===l||t.container===n?a.scrollTop():f(t.container).offset().top)>=f(e).offset().top+t.threshold+f(e).height()},f.leftofbegin=function(e,t){return(t.container===l||t.container===n?a.scrollLeft():f(t.container).offset().left)>=f(e).offset().left+t.threshold+f(e).width()},f.inviewport=function(e,t){return!(f.rightoffold(e,t)||f.leftofbegin(e,t)||f.belowthefold(e,t)||f.abovethetop(e,t))},f.extend(f.expr[":"],{"below-the-fold":function(e){return f.belowthefold(e,{threshold:0})},"above-the-top":function(e){return!f.belowthefold(e,{threshold:0})},"right-of-screen":function(e){return f.rightoffold(e,{threshold:0})},"left-of-screen":function(e){return!f.rightoffold(e,{threshold:0})},"in-viewport":function(e){return f.inviewport(e,{threshold:0})},"above-the-fold":function(e){return!f.belowthefold(e,{threshold:0})},"right-of-fold":function(e){return f.rightoffold(e,{threshold:0})},"left-of-fold":function(e){return!f.rightoffold(e,{threshold:0})}})}(jQuery,window,document);