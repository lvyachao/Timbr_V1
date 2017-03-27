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

	$(document).ready(function() {
	  var addVC, util;
	  util = __webpack_require__(1);
	  util.initGetDomPathPlugin();
	  addVC = __webpack_require__(2);
	  addVC.addvueclass.action();
	  return window.injectVM = __webpack_require__(3);
	});


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var Util, util;

	Util = (function() {
	  var getIdClassJsonForElement;

	  function Util() {
	    this._absolutePath();
	  }

	  Util.prototype._absolutePath = function() {};

	  Util.prototype.initGetDomPathPlugin = function() {
	    return typeof $ !== "undefined" && $ !== null ? $.fn.getIdClassNamePath = function() {
	      var el, p;
	      p = [];
	      el = $(this).first();
	      el.parents().not("html").each(function() {
	        p.push(getIdClassJsonForElement(this));
	      });
	      p.reverse();
	      p.push(getIdClassJsonForElement(el[0]));
	      return p;
	    } : void 0;
	  };

	  getIdClassJsonForElement = function(el) {
	    var json;
	    return json = {
	      tagName: el.tagName,
	      id: el.id,
	      classList: el.className ? el.className.trim().replace(/\s+/g, ".").split('.') : []
	    };
	  };

	  return Util;

	})();

	util = new Util;

	module.exports = util;


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var AddVueClass,
	  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

	AddVueClass = (function() {
	  AddVueClass.prototype.tempradionamearray = [];

	  function AddVueClass() {
	    this.inputCount = 0;
	  }

	  AddVueClass.prototype.action = function() {
	    var self;
	    self = this;
	    $("input[type='text']").each(function() {
	      $(this).attr("v-model", "inputDataArray[" + self.inputCount + "].value");
	      $(this).attr('timbr_count', self.inputCount);
	      self.inputCount++;
	    });
	    $("input[type='checkbox']").each(function() {
	      $(this).attr("v-model", "inputDataArray[" + self.inputCount + "].checked");
	      $(this).attr('timbr_count', self.inputCount);
	      self.inputCount++;
	    });
	    self.inputCount--;
	    $("input[type='radio']").each(function() {
	      var _ref;
	      if (_ref = this.name, __indexOf.call(self.tempradionamearray, _ref) >= 0) {
	        $(this).attr("v-model", "inputDataArray[" + self.inputCount + "].picked");
	        $(this).attr('timbr_count', self.inputCount);
	      } else {
	        self.inputCount++;
	        $(this).attr("v-model", "inputDataArray[" + self.inputCount + "].picked");
	        $(this).attr('timbr_count', self.inputCount);
	        self.tempradionamearray.push(this.name);
	      }
	    });
	    self.inputCount++;
	    return $("select").each(function() {
	      $(this).attr("v-model", "inputDataArray[" + self.inputCount + "].selected");
	      $(this).attr("options", "inputDataArray[" + self.inputCount + "].options");
	      $(this).attr('timbr_count', self.inputCount);
	      self.inputCount++;
	    });
	  };

	  return AddVueClass;

	})();

	module.exports = {
	  addvueclass: new AddVueClass
	};


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var injectVM,
	  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

	injectVM = new Vue({
	  el: 'body',
	  ready: function() {
	    this.checkCurrentTabCount();
	    this.initaldataArray();
	    this.addTabClick();
	    this.clickReaction();
	    return this.$watch('inputDataArray', function(val) {
	      this.synchronousDatatoParent(val);
	    }, true);
	  },
	  data: {
	    currentTabCount: 0,
	    inputCount: 0,
	    inputDataArray: [],
	    clickCount: 0,
	    tempradionamearray: []
	  },
	  methods: {
	    checkCurrentTabCount: function() {
	      return this.currentTabCount = parent.window.searchVM.tabCount;
	    },
	    _pathToJQuerySelector: function(path) {
	      var json, s, self, stringArray, _i, _len;
	      self = this;
	      stringArray = [];
	      for (_i = 0, _len = path.length; _i < _len; _i++) {
	        json = path[_i];
	        stringArray.push(self._json2string(json));
	      }
	      return s = stringArray.join(' > ');
	    },
	    _json2string: function(json) {
	      var s;
	      s = "";
	      s += json.tagName;
	      if (json.id !== '') {
	        s += "#" + json.id;
	      }
	      if (json.classList.length !== 0) {
	        s += "." + (json.classList.join('.'));
	      }
	      return s;
	    },
	    _getClicksPath: function(clicks) {
	      var common, intersectionPath, intersectionPathSelector, path1, path2, self;
	      self = this;
	      path1 = clicks[0].getIdClassNamePath();
	      path2 = clicks[1].getIdClassNamePath();
	      common = clicks[0].parents().has(clicks[1]).first();
	      intersectionPath = self._intersectPath(path1, path2, common);
	      intersectionPathSelector = self._pathToJQuerySelector(intersectionPath);
	      return intersectionPathSelector;
	    },
	    _intersectArray: function(a, b) {
	      return a.filter(function(item) {
	        return b.indexOf(item) !== -1;
	      });
	    },
	    _intersectPath: function(path1, path2, common) {
	      var commonIndex, i, json, pointer, r, result, self, _i, _j, _ref, _ref1;
	      self = this;
	      result = [];
	      pointer = common;
	      for (i = _i = 0, _ref = Math.min(path1.length, path2.length); 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
	        if (path1[i].tagName !== path2[i].tagName) {
	          return result;
	        }
	        json = {
	          tagName: path1[i].tagName,
	          id: path1[i].id !== path2[i].id ? '' : path1[i].id,
	          classList: self._intersectArray(path1[i].classList, path2[i].classList)
	        };
	        result.push(json);
	      }
	      commonIndex = common.getIdClassNamePath().length - 1;
	      _ref1 = result.slice(0, +commonIndex + 1 || 9e9);
	      for (_j = _ref1.length - 1; _j >= 0; _j += -1) {
	        r = _ref1[_j];
	        if (pointer.parent().children(self._json2string(r)).length > 1) {
	          r.tagName = "" + r.tagName + ":nth-child(" + (pointer.index() + 1) + ")";
	        }
	        pointer = pointer.parent();
	      }
	      return result;
	    },
	    initaldataArray: function() {
	      var self;
	      self = this;
	      $("input[type='text']").each(function() {
	        var tempindex;
	        self.inputDataArray[self.inputCount] = {
	          count: self.inputCount,
	          type: this.type,
	          name: this.name,
	          dompath: self._getClicksPath([$(this), $(this)]),
	          value: "",
	          timbr_clicked: false,
	          MulMode: false
	        };
	        tempindex = $(this).index() + 1;
	        self.inputDataArray[self.inputCount].dompath = self.inputDataArray[self.inputCount].dompath + ":nth-child(" + tempindex + ")";
	        return self.inputCount++;
	      });
	      $("input[type='checkbox']").each(function() {
	        var tempchecked, tempindex;
	        if (self.inputDataArray[self.inputCount] != null) {
	          tempchecked = true;
	        }
	        self.inputDataArray[self.inputCount] = {
	          count: self.inputCount,
	          type: this.type,
	          name: this.name,
	          dompath: self._getClicksPath([$(this), $(this)]),
	          value: this.value,
	          label: $("label[for='" + this.id + "']").text().trim(),
	          timbr_clicked: false
	        };
	        tempindex = $(this).index() + 1;
	        self.inputDataArray[self.inputCount].dompath += ":nth-child(" + tempindex + ")";
	        if (tempchecked != null) {
	          self.inputDataArray[self.inputCount].checked = true;
	        }
	        return self.inputCount++;
	      });
	      $("input[type='radio']").each(function() {
	        var templabellist, templabeltovalue, temppicked, tempvaluelist, _i, _ref;
	        if (_ref = this.name, __indexOf.call(self.tempradionamearray, _ref) < 0) {
	          if (self.inputDataArray[self.inputCount] != null) {
	            temppicked = self.inputDataArray[self.inputCount].picked;
	          }
	          tempvaluelist = [];
	          templabellist = [];
	          $("input[name=" + this.name + "]").each(function() {
	            tempvaluelist.push(this.value);
	            return templabellist.push($("label[for='" + this.id + "']").text().trim());
	          });
	          templabeltovalue = {};
	          _i = 0;
	          while (_i < tempvaluelist.length) {
	            templabeltovalue[tempvaluelist[_i]] = templabellist[_i];
	            _i++;
	          }
	          self.inputDataArray[self.inputCount] = {
	            count: self.inputCount,
	            type: this.type,
	            name: this.name,
	            dompath: self._getClicksPath([$(this), $(this)]),
	            value: this.value,
	            label: $("label[for='" + this.id + "']").text().trim(),
	            valueandlabel: templabeltovalue,
	            picked: this.value,
	            timbr_clicked: false
	          };
	          if (temppicked != null) {
	            self.inputDataArray[self.inputCount].picked = temppicked;
	          }
	          self.inputCount++;
	          return self.tempradionamearray.push(this.name);
	        } else {

	        }
	      });
	      return $("select").each(function() {
	        var tempindex, templabellist, templabeltovalue, tempvaluelist, _j;
	        tempvaluelist = [];
	        templabellist = [];
	        $(this).find("option").each(function() {
	          tempvaluelist.push($(this).val());
	          return templabellist.push($(this).html());
	        });
	        templabeltovalue = {};
	        _j = 0;
	        while (_j < tempvaluelist.length) {
	          templabeltovalue[tempvaluelist[_j]] = templabellist[_j];
	          _j++;
	        }
	        self.inputDataArray[self.inputCount] = {
	          count: self.inputCount,
	          type: "select",
	          name: this.name,
	          dompath: self._getClicksPath([$(this), $(this)]),
	          value: this.value,
	          valueandlabel: templabeltovalue,
	          timbr_clicked: false,
	          selected: this.value
	        };
	        tempindex = $(this).index() + 1;
	        self.inputDataArray[self.inputCount].dompath = self.inputDataArray[self.inputCount].dompath + ":nth-child(" + tempindex + ")";
	        return self.inputCount++;
	      });
	    },
	    clickReaction: function() {
	      var self;
	      self = this;
	      $('body').on({
	        mouseenter: function() {
	          $(this).addClass('dis');
	        },
	        mouseleave: function() {
	          $(this).removeClass('dis');
	        }
	      }, '.timbr_highlight');
	      $("input, select").click(function(e) {
	        var tempcount;
	        tempcount = $(this).attr('timbr_count');
	        if (self.inputDataArray[tempcount].timbr_clicked === false) {
	          self.inputDataArray[tempcount].timbr_clicked = true;
	          self.inputDataArray[tempcount].timbr_clickedcount = self.clickCount;
	          return self.clickCount++;
	        }
	      });
	      return $("input[type='radio']").click(function(e) {
	        var tempcount;
	        tempcount = $(this).attr('timbr_count');
	        return self.inputDataArray[tempcount].dompath = self._getClicksPath([$(this), $(this)]);
	      });
	    },
	    addHighlightDiv: function(count, top, left, width, height) {
	      var tempmath;
	      return tempmath = Math.floor(Math.random() * 12) + 1;
	    },
	    addTabClick: function() {
	      var self;
	      self = this;
	      return $("input[type='submit'], button, input[type='button'], a[href]").off('click').off('submit').off('onclick').click(function(e) {
	        var tempDompath;
	        e.preventDefault();
	        e.stopPropagation();
	        tempDompath = self._getClicksPath([$(this), $(this)]);
	        return parent.window.searchVM.openNewTabFromChildren(tempDompath, self.clickCount);
	      });
	    },
	    synchronousDatatoParent: function(object) {
	      return parent.window.searchVM.synchronousDatafromChildren(object);
	    }
	  }
	});

	module.exports = injectVM;


/***/ }
/******/ ])