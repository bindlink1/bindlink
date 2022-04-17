/*
 * jQuery File Upload Plugin 5.21
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery","jquery.ui.widget"],e):e(window.jQuery)}(function(f){"use strict";f.support.xhrFileUpload=!(!window.XMLHttpRequestUpload||!window.FileReader),f.support.xhrFormDataFileUpload=!!window.FormData,f.propHooks.elements={get:function(e){return f.nodeName(e,"form")?f.grep(e.elements,function(e){return!f.nodeName(e,"input")||"file"!==e.type}):null}},f.widget("blueimp.fileupload",{options:{dropZone:f(document),pasteZone:f(document),fileInput:undefined,replaceFileInput:!0,paramName:undefined,singleFileUploads:!0,limitMultiFileUploads:undefined,sequentialUploads:!1,limitConcurrentUploads:undefined,forceIframeTransport:!1,redirect:undefined,redirectParamName:undefined,postMessage:undefined,multipart:!0,maxChunkSize:undefined,uploadedBytes:undefined,recalculateProgress:!0,progressInterval:100,bitrateInterval:500,formData:function(e){return e.serializeArray()},add:function(e,t){t.submit()},processData:!1,contentType:!1,cache:!1},_refreshOptionsList:["fileInput","dropZone","pasteZone","multipart","forceIframeTransport"],_BitrateTimer:function(){this.timestamp=+new Date,this.loaded=0,this.bitrate=0,this.getBitrate=function(e,t,i){var n=e-this.timestamp;return(!this.bitrate||!i||i<n)&&(this.bitrate=(t-this.loaded)*(1e3/n)*8,this.loaded=t,this.timestamp=e),this.bitrate}},_isXHRUpload:function(e){return!e.forceIframeTransport&&(!e.multipart&&f.support.xhrFileUpload||f.support.xhrFormDataFileUpload)},_getFormData:function(e){var i;return"function"==typeof e.formData?e.formData(e.form):f.isArray(e.formData)?e.formData:e.formData?(i=[],f.each(e.formData,function(e,t){i.push({name:e,value:t})}),i):[]},_getTotal:function(e){var i=0;return f.each(e,function(e,t){i+=t.size||1}),i},_onProgress:function(e,t){if(e.lengthComputable){var i,n,r=+new Date;if(t._time&&t.progressInterval&&r-t._time<t.progressInterval&&e.loaded!==e.total)return;t._time=r,i=t.total||this._getTotal(t.files),n=parseInt(e.loaded/e.total*(t.chunkSize||i),10)+(t.uploadedBytes||0),this._loaded+=n-(t.loaded||t.uploadedBytes||0),t.lengthComputable=!0,t.loaded=n,t.total=i,t.bitrate=t._bitrateTimer.getBitrate(r,n,t.bitrateInterval),this._trigger("progress",e,t),this._trigger("progressall",e,{lengthComputable:!0,loaded:this._loaded,total:this._total,bitrate:this._bitrateTimer.getBitrate(r,this._loaded,t.bitrateInterval)})}},_initProgressListener:function(i){var n=this,e=i.xhr?i.xhr():f.ajaxSettings.xhr();e.upload&&(f(e.upload).bind("progress",function(e){var t=e.originalEvent;e.lengthComputable=t.lengthComputable,e.loaded=t.loaded,e.total=t.total,n._onProgress(e,i)}),i.xhr=function(){return e})},_initXHRData:function(i){var n,e=i.files[0],t=i.multipart||!f.support.xhrFileUpload,r=i.paramName[0];i.headers=i.headers||{},i.contentRange&&(i.headers["Content-Range"]=i.contentRange),t?f.support.xhrFormDataFileUpload&&(i.postMessage?(n=this._getFormData(i),i.blob?n.push({name:r,value:i.blob}):f.each(i.files,function(e,t){n.push({name:i.paramName[e]||r,value:t})})):(i.formData instanceof FormData?n=i.formData:(n=new FormData,f.each(this._getFormData(i),function(e,t){n.append(t.name,t.value)})),i.blob?(i.headers["Content-Disposition"]='attachment; filename="'+encodeURI(e.name)+'"',n.append(r,i.blob,e.name)):f.each(i.files,function(e,t){(window.Blob&&t instanceof Blob||window.File&&t instanceof File)&&n.append(i.paramName[e]||r,t,t.name)})),i.data=n):(i.headers["Content-Disposition"]='attachment; filename="'+encodeURI(e.name)+'"',i.contentType=e.type,i.data=i.blob||e),i.blob=null},_initIframeSettings:function(e){e.dataType="iframe "+(e.dataType||""),e.formData=this._getFormData(e),e.redirect&&f("<a></a>").prop("href",e.url).prop("host")!==location.host&&e.formData.push({name:e.redirectParamName||"redirect",value:e.redirect})},_initDataSettings:function(e){this._isXHRUpload(e)?(this._chunkedUpload(e,!0)||(e.data||this._initXHRData(e),this._initProgressListener(e)),e.postMessage&&(e.dataType="postmessage "+(e.dataType||""))):this._initIframeSettings(e,"iframe")},_getParamName:function(e){var t=f(e.fileInput),n=e.paramName;return n?f.isArray(n)||(n=[n]):(n=[],t.each(function(){for(var e=f(this),t=e.prop("name")||"files[]",i=(e.prop("files")||[1]).length;i;)n.push(t),i-=1}),n.length||(n=[t.prop("name")||"files[]"])),n},_initFormSettings:function(e){e.form&&e.form.length||(e.form=f(e.fileInput.prop("form")),e.form.length||(e.form=f(this.options.fileInput.prop("form")))),e.paramName=this._getParamName(e),e.url||(e.url=e.form.prop("action")||location.href),e.type=(e.type||e.form.prop("method")||"").toUpperCase(),"POST"!==e.type&&"PUT"!==e.type&&"PATCH"!==e.type&&(e.type="POST"),e.formAcceptCharset||(e.formAcceptCharset=e.form.attr("accept-charset"))},_getAJAXSettings:function(e){var t=f.extend({},this.options,e);return this._initFormSettings(t),this._initDataSettings(t),t},_enhancePromise:function(e){return e.success=e.done,e.error=e.fail,e.complete=e.always,e},_getXHRPromise:function(e,t,i){var n=f.Deferred(),r=n.promise();return t=t||this.options.context||r,!0===e?n.resolveWith(t,i):!1===e&&n.rejectWith(t,i),r.abort=n.promise,this._enhancePromise(r)},_getUploadedBytes:function(e){var t=e.getResponseHeader("Range"),i=t&&t.split("-"),n=i&&1<i.length&&parseInt(i[1],10);return n&&n+1},_chunkedUpload:function(r,e){var t,o,a=this,i=r.files[0],s=i.size,l=r.uploadedBytes=r.uploadedBytes||0,p=r.maxChunkSize||s,u=i.slice||i.webkitSlice||i.mozSlice,d=f.Deferred(),n=d.promise();return!(!(this._isXHRUpload(r)&&u&&(l||p<s))||r.data)&&(!!e||(s<=l?(i.error="Uploaded bytes exceed file size",this._getXHRPromise(!1,r.context,[null,"error",i.error])):(o=function(){var n=f.extend({},r);n.blob=u.call(i,l,l+p,i.type),n.chunkSize=n.blob.size,n.contentRange="bytes "+l+"-"+(l+n.chunkSize-1)+"/"+s,a._initXHRData(n),a._initProgressListener(n),t=(!1!==a._trigger("chunksend",null,n)&&f.ajax(n)||a._getXHRPromise(!1,n.context)).done(function(e,t,i){l=a._getUploadedBytes(i)||l+n.chunkSize,(!n.loaded||n.loaded<n.total)&&a._onProgress(f.Event("progress",{lengthComputable:!0,loaded:l-n.uploadedBytes,total:l-n.uploadedBytes}),n),r.uploadedBytes=n.uploadedBytes=l,n.result=e,n.textStatus=t,n.jqXHR=i,a._trigger("chunkdone",null,n),a._trigger("chunkalways",null,n),l<s?o():d.resolveWith(n.context,[e,t,i])}).fail(function(e,t,i){n.jqXHR=e,n.textStatus=t,n.errorThrown=i,a._trigger("chunkfail",null,n),a._trigger("chunkalways",null,n),d.rejectWith(n.context,[e,t,i])})},this._enhancePromise(n),n.abort=function(){return t.abort()},o(),n)))},_beforeSend:function(e,t){0===this._active&&(this._trigger("start"),this._bitrateTimer=new this._BitrateTimer),this._active+=1,this._loaded+=t.uploadedBytes||0,this._total+=this._getTotal(t.files)},_onDone:function(e,t,i,n){if(!this._isXHRUpload(n)||!n.loaded||n.loaded<n.total){var r=this._getTotal(n.files)||1;this._onProgress(f.Event("progress",{lengthComputable:!0,loaded:r,total:r}),n)}n.result=e,n.textStatus=t,n.jqXHR=i,this._trigger("done",null,n)},_onFail:function(e,t,i,n){n.jqXHR=e,n.textStatus=t,n.errorThrown=i,this._trigger("fail",null,n),n.recalculateProgress&&(this._loaded-=n.loaded||n.uploadedBytes||0,this._total-=n.total||this._getTotal(n.files))},_onAlways:function(e,t,i,n){this._active-=1,this._trigger("always",null,n),0===this._active&&(this._trigger("stop"),this._loaded=this._total=0,this._bitrateTimer=null)},_onSend:function(e,t){var i,n,r,o,a=this,s=a._getAJAXSettings(t),l=function(){return a._sending+=1,s._bitrateTimer=new a._BitrateTimer,i=i||((n||!1===a._trigger("send",e,s))&&a._getXHRPromise(!1,s.context,n)||a._chunkedUpload(s)||f.ajax(s)).done(function(e,t,i){a._onDone(e,t,i,s)}).fail(function(e,t,i){a._onFail(e,t,i,s)}).always(function(e,t,i){if(a._sending-=1,a._onAlways(e,t,i,s),s.limitConcurrentUploads&&s.limitConcurrentUploads>a._sending)for(var n=a._slots.shift();n;){if(n.state?"pending"===n.state():!n.isRejected()){n.resolve();break}n=a._slots.shift()}})};return this._beforeSend(e,s),this.options.sequentialUploads||this.options.limitConcurrentUploads&&this.options.limitConcurrentUploads<=this._sending?((o=1<this.options.limitConcurrentUploads?(r=f.Deferred(),this._slots.push(r),r.pipe(l)):this._sequence=this._sequence.pipe(l,l)).abort=function(){return n=[undefined,"abort","abort"],i?i.abort():(r&&r.rejectWith(s.context,n),l())},this._enhancePromise(o)):l()},_onAdd:function(n,r){var o,e,a,t,s=this,l=!0,i=f.extend({},this.options,r),p=i.limitMultiFileUploads,u=this._getParamName(i);if((i.singleFileUploads||p)&&this._isXHRUpload(i))if(!i.singleFileUploads&&p)for(a=[],o=[],t=0;t<r.files.length;t+=p)a.push(r.files.slice(t,t+p)),(e=u.slice(t,t+p)).length||(e=u),o.push(e);else o=u;else a=[r.files],o=[u];return r.originalFiles=r.files,f.each(a||r.files,function(e,t){var i=f.extend({},r);return i.files=a?t:[t],i.paramName=o[e],i.submit=function(){return i.jqXHR=this.jqXHR=!1!==s._trigger("submit",n,this)&&s._onSend(n,this),this.jqXHR},l=s._trigger("add",n,i)}),l},_replaceFileInput:function(i){var n=i.clone(!0);f("<form></form>").append(n)[0].reset(),i.after(n).detach(),f.cleanData(i.unbind("remove")),this.options.fileInput=this.options.fileInput.map(function(e,t){return t===i[0]?n[0]:t}),i[0]===this.element[0]&&(this.element=n)},_handleFileTreeEntry:function(t,i){var n=this,r=f.Deferred(),o=function(e){e&&!e.entry&&(e.entry=t),r.resolve([e])};return i=i||"",t.isFile?t._file?(t._file.relativePath=i,r.resolve(t._file)):t.file(function(e){e.relativePath=i,r.resolve(e)},o):t.isDirectory?t.createReader().readEntries(function(e){n._handleFileTreeEntries(e,i+t.name+"/").done(function(e){r.resolve(e)}).fail(o)},o):r.resolve([]),r.promise()},_handleFileTreeEntries:function(e,t){var i=this;return f.when.apply(f,f.map(e,function(e){return i._handleFileTreeEntry(e,t)})).pipe(function(){return Array.prototype.concat.apply([],arguments)})},_getDroppedFiles:function(e){var t=(e=e||{}).items;return t&&t.length&&(t[0].webkitGetAsEntry||t[0].getAsEntry)?this._handleFileTreeEntries(f.map(t,function(e){var t;return e.webkitGetAsEntry?((t=e.webkitGetAsEntry())&&(t._file=e.getAsFile()),t):e.getAsEntry()})):f.Deferred().resolve(f.makeArray(e.files)).promise()},_getSingleFileInputFiles:function(e){var t,i,n=(e=f(e)).prop("webkitEntries")||e.prop("entries");if(n&&n.length)return this._handleFileTreeEntries(n);if((t=f.makeArray(e.prop("files"))).length)t[0].name===undefined&&t[0].fileName&&f.each(t,function(e,t){t.name=t.fileName,t.size=t.fileSize});else{if(!(i=e.prop("value")))return f.Deferred().resolve([]).promise();t=[{name:i.replace(/^.*\\/,"")}]}return f.Deferred().resolve(t).promise()},_getFileInputFiles:function(e){return e instanceof f&&1!==e.length?f.when.apply(f,f.map(e,this._getSingleFileInputFiles)).pipe(function(){return Array.prototype.concat.apply([],arguments)}):this._getSingleFileInputFiles(e)},_onChange:function(t){var i=this,n={fileInput:f(t.target),form:f(t.target.form)};this._getFileInputFiles(n.fileInput).always(function(e){n.files=e,i.options.replaceFileInput&&i._replaceFileInput(n.fileInput),!1!==i._trigger("change",t,n)&&i._onAdd(t,n)})},_onPaste:function(e){var t=e.originalEvent.clipboardData,i=t&&t.items||[],n={files:[]};if(f.each(i,function(e,t){var i=t.getAsFile&&t.getAsFile();i&&n.files.push(i)}),!1===this._trigger("paste",e,n)||!1===this._onAdd(e,n))return!1},_onDrop:function(t){var i=this,e=t.dataTransfer=t.originalEvent.dataTransfer,n={};e&&e.files&&e.files.length&&t.preventDefault(),this._getDroppedFiles(e).always(function(e){n.files=e,!1!==i._trigger("drop",t,n)&&i._onAdd(t,n)})},_onDragOver:function(e){var t=e.dataTransfer=e.originalEvent.dataTransfer;if(!1===this._trigger("dragover",e))return!1;t&&-1!==f.inArray("Files",t.types)&&(t.dropEffect="copy",e.preventDefault())},_initEventHandlers:function(){this._isXHRUpload(this.options)&&(this._on(this.options.dropZone,{dragover:this._onDragOver,drop:this._onDrop}),this._on(this.options.pasteZone,{paste:this._onPaste})),this._on(this.options.fileInput,{change:this._onChange})},_destroyEventHandlers:function(){this._off(this.options.dropZone,"dragover drop"),this._off(this.options.pasteZone,"paste"),this._off(this.options.fileInput,"change")},_setOption:function(e,t){var i=-1!==f.inArray(e,this._refreshOptionsList);i&&this._destroyEventHandlers(),this._super(e,t),i&&(this._initSpecialOptions(),this._initEventHandlers())},_initSpecialOptions:function(){var e=this.options;e.fileInput===undefined?e.fileInput=this.element.is('input[type="file"]')?this.element:this.element.find('input[type="file"]'):e.fileInput instanceof f||(e.fileInput=f(e.fileInput)),e.dropZone instanceof f||(e.dropZone=f(e.dropZone)),e.pasteZone instanceof f||(e.pasteZone=f(e.pasteZone))},_create:function(){var e=this.options;f.extend(e,f(this.element[0].cloneNode(!1)).data()),this._initSpecialOptions(),this._slots=[],this._sequence=this._getXHRPromise(!0),this._sending=this._active=this._loaded=this._total=0,this._initEventHandlers()},_destroy:function(){this._destroyEventHandlers()},add:function(t){var i=this;t&&!this.options.disabled&&(t.fileInput&&!t.files?this._getFileInputFiles(t.fileInput).always(function(e){t.files=e,i._onAdd(null,t)}):(t.files=f.makeArray(t.files),this._onAdd(null,t)))},send:function(t){if(t&&!this.options.disabled){if(t.fileInput&&!t.files){var i,n,r=this,o=f.Deferred(),e=o.promise();return e.abort=function(){return n=!0,i?i.abort():(o.reject(null,"abort","abort"),e)},this._getFileInputFiles(t.fileInput).always(function(e){n||(t.files=e,i=r._onSend(null,t).then(function(e,t,i){o.resolve(e,t,i)},function(e,t,i){o.reject(e,t,i)}))}),this._enhancePromise(e)}if(t.files=f.makeArray(t.files),t.files.length)return this._onSend(null,t)}return this._getXHRPromise(!1,t&&t.context)}})});