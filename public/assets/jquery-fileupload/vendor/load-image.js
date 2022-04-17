/*
 * JavaScript Load Image 1.2.1
 * https://github.com/blueimp/JavaScript-Load-Image
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
!function(e){"use strict";var o=function(e,t,n){var i,r,a=document.createElement("img");return a.onerror=t,a.onload=function(){!r||n&&n.noRevoke||o.revokeObjectURL(r),t(o.scale(a,n))},(i=window.Blob&&e instanceof Blob||window.File&&e instanceof File?r=o.createObjectURL(e):e)?(a.src=i,a):o.readFile(e,function(e){a.src=e})},t=window.createObjectURL&&window||window.URL&&URL.revokeObjectURL&&URL||window.webkitURL&&webkitURL;o.scale=function(e,t){t=t||{};var n=document.createElement("canvas"),i=e.width,r=e.height,a=Math.max((t.minWidth||i)/i,(t.minHeight||r)/r);return 1<a&&(i=parseInt(i*a,10),r=parseInt(r*a,10)),(a=Math.min((t.maxWidth||i)/i,(t.maxHeight||r)/r))<1&&(i=parseInt(i*a,10),r=parseInt(r*a,10)),e.getContext||t.canvas&&n.getContext?(n.width=i,n.height=r,n.getContext("2d").drawImage(e,0,0,i,r),n):(e.width=i,e.height=r,e)},o.createObjectURL=function(e){return!!t&&t.createObjectURL(e)},o.revokeObjectURL=function(e){return!!t&&t.revokeObjectURL(e)},o.readFile=function(e,t){if(window.FileReader&&FileReader.prototype.readAsDataURL){var n=new FileReader;return n.onload=function(e){t(e.target.result)},n.readAsDataURL(e),n}return!1},"function"==typeof define&&define.amd?define(function(){return o}):e.loadImage=o}(this);