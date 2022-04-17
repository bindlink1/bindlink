/*
 * JavaScript Canvas to Blob 2.0.3
 * https://github.com/blueimp/JavaScript-Canvas-to-Blob
 *
 * Copyright 2012, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 *
 * Based on stackoverflow user Stoive's code snippet:
 * http://stackoverflow.com/q/4998908
 */
!function(t){"use strict";var e=t.HTMLCanvasElement&&t.HTMLCanvasElement.prototype,a=t.Blob&&function(){try{return Boolean(new Blob)}catch(t){return!1}}(),u=a&&t.Uint8Array&&function(){try{return 100===new Blob([new Uint8Array(100)]).size}catch(t){return!1}}(),B=t.BlobBuilder||t.WebKitBlobBuilder||t.MozBlobBuilder||t.MSBlobBuilder,n=(a||B)&&t.atob&&t.ArrayBuffer&&t.Uint8Array&&function(t){var e,n,o,r,i,l;for(e=0<=t.split(",")[0].indexOf("base64")?atob(t.split(",")[1]):decodeURIComponent(t.split(",")[1]),n=new ArrayBuffer(e.length),o=new Uint8Array(n),r=0;r<e.length;r+=1)o[r]=e.charCodeAt(r);return i=t.split(",")[0].split(":")[1].split(";")[0],a?new Blob([u?o:n],{type:i}):((l=new B).append(n),l.getBlob(i))};t.HTMLCanvasElement&&!e.toBlob&&(e.mozGetAsFile?e.toBlob=function(t,e){t(this.mozGetAsFile("blob",e))}:e.toDataURL&&n&&(e.toBlob=function(t,e){t(n(this.toDataURL(e)))})),"function"==typeof define&&define.amd?define(function(){return n}):t.dataURLtoBlob=n}(this);