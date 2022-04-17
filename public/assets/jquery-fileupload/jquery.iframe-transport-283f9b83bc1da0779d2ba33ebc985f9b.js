/*
 * jQuery Iframe Transport Plugin 1.6.1
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery"],e):e(window.jQuery)}(function(i){"use strict";var a=0;i.ajaxTransport("iframe",function(n){var p,o,t;if(n.async)return{send:function(e,r){(p=i('<form style="display:none;"></form>')).attr("accept-charset",n.formAcceptCharset),t=/\?/.test(n.url)?"&":"?","DELETE"===n.type?(n.url=n.url+t+"_method=DELETE",n.type="POST"):"PUT"===n.type?(n.url=n.url+t+"_method=PUT",n.type="POST"):"PATCH"===n.type&&(n.url=n.url+t+"_method=PATCH",n.type="POST"),o=i('<iframe src="javascript:false;" name="iframe-transport-'+(a+=1)+'"></iframe>').bind("load",function(){var a,t=i.isArray(n.paramName)?n.paramName:[n.paramName];o.unbind("load").bind("load",function(){var e;try{if(!(e=o.contents()).length||!e[0].firstChild)throw new Error}catch(t){e=undefined}r(200,"success",{iframe:e}),i('<iframe src="javascript:false;"></iframe>').appendTo(p),p.remove()}),p.prop("target",o.prop("name")).prop("action",n.url).prop("method",n.type),n.formData&&i.each(n.formData,function(e,t){i('<input type="hidden"/>').prop("name",t.name).val(t.value).appendTo(p)}),n.fileInput&&n.fileInput.length&&"POST"===n.type&&(a=n.fileInput.clone(),n.fileInput.after(function(e){return a[e]}),n.paramName&&n.fileInput.each(function(e){i(this).prop("name",t[e]||n.paramName)}),p.append(n.fileInput).prop("enctype","multipart/form-data").prop("encoding","multipart/form-data")),p.submit(),a&&a.length&&n.fileInput.each(function(e,t){var r=i(a[e]);i(t).prop("name",r.prop("name")),r.replaceWith(t)})}),p.append(o).appendTo(document.body)},abort:function(){o&&o.unbind("load").prop("src","javascript".concat(":false;")),p&&p.remove()}}}),i.ajaxSetup({converters:{"iframe text":function(e){return e&&i(e[0].body).text()},"iframe json":function(e){return e&&i.parseJSON(i(e[0].body).text())},"iframe html":function(e){return e&&i(e[0].body).html()},"iframe script":function(e){return e&&i.globalEval(i(e[0].body).text())}}})});