/*
 * jQuery UI Sortable 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Sortables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
!function(f){f.widget("ui.sortable",f.ui.mouse,{widgetEventPrefix:"sort",ready:!1,options:{appendTo:"parent",axis:!1,connectWith:!1,containment:!1,cursor:"auto",cursorAt:!1,dropOnEmpty:!0,forcePlaceholderSize:!1,forceHelperSize:!1,grid:!1,handle:!1,helper:"original",items:"> *",opacity:!1,placeholder:!1,revert:!1,scroll:!0,scrollSensitivity:20,scrollSpeed:20,scope:"default",tolerance:"intersect",zIndex:1e3},_create:function(){var t=this.options;this.containerCache={},this.element.addClass("ui-sortable"),this.refresh(),this.floating=!!this.items.length&&("x"===t.axis||/left|right/.test(this.items[0].item.css("float"))||/inline|table-cell/.test(this.items[0].item.css("display"))),this.offset=this.element.offset(),this._mouseInit(),this.ready=!0},destroy:function(){f.Widget.prototype.destroy.call(this),this.element.removeClass("ui-sortable ui-sortable-disabled"),this._mouseDestroy();for(var t=this.items.length-1;0<=t;t--)this.items[t].item.removeData(this.widgetName+"-item");return this},_setOption:function(t,e){"disabled"===t?(this.options[t]=e,this.widget()[e?"addClass":"removeClass"]("ui-sortable-disabled")):f.Widget.prototype._setOption.apply(this,arguments)},_mouseCapture:function(t,e){var i=this;if(this.reverting)return!1;if(this.options.disabled||"static"==this.options.type)return!1;this._refreshItems(t);var s=null,o=this;f(t.target).parents().each(function(){if(f.data(this,i.widgetName+"-item")==o)return s=f(this),!1});if(f.data(t.target,i.widgetName+"-item")==o&&(s=f(t.target)),!s)return!1;if(this.options.handle&&!e){var r=!1;if(f(this.options.handle,s).find("*").andSelf().each(function(){this==t.target&&(r=!0)}),!r)return!1}return this.currentItem=s,this._removeCurrentsFromItems(),!0},_mouseStart:function(t,e,i){var s=this.options,o=this;if((this.currentContainer=this).refreshPositions(),this.helper=this._createHelper(t),this._cacheHelperProportions(),this._cacheMargins(),this.scrollParent=this.helper.scrollParent(),this.offset=this.currentItem.offset(),this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-this.margins.left},this.helper.css("position","absolute"),this.cssPosition=this.helper.css("position"),f.extend(this.offset,{click:{left:t.pageX-this.offset.left,top:t.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()}),this.originalPosition=this._generatePosition(t),this.originalPageX=t.pageX,this.originalPageY=t.pageY,s.cursorAt&&this._adjustOffsetFromHelper(s.cursorAt),this.domPosition={prev:this.currentItem.prev()[0],parent:this.currentItem.parent()[0]},this.helper[0]!=this.currentItem[0]&&this.currentItem.hide(),this._createPlaceholder(),s.containment&&this._setContainment(),s.cursor&&(f("body").css("cursor")&&(this._storedCursor=f("body").css("cursor")),f("body").css("cursor",s.cursor)),s.opacity&&(this.helper.css("opacity")&&(this._storedOpacity=this.helper.css("opacity")),this.helper.css("opacity",s.opacity)),s.zIndex&&(this.helper.css("zIndex")&&(this._storedZIndex=this.helper.css("zIndex")),this.helper.css("zIndex",s.zIndex)),this.scrollParent[0]!=document&&"HTML"!=this.scrollParent[0].tagName&&(this.overflowOffset=this.scrollParent.offset()),this._trigger("start",t,this._uiHash()),this._preserveHelperProportions||this._cacheHelperProportions(),!i)for(var r=this.containers.length-1;0<=r;r--)this.containers[r]._trigger("activate",t,o._uiHash(this));return f.ui.ddmanager&&(f.ui.ddmanager.current=this),f.ui.ddmanager&&!s.dropBehaviour&&f.ui.ddmanager.prepareOffsets(this,t),this.dragging=!0,this.helper.addClass("ui-sortable-helper"),this._mouseDrag(t),!0},_mouseDrag:function(t){if(this.position=this._generatePosition(t),this.positionAbs=this._convertPositionTo("absolute"),this.lastPositionAbs||(this.lastPositionAbs=this.positionAbs),this.options.scroll){var e=this.options,i=!1;this.scrollParent[0]!=document&&"HTML"!=this.scrollParent[0].tagName?(this.overflowOffset.top+this.scrollParent[0].offsetHeight-t.pageY<e.scrollSensitivity?this.scrollParent[0].scrollTop=i=this.scrollParent[0].scrollTop+e.scrollSpeed:t.pageY-this.overflowOffset.top<e.scrollSensitivity&&(this.scrollParent[0].scrollTop=i=this.scrollParent[0].scrollTop-e.scrollSpeed),this.overflowOffset.left+this.scrollParent[0].offsetWidth-t.pageX<e.scrollSensitivity?this.scrollParent[0].scrollLeft=i=this.scrollParent[0].scrollLeft+e.scrollSpeed:t.pageX-this.overflowOffset.left<e.scrollSensitivity&&(this.scrollParent[0].scrollLeft=i=this.scrollParent[0].scrollLeft-e.scrollSpeed)):(t.pageY-f(document).scrollTop()<e.scrollSensitivity?i=f(document).scrollTop(f(document).scrollTop()-e.scrollSpeed):f(window).height()-(t.pageY-f(document).scrollTop())<e.scrollSensitivity&&(i=f(document).scrollTop(f(document).scrollTop()+e.scrollSpeed)),t.pageX-f(document).scrollLeft()<e.scrollSensitivity?i=f(document).scrollLeft(f(document).scrollLeft()-e.scrollSpeed):f(window).width()-(t.pageX-f(document).scrollLeft())<e.scrollSensitivity&&(i=f(document).scrollLeft(f(document).scrollLeft()+e.scrollSpeed))),!1!==i&&f.ui.ddmanager&&!e.dropBehaviour&&f.ui.ddmanager.prepareOffsets(this,t)}this.positionAbs=this._convertPositionTo("absolute"),this.options.axis&&"y"==this.options.axis||(this.helper[0].style.left=this.position.left+"px"),this.options.axis&&"x"==this.options.axis||(this.helper[0].style.top=this.position.top+"px");for(var s=this.items.length-1;0<=s;s--){var o=this.items[s],r=o.item[0],n=this._intersectsWithPointer(o);if(n&&!(r==this.currentItem[0]||this.placeholder[1==n?"next":"prev"]()[0]==r||f.ui.contains(this.placeholder[0],r)||"semi-dynamic"==this.options.type&&f.ui.contains(this.element[0],r))){if(this.direction=1==n?"down":"up","pointer"!=this.options.tolerance&&!this._intersectsWithSides(o))break;this._rearrange(t,o),this._trigger("change",t,this._uiHash());break}}return this._contactContainers(t),f.ui.ddmanager&&f.ui.ddmanager.drag(this,t),this._trigger("sort",t,this._uiHash()),this.lastPositionAbs=this.positionAbs,!1},_mouseStop:function(t,e){if(t){if(f.ui.ddmanager&&!this.options.dropBehaviour&&f.ui.ddmanager.drop(this,t),this.options.revert){var i=this,s=i.placeholder.offset();i.reverting=!0,f(this.helper).animate({left:s.left-this.offset.parent.left-i.margins.left+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollLeft),top:s.top-this.offset.parent.top-i.margins.top+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollTop)},parseInt(this.options.revert,10)||500,function(){i._clear(t)})}else this._clear(t,e);return!1}},cancel:function(){var t=this;if(this.dragging){this._mouseUp({target:null}),"original"==this.options.helper?this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper"):this.currentItem.show();for(var e=this.containers.length-1;0<=e;e--)this.containers[e]._trigger("deactivate",null,t._uiHash(this)),this.containers[e].containerCache.over&&(this.containers[e]._trigger("out",null,t._uiHash(this)),this.containers[e].containerCache.over=0)}return this.placeholder&&(this.placeholder[0].parentNode&&this.placeholder[0].parentNode.removeChild(this.placeholder[0]),"original"!=this.options.helper&&this.helper&&this.helper[0].parentNode&&this.helper.remove(),f.extend(this,{helper:null,dragging:!1,reverting:!1,_noFinalSort:null}),this.domPosition.prev?f(this.domPosition.prev).after(this.currentItem):f(this.domPosition.parent).prepend(this.currentItem)),this},serialize:function(e){var t=this._getItemsAsjQuery(e&&e.connected),i=[];return e=e||{},f(t).each(function(){var t=(f(e.item||this).attr(e.attribute||"id")||"").match(e.expression||/(.+)[-=_](.+)/);t&&i.push((e.key||t[1]+"[]")+"="+(e.key&&e.expression?t[1]:t[2]))}),!i.length&&e.key&&i.push(e.key+"="),i.join("&")},toArray:function(t){var e=this._getItemsAsjQuery(t&&t.connected),i=[];return t=t||{},e.each(function(){i.push(f(t.item||this).attr(t.attribute||"id")||"")}),i},_intersectsWith:function(t){var e=this.positionAbs.left,i=e+this.helperProportions.width,s=this.positionAbs.top,o=s+this.helperProportions.height,r=t.left,n=r+t.width,h=t.top,a=h+t.height,l=this.offset.click.top,c=this.offset.click.left,p=h<s+l&&s+l<a&&r<e+c&&e+c<n;return"pointer"==this.options.tolerance||this.options.forcePointerForContainers||"pointer"!=this.options.tolerance&&this.helperProportions[this.floating?"width":"height"]>t[this.floating?"width":"height"]?p:r<e+this.helperProportions.width/2&&i-this.helperProportions.width/2<n&&h<s+this.helperProportions.height/2&&o-this.helperProportions.height/2<a},_intersectsWithPointer:function(t){var e=f.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,t.top,t.height),i=f.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,t.left,t.width),s=e&&i,o=this._getDragVerticalDirection(),r=this._getDragHorizontalDirection();return!!s&&(this.floating?r&&"right"==r||"down"==o?2:1:o&&("down"==o?2:1))},_intersectsWithSides:function(t){var e=f.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,t.top+t.height/2,t.height),i=f.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,t.left+t.width/2,t.width),s=this._getDragVerticalDirection(),o=this._getDragHorizontalDirection();return this.floating&&o?"right"==o&&i||"left"==o&&!i:s&&("down"==s&&e||"up"==s&&!e)},_getDragVerticalDirection:function(){var t=this.positionAbs.top-this.lastPositionAbs.top;return 0!=t&&(0<t?"down":"up")},_getDragHorizontalDirection:function(){var t=this.positionAbs.left-this.lastPositionAbs.left;return 0!=t&&(0<t?"right":"left")},refresh:function(t){return this._refreshItems(t),this.refreshPositions(),this},_connectWith:function(){var t=this.options;return t.connectWith.constructor==String?[t.connectWith]:t.connectWith},_getItemsAsjQuery:function(t){var e=[],i=[],s=this._connectWith();if(s&&t)for(var o=s.length-1;0<=o;o--)for(var r=f(s[o]),n=r.length-1;0<=n;n--){var h=f.data(r[n],this.widgetName);h&&h!=this&&!h.options.disabled&&i.push([f.isFunction(h.options.items)?h.options.items.call(h.element):f(h.options.items,h.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),h])}i.push([f.isFunction(this.options.items)?this.options.items.call(this.element,null,{options:this.options,item:this.currentItem}):f(this.options.items,this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),this]);for(o=i.length-1;0<=o;o--)i[o][0].each(function(){e.push(this)});return f(e)},_removeCurrentsFromItems:function(){for(var t=this.currentItem.find(":data("+this.widgetName+"-item)"),e=0;e<this.items.length;e++)for(var i=0;i<t.length;i++)t[i]==this.items[e].item[0]&&this.items.splice(e,1)},_refreshItems:function(t){this.items=[],this.containers=[this];var e=this.items,i=[[f.isFunction(this.options.items)?this.options.items.call(this.element[0],t,{item:this.currentItem}):f(this.options.items,this.element),this]],s=this._connectWith();if(s&&this.ready)for(var o=s.length-1;0<=o;o--)for(var r=f(s[o]),n=r.length-1;0<=n;n--){var h=f.data(r[n],this.widgetName);h&&h!=this&&!h.options.disabled&&(i.push([f.isFunction(h.options.items)?h.options.items.call(h.element[0],t,{item:this.currentItem}):f(h.options.items,h.element),h]),this.containers.push(h))}for(o=i.length-1;0<=o;o--)for(var a=i[o][1],l=i[o][0],c=(n=0,l.length);n<c;n++){var p=f(l[n]);p.data(this.widgetName+"-item",a),e.push({item:p,instance:a,width:0,height:0,left:0,top:0})}},refreshPositions:function(t){this.offsetParent&&this.helper&&(this.offset.parent=this._getParentOffset());for(var e=this.items.length-1;0<=e;e--){var i=this.items[e];if(i.instance==this.currentContainer||!this.currentContainer||i.item[0]==this.currentItem[0]){var s=this.options.toleranceElement?f(this.options.toleranceElement,i.item):i.item;t||(i.width=s.outerWidth(),i.height=s.outerHeight());var o=s.offset();i.left=o.left,i.top=o.top}}if(this.options.custom&&this.options.custom.refreshContainers)this.options.custom.refreshContainers.call(this);else for(e=this.containers.length-1;0<=e;e--){o=this.containers[e].element.offset();this.containers[e].containerCache.left=o.left,this.containers[e].containerCache.top=o.top,this.containers[e].containerCache.width=this.containers[e].element.outerWidth(),this.containers[e].containerCache.height=this.containers[e].element.outerHeight()}return this},_createPlaceholder:function(t){var i=t||this,s=i.options;if(!s.placeholder||s.placeholder.constructor==String){var o=s.placeholder;s.placeholder={element:function(){var t=f(document.createElement(i.currentItem[0].nodeName)).addClass(o||i.currentItem[0].className+" ui-sortable-placeholder").removeClass("ui-sortable-helper")[0];return o||(t.style.visibility="hidden"),t},update:function(t,e){o&&!s.forcePlaceholderSize||(e.height()||e.height(i.currentItem.innerHeight()-parseInt(i.currentItem.css("paddingTop")||0,10)-parseInt(i.currentItem.css("paddingBottom")||0,10)),e.width()||e.width(i.currentItem.innerWidth()-parseInt(i.currentItem.css("paddingLeft")||0,10)-parseInt(i.currentItem.css("paddingRight")||0,10)))}}}i.placeholder=f(s.placeholder.element.call(i.element,i.currentItem)),i.currentItem.after(i.placeholder),s.placeholder.update(i,i.placeholder)},_contactContainers:function(t){for(var e=null,i=null,s=this.containers.length-1;0<=s;s--)if(!f.ui.contains(this.currentItem[0],this.containers[s].element[0]))if(this._intersectsWith(this.containers[s].containerCache)){if(e&&f.ui.contains(this.containers[s].element[0],e.element[0]))continue;e=this.containers[s],i=s}else this.containers[s].containerCache.over&&(this.containers[s]._trigger("out",t,this._uiHash(this)),this.containers[s].containerCache.over=0);if(e)if(1===this.containers.length)this.containers[i]._trigger("over",t,this._uiHash(this)),this.containers[i].containerCache.over=1;else if(this.currentContainer!=this.containers[i]){for(var o=1e4,r=null,n=this.positionAbs[this.containers[i].floating?"left":"top"],h=this.items.length-1;0<=h;h--)if(f.ui.contains(this.containers[i].element[0],this.items[h].item[0])){var a=this.items[h][this.containers[i].floating?"left":"top"];Math.abs(a-n)<o&&(o=Math.abs(a-n),r=this.items[h])}if(!r&&!this.options.dropOnEmpty)return;this.currentContainer=this.containers[i],r?this._rearrange(t,r,null,!0):this._rearrange(t,null,this.containers[i].element,!0),this._trigger("change",t,this._uiHash()),this.containers[i]._trigger("change",t,this._uiHash(this)),this.options.placeholder.update(this.currentContainer,this.placeholder),this.containers[i]._trigger("over",t,this._uiHash(this)),this.containers[i].containerCache.over=1}},_createHelper:function(t){var e=this.options,i=f.isFunction(e.helper)?f(e.helper.apply(this.element[0],[t,this.currentItem])):"clone"==e.helper?this.currentItem.clone():this.currentItem;return i.parents("body").length||f("parent"!=e.appendTo?e.appendTo:this.currentItem[0].parentNode)[0].appendChild(i[0]),i[0]==this.currentItem[0]&&(this._storedCSS={width:this.currentItem[0].style.width,height:this.currentItem[0].style.height,position:this.currentItem.css("position"),top:this.currentItem.css("top"),left:this.currentItem.css("left")}),(""==i[0].style.width||e.forceHelperSize)&&i.width(this.currentItem.width()),(""==i[0].style.height||e.forceHelperSize)&&i.height(this.currentItem.height()),i},_adjustOffsetFromHelper:function(t){"string"==typeof t&&(t=t.split(" ")),f.isArray(t)&&(t={left:+t[0],top:+t[1]||0}),"left"in t&&(this.offset.click.left=t.left+this.margins.left),"right"in t&&(this.offset.click.left=this.helperProportions.width-t.right+this.margins.left),"top"in t&&(this.offset.click.top=t.top+this.margins.top),"bottom"in t&&(this.offset.click.top=this.helperProportions.height-t.bottom+this.margins.top)},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var t=this.offsetParent.offset();return"absolute"==this.cssPosition&&this.scrollParent[0]!=document&&f.ui.contains(this.scrollParent[0],this.offsetParent[0])&&(t.left+=this.scrollParent.scrollLeft(),t.top+=this.scrollParent.scrollTop()),(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&"html"==this.offsetParent[0].tagName.toLowerCase()&&f.browser.msie)&&(t={top:0,left:0}),{top:t.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:t.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if("relative"!=this.cssPosition)return{top:0,left:0};var t=this.currentItem.position();return{top:t.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:t.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}},_cacheMargins:function(){this.margins={left:parseInt(this.currentItem.css("marginLeft"),10)||0,top:parseInt(this.currentItem.css("marginTop"),10)||0}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var t=this.options;if("parent"==t.containment&&(t.containment=this.helper[0].parentNode),"document"!=t.containment&&"window"!=t.containment||(this.containment=[0-this.offset.relative.left-this.offset.parent.left,0-this.offset.relative.top-this.offset.parent.top,f("document"==t.containment?document:window).width()-this.helperProportions.width-this.margins.left,(f("document"==t.containment?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top]),!/^(document|window|parent)$/.test(t.containment)){var e=f(t.containment)[0],i=f(t.containment).offset(),s="hidden"!=f(e).css("overflow");this.containment=[i.left+(parseInt(f(e).css("borderLeftWidth"),10)||0)+(parseInt(f(e).css("paddingLeft"),10)||0)-this.margins.left,i.top+(parseInt(f(e).css("borderTopWidth"),10)||0)+(parseInt(f(e).css("paddingTop"),10)||0)-this.margins.top,i.left+(s?Math.max(e.scrollWidth,e.offsetWidth):e.offsetWidth)-(parseInt(f(e).css("borderLeftWidth"),10)||0)-(parseInt(f(e).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left,i.top+(s?Math.max(e.scrollHeight,e.offsetHeight):e.offsetHeight)-(parseInt(f(e).css("borderTopWidth"),10)||0)-(parseInt(f(e).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top]}},_convertPositionTo:function(t,e){e||(e=this.position);var i="absolute"==t?1:-1,s=(this.options,"absolute"!=this.cssPosition||this.scrollParent[0]!=document&&f.ui.contains(this.scrollParent[0],this.offsetParent[0])?this.scrollParent:this.offsetParent),o=/(html|body)/i.test(s[0].tagName);return{top:e.top+this.offset.relative.top*i+this.offset.parent.top*i-(f.browser.safari&&"fixed"==this.cssPosition?0:("fixed"==this.cssPosition?-this.scrollParent.scrollTop():o?0:s.scrollTop())*i),left:e.left+this.offset.relative.left*i+this.offset.parent.left*i-(f.browser.safari&&"fixed"==this.cssPosition?0:("fixed"==this.cssPosition?-this.scrollParent.scrollLeft():o?0:s.scrollLeft())*i)}},_generatePosition:function(t){var e=this.options,i="absolute"!=this.cssPosition||this.scrollParent[0]!=document&&f.ui.contains(this.scrollParent[0],this.offsetParent[0])?this.scrollParent:this.offsetParent,s=/(html|body)/i.test(i[0].tagName);"relative"!=this.cssPosition||this.scrollParent[0]!=document&&this.scrollParent[0]!=this.offsetParent[0]||(this.offset.relative=this._getRelativeOffset());var o=t.pageX,r=t.pageY;if(this.originalPosition&&(this.containment&&(t.pageX-this.offset.click.left<this.containment[0]&&(o=this.containment[0]+this.offset.click.left),t.pageY-this.offset.click.top<this.containment[1]&&(r=this.containment[1]+this.offset.click.top),t.pageX-this.offset.click.left>this.containment[2]&&(o=this.containment[2]+this.offset.click.left),t.pageY-this.offset.click.top>this.containment[3]&&(r=this.containment[3]+this.offset.click.top)),e.grid)){var n=this.originalPageY+Math.round((r-this.originalPageY)/e.grid[1])*e.grid[1];r=this.containment&&(n-this.offset.click.top<this.containment[1]||n-this.offset.click.top>this.containment[3])?n-this.offset.click.top<this.containment[1]?n+e.grid[1]:n-e.grid[1]:n;var h=this.originalPageX+Math.round((o-this.originalPageX)/e.grid[0])*e.grid[0];o=this.containment&&(h-this.offset.click.left<this.containment[0]||h-this.offset.click.left>this.containment[2])?h-this.offset.click.left<this.containment[0]?h+e.grid[0]:h-e.grid[0]:h}return{top:r-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(f.browser.safari&&"fixed"==this.cssPosition?0:"fixed"==this.cssPosition?-this.scrollParent.scrollTop():s?0:i.scrollTop()),left:o-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(f.browser.safari&&"fixed"==this.cssPosition?0:"fixed"==this.cssPosition?-this.scrollParent.scrollLeft():s?0:i.scrollLeft())}},_rearrange:function(t,e,i,s){i?i[0].appendChild(this.placeholder[0]):e.item[0].parentNode.insertBefore(this.placeholder[0],"down"==this.direction?e.item[0]:e.item[0].nextSibling),this.counter=this.counter?++this.counter:1;var o=this,r=this.counter;window.setTimeout(function(){r==o.counter&&o.refreshPositions(!s)},0)},_clear:function(t,e){this.reverting=!1;var i=[];if(!this._noFinalSort&&this.currentItem.parent().length&&this.placeholder.before(this.currentItem),this._noFinalSort=null,this.helper[0]==this.currentItem[0]){for(var s in this._storedCSS)"auto"!=this._storedCSS[s]&&"static"!=this._storedCSS[s]||(this._storedCSS[s]="");this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper")}else this.currentItem.show();if(this.fromOutside&&!e&&i.push(function(t){this._trigger("receive",t,this._uiHash(this.fromOutside))}),!this.fromOutside&&this.domPosition.prev==this.currentItem.prev().not(".ui-sortable-helper")[0]&&this.domPosition.parent==this.currentItem.parent()[0]||e||i.push(function(t){this._trigger("update",t,this._uiHash())}),!f.ui.contains(this.element[0],this.currentItem[0])){e||i.push(function(t){this._trigger("remove",t,this._uiHash())});for(s=this.containers.length-1;0<=s;s--)f.ui.contains(this.containers[s].element[0],this.currentItem[0])&&!e&&(i.push(function(e){return function(t){e._trigger("receive",t,this._uiHash(this))}}.call(this,this.containers[s])),i.push(function(e){return function(t){e._trigger("update",t,this._uiHash(this))}}.call(this,this.containers[s])))}for(s=this.containers.length-1;0<=s;s--)e||i.push(function(e){return function(t){e._trigger("deactivate",t,this._uiHash(this))}}.call(this,this.containers[s])),this.containers[s].containerCache.over&&(i.push(function(e){return function(t){e._trigger("out",t,this._uiHash(this))}}.call(this,this.containers[s])),this.containers[s].containerCache.over=0);if(this._storedCursor&&f("body").css("cursor",this._storedCursor),this._storedOpacity&&this.helper.css("opacity",this._storedOpacity),this._storedZIndex&&this.helper.css("zIndex","auto"==this._storedZIndex?"":this._storedZIndex),this.dragging=!1,this.cancelHelperRemoval){if(!e){this._trigger("beforeStop",t,this._uiHash());for(s=0;s<i.length;s++)i[s].call(this,t);this._trigger("stop",t,this._uiHash())}return!1}if(e||this._trigger("beforeStop",t,this._uiHash()),this.placeholder[0].parentNode.removeChild(this.placeholder[0]),this.helper[0]!=this.currentItem[0]&&this.helper.remove(),this.helper=null,!e){for(s=0;s<i.length;s++)i[s].call(this,t);this._trigger("stop",t,this._uiHash())}return!(this.fromOutside=!1)},_trigger:function(){!1===f.Widget.prototype._trigger.apply(this,arguments)&&this.cancel()},_uiHash:function(t){var e=t||this;return{helper:e.helper,placeholder:e.placeholder||f([]),position:e.position,originalPosition:e.originalPosition,offset:e.positionAbs,item:e.currentItem,sender:t?t.element:null}}}),f.extend(f.ui.sortable,{version:"1.8.18"})}(jQuery);