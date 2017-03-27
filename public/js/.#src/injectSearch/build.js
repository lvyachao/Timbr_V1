/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var click;

	click = __webpack_require__(1);

	$(document).ready(function() {
	  click.textclickget.enableGetData();
	  click.checkboxclickget.enableGetData();
	  click.selectclickget.enableGetData();
	  return click.radioclickget.enableGetData();
	});


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	
	/**
	xxx
	 */
	var CheckboxClickData, ManualClickData, RadioClickData, SelectClickData, TextClickData,
	  __hasProp = {}.hasOwnProperty,
	  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

	ManualClickData = (function() {
	  function ManualClickData(type) {
	    this.type = type;
	    this.count = 0;
	    this.type = this.type;
	    this.name = "";
	    this.value = "";
	    this.valuearray = [];
	    this.dompath = "";
	    this.sendjson;
	  }

	  ManualClickData.prototype.sendData = function(object) {
	    this.object = object;
	    return parent.window.searchVM.clickdataArray.push(this.object);
	  };

	  ManualClickData.prototype.emptyData = function() {
	    this.name = "";
	    this.value = "";
	    this.valuearray.length = 0;
	    return this.dompath = "";
	  };

	  ManualClickData.prototype.sendJsonCompose = function(dom) {
	    var obj;
	    obj = {};
	    obj.name = $(dom).attr('name');
	    obj.dompath = "sss";
	    return obj;
	  };

	  ManualClickData.prototype.enableGetData = function(type) {
	    var self;
	    this.type = type;
	    self = this;
	    return $("input[type=" + this.type + "]").click(function(e) {
	      e.stopPropagation();
	      self.emptyData();
	      self.count++;
	      self.sendjson = self.sendJsonCompose($(this));
	      self.sendjson.count = self.count;
	      self.sendjson.type = this.type;
	      self.sendData(self.sendjson);
	      console.log("send ready");
	    });
	  };

	  return ManualClickData;

	})();

	TextClickData = (function(_super) {
	  __extends(TextClickData, _super);

	  function TextClickData() {
	    TextClickData.__super__.constructor.call(this, "text");
	  }

	  TextClickData.prototype.enableGetData = function() {
	    return TextClickData.__super__.enableGetData.call(this, "text");
	  };

	  return TextClickData;

	})(ManualClickData);

	SelectClickData = (function(_super) {
	  __extends(SelectClickData, _super);

	  function SelectClickData() {
	    SelectClickData.__super__.constructor.call(this, "select");
	    this.valuearray = [];
	    console.log(this.type);
	  }

	  SelectClickData.prototype.sendJsonCompose = function(dom) {
	    var obj;
	    obj = {};
	    obj.name = $(dom).attr('name');
	    obj.dompath = "sss";
	    obj.valuelist = [];
	    obj.labellist = [];
	    $(dom).find("option").each(function() {
	      obj.valuelist.push($(this).val());
	      obj.labellist.push($(this).html());
	    });
	    console.log($(dom).attr('id'));
	    return obj;
	  };

	  SelectClickData.prototype.enableGetData = function() {
	    var self;
	    self = this;
	    return $("select").click(function(e) {
	      e.stopPropagation();
	      self.emptyData();
	      self.count++;
	      self.sendjson = self.sendJsonCompose($(this));
	      self.sendjson.count = self.count;
	      self.sendjson.type = "select";
	      self.sendData(self.sendjson);
	      console.log("send ready");
	    });
	  };

	  return SelectClickData;

	})(ManualClickData);

	CheckboxClickData = (function(_super) {
	  __extends(CheckboxClickData, _super);

	  function CheckboxClickData() {
	    CheckboxClickData.__super__.constructor.call(this, "checkbox");
	  }

	  CheckboxClickData.prototype.sendJsonCompose = function(dom) {
	    var obj;
	    obj = {};
	    obj.name = $(dom).attr('name');
	    obj.value = $(dom).attr('value');
	    obj.label = $("label[for='" + this.id + "']").text();
	    obj.dompath = "sss";
	    return obj;
	  };

	  CheckboxClickData.prototype.enableGetData = function() {
	    return CheckboxClickData.__super__.enableGetData.call(this, "checkbox");
	  };

	  return CheckboxClickData;

	})(ManualClickData);

	RadioClickData = (function(_super) {
	  __extends(RadioClickData, _super);

	  function RadioClickData() {
	    RadioClickData.__super__.constructor.call(this, "radio");
	    this.valuearray = [];
	  }

	  RadioClickData.prototype.sendJsonCompose = function(dom) {
	    var obj;
	    obj = {};
	    obj.name = $(dom).attr('name');
	    obj.dompath = "sss";
	    obj.valuelist = [];
	    obj.labellist = [];
	    $("input[name=" + obj.name + "]").each(function() {
	      obj.valuelist.push(this.value);
	      return obj.labellist.push($("label[for='" + this.id + "']").text());
	    });
	    return obj;
	  };

	  RadioClickData.prototype.enableGetData = function() {
	    return RadioClickData.__super__.enableGetData.call(this, "radio");
	  };

	  return RadioClickData;

	})(ManualClickData);

	module.exports = {
	  textclickget: new TextClickData,
	  checkboxclickget: new CheckboxClickData,
	  selectclickget: new SelectClickData,
	  radioclickget: new RadioClickData
	};


/***/ }
/******/ ])