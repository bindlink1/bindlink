/*
 * jQuery UI Slider 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Slider
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
!function(r){var h=5;r.widget("ui.slider",r.ui.mouse,{widgetEventPrefix:"slide",options:{animate:!1,distance:0,max:100,min:0,orientation:"horizontal",range:!1,step:1,value:0,values:null},_create:function(){var n=this,e=this.options,i=this.element.find(".ui-slider-handle").addClass("ui-state-default ui-corner-all"),t="<a class='ui-slider-handle ui-state-default ui-corner-all' href='#'></a>",s=e.values&&e.values.length||1,a=[];this._keySliding=!1,this._mouseSliding=!1,this._animateOff=!0,this._handleIndex=null,this._detectOrientation(),this._mouseInit(),this.element.addClass("ui-slider ui-slider-"+this.orientation+" ui-widget ui-widget-content ui-corner-all"+(e.disabled?" ui-slider-disabled ui-disabled":"")),this.range=r([]),e.range&&(!0===e.range&&(e.values||(e.values=[this._valueMin(),this._valueMin()]),e.values.length&&2!==e.values.length&&(e.values=[e.values[0],e.values[0]])),this.range=r("<div></div>").appendTo(this.element).addClass("ui-slider-range ui-widget-header"+("min"===e.range||"max"===e.range?" ui-slider-range-"+e.range:"")));for(var l=i.length;l<s;l+=1)a.push(t);this.handles=i.add(r(a.join("")).appendTo(n.element)),this.handle=this.handles.eq(0),this.handles.add(this.range).filter("a").click(function(e){e.preventDefault()}).hover(function(){e.disabled||r(this).addClass("ui-state-hover")},function(){r(this).removeClass("ui-state-hover")}).focus(function(){e.disabled?r(this).blur():(r(".ui-slider .ui-state-focus").removeClass("ui-state-focus"),r(this).addClass("ui-state-focus"))}).blur(function(){r(this).removeClass("ui-state-focus")}),this.handles.each(function(e){r(this).data("index.ui-slider-handle",e)}),this.handles.keydown(function(e){var i,t,s,a=r(this).data("index.ui-slider-handle");if(!n.options.disabled){switch(e.keyCode){case r.ui.keyCode.HOME:case r.ui.keyCode.END:case r.ui.keyCode.PAGE_UP:case r.ui.keyCode.PAGE_DOWN:case r.ui.keyCode.UP:case r.ui.keyCode.RIGHT:case r.ui.keyCode.DOWN:case r.ui.keyCode.LEFT:if(e.preventDefault(),!n._keySliding&&(n._keySliding=!0,r(this).addClass("ui-state-active"),!1===n._start(e,a)))return}switch(s=n.options.step,i=t=n.options.values&&n.options.values.length?n.values(a):n.value(),e.keyCode){case r.ui.keyCode.HOME:t=n._valueMin();break;case r.ui.keyCode.END:t=n._valueMax();break;case r.ui.keyCode.PAGE_UP:t=n._trimAlignValue(i+(n._valueMax()-n._valueMin())/h);break;case r.ui.keyCode.PAGE_DOWN:t=n._trimAlignValue(i-(n._valueMax()-n._valueMin())/h);break;case r.ui.keyCode.UP:case r.ui.keyCode.RIGHT:if(i===n._valueMax())return;t=n._trimAlignValue(i+s);break;case r.ui.keyCode.DOWN:case r.ui.keyCode.LEFT:if(i===n._valueMin())return;t=n._trimAlignValue(i-s)}n._slide(e,a,t)}}).keyup(function(e){var i=r(this).data("index.ui-slider-handle");n._keySliding&&(n._keySliding=!1,n._stop(e,i),n._change(e,i),r(this).removeClass("ui-state-active"))}),this._refreshValue(),this._animateOff=!1},destroy:function(){return this.handles.remove(),this.range.remove(),this.element.removeClass("ui-slider ui-slider-horizontal ui-slider-vertical ui-slider-disabled ui-widget ui-widget-content ui-corner-all").removeData("slider").unbind(".slider"),this._mouseDestroy(),this},_mouseCapture:function(e){var i,t,s,a,n,l,h,u,o=this.options;return!o.disabled&&(this.elementSize={width:this.element.outerWidth(),height:this.element.outerHeight()},this.elementOffset=this.element.offset(),i={x:e.pageX,y:e.pageY},t=this._normValueFromMouse(i),s=this._valueMax()-this._valueMin()+1,(n=this).handles.each(function(e){var i=Math.abs(t-n.values(e));i<s&&(s=i,a=r(this),l=e)}),!0===o.range&&this.values(1)===o.min&&(l+=1,a=r(this.handles[l])),!1!==this._start(e,l)&&(this._mouseSliding=!0,n._handleIndex=l,a.addClass("ui-state-active").focus(),h=a.offset(),u=!r(e.target).parents().andSelf().is(".ui-slider-handle"),this._clickOffset=u?{left:0,top:0}:{left:e.pageX-h.left-a.width()/2,top:e.pageY-h.top-a.height()/2-(parseInt(a.css("borderTopWidth"),10)||0)-(parseInt(a.css("borderBottomWidth"),10)||0)+(parseInt(a.css("marginTop"),10)||0)},this.handles.hasClass("ui-state-hover")||this._slide(e,l,t),this._animateOff=!0))},_mouseStart:function(){return!0},_mouseDrag:function(e){var i={x:e.pageX,y:e.pageY},t=this._normValueFromMouse(i);return this._slide(e,this._handleIndex,t),!1},_mouseStop:function(e){return this.handles.removeClass("ui-state-active"),this._mouseSliding=!1,this._stop(e,this._handleIndex),this._change(e,this._handleIndex),this._handleIndex=null,this._clickOffset=null,this._animateOff=!1},_detectOrientation:function(){this.orientation="vertical"===this.options.orientation?"vertical":"horizontal"},_normValueFromMouse:function(e){var i,t,s,a;return 1<(t=("horizontal"===this.orientation?(i=this.elementSize.width,e.x-this.elementOffset.left-(this._clickOffset?this._clickOffset.left:0)):(i=this.elementSize.height,e.y-this.elementOffset.top-(this._clickOffset?this._clickOffset.top:0)))/i)&&(t=1),t<0&&(t=0),"vertical"===this.orientation&&(t=1-t),s=this._valueMax()-this._valueMin(),a=this._valueMin()+t*s,this._trimAlignValue(a)},_start:function(e,i){var t={handle:this.handles[i],value:this.value()};return this.options.values&&this.options.values.length&&(t.value=this.values(i),t.values=this.values()),this._trigger("start",e,t)},_slide:function(e,i,t){var s,a,n;this.options.values&&this.options.values.length?(s=this.values(i?0:1),2===this.options.values.length&&!0===this.options.range&&(0===i&&s<t||1===i&&t<s)&&(t=s),t!==this.values(i)&&((a=this.values())[i]=t,n=this._trigger("slide",e,{handle:this.handles[i],value:t,values:a}),s=this.values(i?0:1),!1!==n&&this.values(i,t,!0))):t!==this.value()&&!1!==(n=this._trigger("slide",e,{handle:this.handles[i],value:t}))&&this.value(t)},_stop:function(e,i){var t={handle:this.handles[i],value:this.value()};this.options.values&&this.options.values.length&&(t.value=this.values(i),t.values=this.values()),this._trigger("stop",e,t)},_change:function(e,i){if(!this._keySliding&&!this._mouseSliding){var t={handle:this.handles[i],value:this.value()};this.options.values&&this.options.values.length&&(t.value=this.values(i),t.values=this.values()),this._trigger("change",e,t)}},value:function(e){return arguments.length?(this.options.value=this._trimAlignValue(e),this._refreshValue(),void this._change(null,0)):this._value()},values:function(e,i){var t,s,a;if(1<arguments.length)return this.options.values[e]=this._trimAlignValue(i),this._refreshValue(),void this._change(null,e);if(!arguments.length)return this._values();if(!r.isArray(e))return this.options.values&&this.options.values.length?this._values(e):this.value();for(t=this.options.values,s=e,a=0;a<t.length;a+=1)t[a]=this._trimAlignValue(s[a]),this._change(null,a);this._refreshValue()},_setOption:function(e,i){var t,s=0;switch(r.isArray(this.options.values)&&(s=this.options.values.length),r.Widget.prototype._setOption.apply(this,arguments),e){case"disabled":i?(this.handles.filter(".ui-state-focus").blur(),this.handles.removeClass("ui-state-hover"),this.handles.propAttr("disabled",!0),this.element.addClass("ui-disabled")):(this.handles.propAttr("disabled",!1),this.element.removeClass("ui-disabled"));break;case"orientation":this._detectOrientation(),this.element.removeClass("ui-slider-horizontal ui-slider-vertical").addClass("ui-slider-"+this.orientation),this._refreshValue();break;case"value":this._animateOff=!0,this._refreshValue(),this._change(null,0),this._animateOff=!1;break;case"values":for(this._animateOff=!0,this._refreshValue(),t=0;t<s;t+=1)this._change(null,t);this._animateOff=!1}},_value:function(){var e=this.options.value;return e=this._trimAlignValue(e)},_values:function(e){var i,t,s;if(arguments.length)return i=this.options.values[e],i=this._trimAlignValue(i);for(t=this.options.values.slice(),s=0;s<t.length;s+=1)t[s]=this._trimAlignValue(t[s]);return t},_trimAlignValue:function(e){if(e<=this._valueMin())return this._valueMin();if(e>=this._valueMax())return this._valueMax();var i=0<this.options.step?this.options.step:1,t=(e-this._valueMin())%i,s=e-t;return 2*Math.abs(t)>=i&&(s+=0<t?i:-i),parseFloat(s.toFixed(5))},_valueMin:function(){return this.options.min},_valueMax:function(){return this.options.max},_refreshValue:function(){var i,t,e,s,a,n=this.options.range,l=this.options,h=this,u=!this._animateOff&&l.animate,o={};this.options.values&&this.options.values.length?this.handles.each(function(e){i=(h.values(e)-h._valueMin())/(h._valueMax()-h._valueMin())*100,o["horizontal"===h.orientation?"left":"bottom"]=i+"%",r(this).stop(1,1)[u?"animate":"css"](o,l.animate),!0===h.options.range&&("horizontal"===h.orientation?(0===e&&h.range.stop(1,1)[u?"animate":"css"]({left:i+"%"},l.animate),1===e&&h.range[u?"animate":"css"]({width:i-t+"%"},{queue:!1,duration:l.animate})):(0===e&&h.range.stop(1,1)[u?"animate":"css"]({bottom:i+"%"},l.animate),1===e&&h.range[u?"animate":"css"]({height:i-t+"%"},{queue:!1,duration:l.animate}))),t=i}):(e=this.value(),s=this._valueMin(),a=this._valueMax(),i=a!==s?(e-s)/(a-s)*100:0,o["horizontal"===h.orientation?"left":"bottom"]=i+"%",this.handle.stop(1,1)[u?"animate":"css"](o,l.animate),"min"===n&&"horizontal"===this.orientation&&this.range.stop(1,1)[u?"animate":"css"]({width:i+"%"},l.animate),"max"===n&&"horizontal"===this.orientation&&this.range[u?"animate":"css"]({width:100-i+"%"},{queue:!1,duration:l.animate}),"min"===n&&"vertical"===this.orientation&&this.range.stop(1,1)[u?"animate":"css"]({height:i+"%"},l.animate),"max"===n&&"vertical"===this.orientation&&this.range[u?"animate":"css"]({height:100-i+"%"},{queue:!1,duration:l.animate}))}}),r.extend(r.ui.slider,{version:"1.8.18"})}(jQuery);