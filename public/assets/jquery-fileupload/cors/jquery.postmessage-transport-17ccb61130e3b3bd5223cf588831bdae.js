/*
 * jQuery postMessage Transport Plugin 1.1
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery"],e):e(window.jQuery)}(function(p){"use strict";var t=0,c=["accepts","cache","contents","contentType","crossDomain","data","dataType","headers","ifModified","mimeType","password","processData","timeout","traditional","type","url","username"],e=function(e){return e};p.ajaxSetup({converters:{"postmessage text":e,"postmessage json":e,"postmessage html":e}}),p.ajaxTransport("postmessage",function(s){if(s.postMessage&&window.postMessage){var i,e=p("<a>").prop("href",s.postMessage)[0],r=e.protocol+"//"+e.host,d=s.xhr().upload;return{send:function(e,n){var a={id:"postmessage-transport-"+(t+=1)},o="message."+a.id;i=p('<iframe style="display:none;" src="'+s.postMessage+'" name="'+a.id+'"></iframe>').bind("load",function(){p.each(c,function(e,t){a[t]=s[t]}),a.dataType=a.dataType.replace("postmessage ",""),p(window).bind(o,function(e){var t,s=(e=e.originalEvent).data;e.origin===r&&s.id===a.id&&("progress"===s.type?((t=document.createEvent("Event")).initEvent(s.type,!1,!0),p.extend(t,s),d.dispatchEvent(t)):(n(s.status,s.statusText,{postmessage:s.result},s.headers),i.remove(),p(window).unbind(o)))}),i[0].contentWindow.postMessage(a,r)}).appendTo(document.body)},abort:function(){i&&i.remove()}}}})});