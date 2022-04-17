/*! KeyTable 2.1.0
 * ©2009-2015 SpryMedia Ltd - datatables.net/license
 */
/**
 * @summary     KeyTable
 * @description Spreadsheet like keyboard navigation for DataTables
 * @version     2.1.0
 * @file        dataTables.keyTable.js
 * @author      SpryMedia Ltd (www.sprymedia.co.uk)
 * @contact     www.sprymedia.co.uk/contact
 * @copyright   Copyright 2009-2015 SpryMedia Ltd.
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
!function(s){"function"==typeof define&&define.amd?define(["jquery","datatables.net"],function(e){return s(e,window,document)}):"object"==typeof exports?module.exports=function(e,t){return e||(e=window),t&&t.fn.dataTable||(t=require("datatables.net")(e,t).$),s(t,e,e.document)}:s(jQuery,window,document)}(function(d,f,h,r){"use strict";var a=d.fn.dataTable,l=function(e,t){if(!a.versionCheck||!a.versionCheck("1.10.8"))throw"KeyTable requires DataTables 1.10.8 or newer";this.c=d.extend(!0,{},a.defaults.keyTable,l.defaults,t),this.s={dt:new a.Api(e),enable:!0},this.dom={};var s=this.s.dt.settings()[0],n=s.keytable;if(n)return n;(s.keytable=this)._constructor()};return d.extend(l.prototype,{blur:function(){this._blur()},enable:function(e){this.s.enable=e},focus:function(e,t){this._focus(this.s.dt.cell(e,t))},focused:function(e){if(!this.s.lastFocus)return!1;var t=this.s.lastFocus.index();return e.row===t.row&&e.column===t.column},_constructor:function(){this._tabInput();var a=this,t=this.s.dt,e=d(t.table().node());"static"===e.css("position")&&e.css("position","relative"),d(t.table().body()).on("click.keyTable","th, td",function(){if(!1!==a.s.enable){var e=t.cell(this);e.any()&&a._focus(e)}}),d(h.body).on("keydown.keyTable",function(e){a._key(e)}),this.c.blurable&&d(h.body).on("click.keyTable",function(e){d(e.target).parents(".dataTables_filter").length&&a._blur(),d(e.target).parents().filter(t.table().container()).length||d(e.target).parents("div.DTE").length||a._blur()}),this.c.editor&&t.on("key.kt",function(e,t,s,n,i){a._editor(s,i)}),t.settings()[0].oFeatures.bStateSave&&t.on("stateSaveParams.keyTable",function(e,t,s){s.keyTable=a.s.lastFocus?a.s.lastFocus.index():null}),t.on("destroy.keyTable",function(){t.off(".keyTable"),d(t.table().body()).off("click.keyTable","th, td"),d(h.body).off("keydown.keyTable").off("click.keyTable")});var s=t.state.loaded();s&&s.keyTable?t.cell(s.keyTable).focus():this.c.focus&&t.cell(this.c.focus).focus()},_blur:function(){if(this.s.enable&&this.s.lastFocus){var e=this.s.lastFocus;d(e.node()).removeClass(this.c.className),this.s.lastFocus=null,this._emitEvent("key-blur",[this.s.dt,e])}},_columns:function(){var e=this.s.dt,t=e.columns(this.c.columns).indexes(),s=[];return e.columns(":visible").every(function(e){-1!==t.indexOf(e)&&s.push(e)}),s},_editor:function(e,t){var s=this.s.dt,n=this.c.editor;t.stopPropagation(),n.inline(this.s.lastFocus.index());var i=d("div.DTE input");i.length&&i[0].select(),s.keys.enable("navigation-only"),s.one("key-blur.editor",function(){n.displayed()&&n.submit()}),n.one("close",function(){s.keys.enable(!0),s.off("key-blur.editor")})},_emitEvent:function(t,s){this.s.dt.iterator("table",function(e){d(e.nTable).triggerHandler(t,s)})},_focus:function(e,t){var s=this,n=this.s.dt,i=n.page.info(),a=this.s.lastFocus;if(this.s.enable){if("number"!=typeof e){var l=e.index();t=l.column,e=n.rows({filter:"applied",order:"applied"}).indexes().indexOf(l.row),i.serverSide&&(e+=i.start)}if(-1!==i.length&&(e<i.start||e>=i.start+i.length))n.one("draw",function(){s._focus(e,t)}).page(Math.floor(e/i.length)).draw(!1);else if(-1!==d.inArray(t,this._columns())){i.serverSide&&(e-=i.start);var o=n.cell(":eq("+e+")",t,{search:"applied"});if(a){if(a.node()===o.node())return;this._blur()}var r=d(o.node());r.addClass(this.c.className),this._scroll(d(f),d(h.body),r,"offset");var c=n.table().body().parentNode;if(c!==n.table().header().parentNode){var u=d(c.parentNode);this._scroll(u,u,r,"position")}this.s.lastFocus=o,this._emitEvent("key-focus",[this.s.dt,o]),n.state.save()}}},_key:function(e){if(this.s.enable&&!(0===e.keyCode||e.ctrlKey||e.metaKey||e.altKey)){var t=this.s.lastFocus;if(t){var s=this,n=this.s.dt;if(!this.c.keys||-1!==d.inArray(e.keyCode,this.c.keys))switch(e.keyCode){case 9:this._shift(e,e.shiftKey?"left":"right",!0);break;case 27:this.s.blurable&&!0===this.s.enable&&this._blur();break;case 33:case 34:e.preventDefault();var i=n.cells({page:"current"}).nodes().indexOf(t.node());n.one("draw",function(){var e=n.cells({page:"current"}).nodes();s._focus(n.cell(i<e.length?e[i]:e[e.length-1]))}).page(33===e.keyCode?"previous":"next").draw(!1);break;case 35:case 36:e.preventDefault();var a=n.cells({page:"current"}).indexes();this._focus(n.cell(a[35===e.keyCode?a.length-1:0]));break;case 37:this._shift(e,"left");break;case 38:this._shift(e,"up");break;case 39:this._shift(e,"right");break;case 40:this._shift(e,"down");break;default:!0===this.s.enable&&this._emitEvent("key",[n,e.keyCode,this.s.lastFocus,e])}}}},_scroll:function(e,t,s,n){var i=s[n](),a=s.outerHeight(),l=s.outerWidth(),o=t.scrollTop(),r=t.scrollLeft(),c=e.height(),u=e.width();i.top<o&&t.scrollTop(i.top),i.left<r&&t.scrollLeft(i.left),i.top+a>o+c&&t.scrollTop(i.top+a-c),i.left+l>r+u&&t.scrollLeft(i.left+l-u)},_shift:function(e,t,s){var n=this.s.dt,i=n.page.info(),a=i.recordsDisplay,l=this.s.lastFocus,o=this._columns();if(l){var r=n.rows({filter:"applied",order:"applied"}).indexes().indexOf(l.index().row);i.serverSide&&(r+=i.start);var c=n.columns(o).indexes().indexOf(l.index().column),u=r,f=o[c];"right"===t?f=c>=o.length-1?(u++,o[0]):o[c+1]:"left"===t?f=0===c?(u--,o[o.length-1]):o[c-1]:"up"===t?u--:"down"===t&&u++,0<=u&&u<a&&-1!==d.inArray(f,o)?(e.preventDefault(),this._focus(u,f)):s&&this.c.blurable?this._blur():e.preventDefault()}},_tabInput:function(){var e=this,t=this.s.dt,s=null!==this.c.tabIndex?this.c.tabIndex:t.settings()[0].iTabIndex;-1!=s&&d('<div><input type="text" tabindex="'+s+'"/></div>').css({position:"absolute",height:1,width:0,overflow:"hidden"}).insertBefore(t.table().node()).children().on("focus",function(){e._focus(t.cell(":eq(0)",{page:"current"}))})}}),l.defaults={blurable:!0,className:"focus",columns:"",editor:null,focus:null,keys:null,tabIndex:null},l.version="2.1.0",d.fn.dataTable.KeyTable=l,d.fn.DataTable.KeyTable=l,a.Api.register("cell.blur()",function(){return this.iterator("table",function(e){e.keytable&&e.keytable.blur()})}),a.Api.register("cell().focus()",function(){return this.iterator("cell",function(e,t,s){e.keytable&&e.keytable.focus(t,s)})}),a.Api.register("keys.disable()",function(){return this.iterator("table",function(e){e.keytable&&e.keytable.enable(!1)})}),a.Api.register("keys.enable()",function(t){return this.iterator("table",function(e){e.keytable&&e.keytable.enable(t===r||t)})}),a.ext.selector.cell.push(function(e,t,s){var n=t.focused,i=e.keytable,a=[];if(!i||n===r)return s;for(var l=0,o=s.length;l<o;l++)(!0===n&&i.focused(s[l])||!1===n&&!i.focused(s[l]))&&a.push(s[l]);return a}),d(h).on("preInit.dt.dtk",function(e,t){if("dt"===e.namespace){var s=t.oInit.keys,n=a.defaults.keys;if(s||n){var i=d.extend({},s,n);!1!==s&&new l(t,i)}}}),l});