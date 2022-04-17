/*
 * jQuery UI Position 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Position
 */
!function(d){d.ui=d.ui||{};var o=/left|center|right/,i=/top|center|bottom/,m="center",y={},n=d.fn.position,l=d.fn.offset;d.fn.position=function(a){if(!a||!a.of)return n.apply(this,arguments);a=d.extend({},a);var p,h,c,t=d(a.of),e=t[0],u=(a.collision||"flip").split(" "),g=a.offset?a.offset.split(" "):[0,0];return c=9===e.nodeType?(p=t.width(),h=t.height(),{top:0,left:0}):e.setTimeout?(p=t.width(),h=t.height(),{top:t.scrollTop(),left:t.scrollLeft()}):e.preventDefault?(a.at="left top",p=h=0,{top:a.of.pageY,left:a.of.pageX}):(p=t.outerWidth(),h=t.outerHeight(),t.offset()),d.each(["my","at"],function(){var t=(a[this]||"").split(" ");1===t.length&&(t=o.test(t[0])?t.concat([m]):i.test(t[0])?[m].concat(t):[m,m]),t[0]=o.test(t[0])?t[0]:m,t[1]=i.test(t[1])?t[1]:m,a[this]=t}),1===u.length&&(u[1]=u[0]),g[0]=parseInt(g[0],10)||0,1===g.length&&(g[1]=g[0]),g[1]=parseInt(g[1],10)||0,"right"===a.at[0]?c.left+=p:a.at[0]===m&&(c.left+=p/2),"bottom"===a.at[1]?c.top+=h:a.at[1]===m&&(c.top+=h/2),c.left+=g[0],c.top+=g[1],this.each(function(){var o,t=d(this),i=t.outerWidth(),n=t.outerHeight(),e=parseInt(d.curCSS(this,"marginLeft",!0))||0,l=parseInt(d.curCSS(this,"marginTop",!0))||0,f=i+e+(parseInt(d.curCSS(this,"marginRight",!0))||0),s=n+l+(parseInt(d.curCSS(this,"marginBottom",!0))||0),r=d.extend({},c);"right"===a.my[0]?r.left-=i:a.my[0]===m&&(r.left-=i/2),"bottom"===a.my[1]?r.top-=n:a.my[1]===m&&(r.top-=n/2),y.fractions||(r.left=Math.round(r.left),r.top=Math.round(r.top)),o={left:r.left-e,top:r.top-l},d.each(["left","top"],function(t,e){d.ui.position[u[t]]&&d.ui.position[u[t]][e](r,{targetWidth:p,targetHeight:h,elemWidth:i,elemHeight:n,collisionPosition:o,collisionWidth:f,collisionHeight:s,offset:g,my:a.my,at:a.at})}),d.fn.bgiframe&&t.bgiframe(),t.offset(d.extend(r,{using:a.using}))})},d.ui.position={fit:{left:function(t,e){var o=d(window),i=e.collisionPosition.left+e.collisionWidth-o.width()-o.scrollLeft();t.left=0<i?t.left-i:Math.max(t.left-e.collisionPosition.left,t.left)},top:function(t,e){var o=d(window),i=e.collisionPosition.top+e.collisionHeight-o.height()-o.scrollTop();t.top=0<i?t.top-i:Math.max(t.top-e.collisionPosition.top,t.top)}},flip:{left:function(t,e){if(e.at[0]!==m){var o=d(window),i=e.collisionPosition.left+e.collisionWidth-o.width()-o.scrollLeft(),n="left"===e.my[0]?-e.elemWidth:"right"===e.my[0]?e.elemWidth:0,l="left"===e.at[0]?e.targetWidth:-e.targetWidth,f=-2*e.offset[0];t.left+=e.collisionPosition.left<0?n+l+f:0<i?n+l+f:0}},top:function(t,e){if(e.at[1]!==m){var o=d(window),i=e.collisionPosition.top+e.collisionHeight-o.height()-o.scrollTop(),n="top"===e.my[1]?-e.elemHeight:"bottom"===e.my[1]?e.elemHeight:0,l="top"===e.at[1]?e.targetHeight:-e.targetHeight,f=-2*e.offset[1];t.top+=e.collisionPosition.top<0?n+l+f:0<i?n+l+f:0}}}},d.offset.setOffset||(d.offset.setOffset=function(t,e){/static/.test(d.curCSS(t,"position"))&&(t.style.position="relative");var o=d(t),i=o.offset(),n=parseInt(d.curCSS(t,"top",!0),10)||0,l=parseInt(d.curCSS(t,"left",!0),10)||0,f={top:e.top-i.top+n,left:e.left-i.left+l};"using"in e?e.using.call(t,f):o.css(f)},d.fn.offset=function(t){var e=this[0];return e&&e.ownerDocument?t?this.each(function(){d.offset.setOffset(this,t)}):l.call(this):null}),function(){var t,e,o,i,n,l=document.getElementsByTagName("body")[0],f=document.createElement("div");for(var s in t=document.createElement(l?"div":"body"),o={visibility:"hidden",width:0,height:0,border:0,margin:0,background:"none"},l&&d.extend(o,{position:"absolute",left:"-1000px",top:"-1000px"}),o)t.style[s]=o[s];t.appendChild(f),(e=l||document.documentElement).insertBefore(t,e.firstChild),f.style.cssText="position: absolute; left: 10.7432222px; top: 10.432325px; height: 30px; width: 201px;",i=d(f).offset(function(t,e){return e}).offset(),t.innerHTML="",e.removeChild(t),n=i.top+i.left+(l?2e3:0),y.fractions=21<n&&n<22}()}(jQuery);