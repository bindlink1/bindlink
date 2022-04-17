/*! RowReorder 1.1.0
 * 2015 SpryMedia Ltd - datatables.net/license
 */
/**
 * @summary     RowReorder
 * @description Row reordering extension for DataTables
 * @version     1.1.0
 * @file        dataTables.rowReorder.js
 * @author      SpryMedia Ltd (www.sprymedia.co.uk)
 * @contact     www.sprymedia.co.uk/contact
 * @copyright   Copyright 2015 SpryMedia Ltd.
 *
 * This source file is free software, available under the following license:
 *   MIT license - http://datatables.net/license/mit
 *
 * This source file is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the license files for details.
 *
 * For details please refer to: http://www.datatables.net
 */
!function(o){"function"==typeof define&&define.amd?define(["jquery","datatables.net"],function(t){return o(t,window,document)}):"object"==typeof exports?module.exports=function(t,e){return t||(t=window),e&&e.fn.dataTable||(e=require("datatables.net")(t,e).$),o(e,t,t.document)}:o(jQuery,window,document)}(function(w,i,p){"use strict";var s=w.fn.dataTable,a=function(t,e){if(!s.versionCheck||!s.versionCheck("1.10.8"))throw"DataTables RowReorder requires DataTables 1.10.8 or newer";this.c=w.extend(!0,{},s.defaults.rowReorder,a.defaults,e),this.s={bodyTop:null,dt:new s.Api(t),getDataFn:s.ext.oApi._fnGetObjectDataFn(this.c.dataSrc),middles:null,setDataFn:s.ext.oApi._fnSetObjectDataFn(this.c.dataSrc),start:{top:0,left:0,offsetTop:0,offsetLeft:0,nodes:[]},windowHeight:0},this.dom={clone:null};var o=this.s.dt.settings()[0],r=o.rowreorder;if(r)return r;(o.rowreorder=this)._constructor()};return w.extend(a.prototype,{_constructor:function(){var o=this,r=this.s.dt,t=w(r.table().node());"static"===t.css("position")&&t.css("position","relative"),w(r.table().container()).on("mousedown.rowReorder touchstart.rowReorder",this.c.selector,function(t){var e=w(this).closest("tr");if(r.row(e).any())return o._mouseDown(t,e),!1}),r.on("destroy.rowReorder",function(){w(r.table().container()).off(".rowReorder"),r.off(".rowReorder")})},_cachePositions:function(){var o=this.s.dt,e=w(o.table().node()).find("thead").outerHeight(),t=w.unique(o.rows({page:"current"}).nodes().toArray()),r=w.map(t,function(t){return w(t).position().top-e}),n=w.map(r,function(t,e){return r.length<e-1?(t+r[e+1])/2:(t+t+w(o.row(":last-child").node()).outerHeight())/2});this.s.middles=n,this.s.bodyTop=w(o.table().body()).offset().top,this.s.windowHeight=w(i).height()},_clone:function(t){var e=this.s.dt,o=w(e.table().node().cloneNode(!1)).addClass("dt-rowReorder-float").append("<tbody/>").append(t.clone(!1)),r=t.outerWidth(),n=t.outerHeight(),s=t.children().map(function(){return w(this).width()});o.width(r).height(n).find("tr").children().each(function(t){this.style.width=s[t]+"px"}),o.appendTo("body"),this.dom.clone=o},_clonePosition:function(t){var e,o=this.s.start,r=this._eventToPage(t,"Y")-o.top,n=this._eventToPage(t,"X")-o.left,s=this.c.snapX;e=!0===s?o.offsetLeft:"number"==typeof s?o.offsetLeft+s:n+o.offsetLeft,this.dom.clone.css({top:r+o.offsetTop,left:e})},_emitEvent:function(e,o){this.s.dt.iterator("table",function(t){w(t.nTable).triggerHandler(e+".dt",o)})},_eventToPage:function(t,e){return-1!==t.type.indexOf("touch")?t.originalEvent.touches[0]["page"+e]:t["page"+e]},_mouseDown:function(t,e){var o=this,r=this.s.dt,n=this.s.start,s=e.offset();n.top=this._eventToPage(t,"Y"),n.left=this._eventToPage(t,"X"),n.offsetTop=s.top,n.offsetLeft=s.left,n.nodes=w.unique(r.rows({page:"current"}).nodes().toArray()),this._cachePositions(),this._clone(e),this._clonePosition(t),(this.dom.target=e).addClass("dt-rowReorder-moving"),w(p).on("mouseup.rowReorder touchend.rowReorder",function(t){o._mouseUp(t)}).on("mousemove.rowReorder touchmove.rowReorder",function(t){o._mouseMove(t)}),w(i).width()===w(p).width()&&w(p.body).addClass("dt-rowReorder-noOverflow")},_mouseMove:function(t){this._clonePosition(t);for(var e=this._eventToPage(t,"Y")-this.s.bodyTop,o=this.s.middles,r=null,n=this.s.dt,s=n.table().body(),i=0,a=o.length;i<a;i++)if(e<o[i]){r=i;break}if(null===r&&(r=o.length),null===this.s.lastInsert||this.s.lastInsert!==r){if(0===r)this.dom.target.prependTo(s);else{var d=w.unique(n.rows({page:"current"}).nodes().toArray());r>this.s.lastInsert?this.dom.target.before(d[r-1]):this.dom.target.after(d[r])}this._cachePositions(),this.s.lastInsert=r}var l=this._eventToPage(t,"Y")-p.body.scrollTop,c=this.s.scrollInterval;l<65?c||(this.s.scrollInterval=setInterval(function(){p.body.scrollTop-=5},15)):this.s.windowHeight-l<65?c||(this.s.scrollInterval=setInterval(function(){p.body.scrollTop+=5},15)):(clearInterval(c),this.s.scrollInterval=null)},_mouseUp:function(){var t,e,o=this.s.dt,r=this.c.dataSrc;this.dom.clone.remove(),this.dom.clone=null,this.dom.target.removeClass("dt-rowReorder-moving"),w(p).off(".rowReorder"),w(p.body).removeClass("dt-rowReorder-noOverflow"),clearInterval(this.s.scrollInterval),this.s.scrollInterval=null;var n=this.s.start.nodes,s=w.unique(o.rows({page:"current"}).nodes().toArray()),i={},a=[],d=[],l=this.s.getDataFn,c=this.s.setDataFn;for(t=0,e=n.length;t<e;t++)if(n[t]!==s[t]){var h=o.row(s[t]).id(),u=o.row(s[t]).data(),f=o.row(n[t]).data();h&&(i[h]=l(f)),a.push({node:s[t],oldData:l(u),newData:l(f),newPosition:t,oldPosition:w.inArray(s[t],n)}),d.push(s[t])}if(this._emitEvent("row-reorder",[a,{dataSrc:r,nodes:d,values:i,triggerRow:o.row(this.dom.target)}]),this.c.editor&&this.c.editor.edit(d,!1,{submit:"changed"}).multiSet(r,i).submit(),this.c.update){for(t=0,e=a.length;t<e;t++){c(o.row(a[t].node).data(),a[t].newData),o.columns().every(function(){this.dataSrc()===r&&o.cell(a[t].node,this.index()).invalidate("data")})}o.draw(!1)}}}),a.defaults={dataSrc:0,editor:null,selector:"td:first-child",snapX:!1,update:!0},a.version="1.1.0",w.fn.dataTable.RowReorder=a,w.fn.DataTable.RowReorder=a,w(p).on("init.dt.dtr",function(t,e){if("dt"===t.namespace){var o=e.oInit.rowReorder,r=s.defaults.rowReorder;if(o||r){var n=w.extend({},o,r);!1!==o&&new a(e,n)}}}),a});