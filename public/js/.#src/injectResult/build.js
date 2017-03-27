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

	var util;

	util = __webpack_require__(1);

	$(document).ready(function() {
	  return util.enableOneClickHighLight();
	});


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var Util, util;

	Util = (function() {
	  function Util() {
	    this.initGetDomPathPlugin();
	    this.isHighLightEnabled = false;
	    this.isOneClickHighLightEnabled = false;
	    this.isAttrHighLightEnabled = false;
	    this.highlightClass = '__highlight';
	    this.permHighlightClass = '__perm-highlight';
	    this.attrHighlightClass = '__attr-highlight';
	    this.tuples = '';
	    window.onmessage = (function(_this) {
	      return function(e) {
	        if (e.data === 'clearOneClick') {
	          _this.enableOneClickHighLight();
	          _this.clearAddClassName();
	        }
	        if (e.data === 'clearTwoClick') {
	          _this.enableTwoClickHighLight();
	          _this.clearAddClassName();
	        }
	        if (e.data === 'enableOneClickHighLight') {
	          _this.enableOneClickHighLight();
	        }
	        if (e.data === 'enableTwoClickHighLight') {
	          _this.enableTwoClickHighLight();
	        }
	        if (e.data === 'enableAttrHighLight') {
	          return _this.enableAttrHighLight();
	        }
	      };
	    })(this);
	  }

	  Util.prototype.replaceAddClassName = function(str) {
	    var self;
	    self = this;
	    str = str.replace('.' + self.highlightClass, '').replace('.' + self.permHighlightClass, '').replace('.' + self.attrHighlightClass, '');
	    return str;
	  };

	  Util.prototype.clearAddClassName = function() {
	    return $('body *').removeClass(this.highlightClass).removeClass(this.permHighlightClass).removeClass(this.attrHighlightClass);
	  };

	  Util.prototype.initGetDomPathPlugin = function() {
	    var getClassStringForElement, getEqForElement, getIdClassStringForElement, self;
	    self = this;
	    getEqForElement = function(el) {
	      var string;
	      string = ":eq(" + ($(el).index()) + ")";
	      return string;
	    };
	    getClassStringForElement = function(el) {
	      var s, string;
	      string = el.tagName.toLowerCase();
	      if (el.className) {
	        s = el.className.trim().replace(/\s+/g, ".");
	        s = s.split('.');
	        if (s.length >= 2) {
	          s = s.slice(0, 2);
	        }
	        string += "." + s.join('.');
	      }
	      return string;
	    };
	    if (typeof $ !== "undefined" && $ !== null) {
	      $.fn.getClassNamePath = function(string) {
	        var el, p, resultStr;
	        if (typeof string === "undefined") {
	          string = true;
	        }
	        p = [];
	        el = $(this).first();
	        el.parents().not("html").each(function() {
	          p.push(getClassStringForElement(this));
	        });
	        p.reverse();
	        p.push(getClassStringForElement(el[0]));
	        resultStr = (string ? p.join(" > ") : p);
	        return self.replaceAddClassName(resultStr);
	      };
	    }
	    getIdClassStringForElement = function(el) {
	      var json;
	      return json = {
	        tagName: el.tagName,
	        id: el.id,
	        classList: el.className ? el.className.trim().replace(/\s+/g, ".").split('.') : []
	      };
	    };
	    return typeof $ !== "undefined" && $ !== null ? $.fn.getIdClassNamePath = function() {
	      var el, p;
	      p = [];
	      el = $(this).first();
	      el.parents().not("html").each(function() {
	        p.push(getIdClassStringForElement(this));
	      });
	      p.reverse();
	      p.push(getIdClassStringForElement(el[0]));
	      return p;
	    } : void 0;
	  };

	  Util.prototype.enableHighLight = function() {
	    var self;
	    self = this;
	    $('body *').mouseover(function(e) {
	      e.stopPropagation();
	      return $(this).addClass('highlight');
	    }).mouseout(function(e) {
	      e.stopPropagation();
	      return $(this).addClass('highlight');
	    });
	    return this.isHighLightEnabled = true;
	  };

	  Util.prototype.enableOneClickHighLight = function() {
	    var self;
	    self = this;
	    $('body *').off('mouseover').off('mouseout').off('click').removeClass(self.permHighlightClass).mouseover(function(e) {
	      var classNamePath;
	      e.stopPropagation();
	      classNamePath = $(this).getClassNamePath();
	      self.allEls = $(classNamePath);
	      return self.allEls.addClass(self.highlightClass);
	    }).mouseout(function(e) {
	      var _ref;
	      e.stopPropagation();
	      return (_ref = self.allEls) != null ? _ref.removeClass(self.highlightClass) : void 0;
	    }).click(function(e) {
	      var classNamePath, _ref, _ref1;
	      e.stopPropagation();
	      e.preventDefault();
	      classNamePath = $(this).getClassNamePath();
	      self.allEls.addClass(self.permHighlightClass);
	      if ((_ref = parent.window.resultVM) != null) {
	        _ref.selectorSimpleStr = classNamePath;
	      }
	      if ((_ref1 = parent.window.resultVM) != null) {
	        _ref1.isTuplesSelected = true;
	      }
	      return self.tuples = classNamePath;
	    });
	    return this.isOneClickHighLightEnabled = true;
	  };

	  Util.prototype.enableTwoClickHighLight = function() {
	    var self, twoClicks;
	    self = this;
	    twoClicks = [];
	    return $('body *').off('mouseover').off('mouseout').off('click').removeClass(self.permHighlightClass).mouseover(function(e) {
	      e.stopPropagation();
	      return $(e.target).addClass(self.highlightClass);
	    }).mouseout(function(e) {
	      e.stopPropagation();
	      return $(e.target).removeClass(self.highlightClass);
	    }).click(function(e) {
	      var _ref;
	      $(e.target).addClass(self.permHighlightClass);
	      e.stopPropagation();
	      e.preventDefault();
	      if (twoClicks.length <= 1) {
	        twoClicks.push($(e.target));
	      }
	      if (twoClicks.length === 2) {
	        $(self.getTuples(twoClicks)).addClass(self.permHighlightClass);
	        if ((_ref = parent.window.resultVM) != null) {
	          _ref.isTuplesSelected = true;
	        }
	        return twoClicks = [];
	      }
	    });
	  };

	  Util.prototype._intersectArray = function(a, b) {
	    return a.filter(function(item) {
	      return b.indexOf(item) !== -1;
	    });
	  };

	  Util.prototype._intersectPath = function(path1, path2, common) {
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
	        r.tagName = ":eq(" + (pointer.index()) + ")" + r.tagName;
	      }
	      pointer = pointer.parent();
	    }
	    return result;
	  };

	  Util.prototype._json2string = function(json) {
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
	  };

	  Util.prototype._pathToJQuerySelector = function(path) {
	    var json, s, self, stringArray, _i, _len;
	    self = this;
	    stringArray = [];
	    for (_i = 0, _len = path.length; _i < _len; _i++) {
	      json = path[_i];
	      stringArray.push(self._json2string(json));
	    }
	    s = stringArray.join(' > ');
	    return self.replaceAddClassName(s);
	  };

	  Util.prototype.getTuples = function(clicks) {
	    var common, intersectionPath, intersectionPathSelector, path1, path2, self, _ref, _ref1, _ref2;
	    self = this;
	    path1 = clicks[0].getIdClassNamePath();
	    path2 = clicks[1].getIdClassNamePath();
	    common = clicks[0].parents().has(clicks[1]).first();
	    if ((_ref = parent.window.resultVM) != null) {
	      _ref.selectorAdvancedStr1 = self._pathToJQuerySelector(path1);
	    }
	    if ((_ref1 = parent.window.resultVM) != null) {
	      _ref1.selectorAdvancedStr2 = self._pathToJQuerySelector(path2);
	    }
	    intersectionPath = self._intersectPath(path1, path2, common);
	    intersectionPathSelector = self._pathToJQuerySelector(intersectionPath);
	    if ((_ref2 = parent.window.resultVM) != null) {
	      _ref2.selectorAdvancedStr = intersectionPathSelector;
	    }
	    self.tuples = intersectionPathSelector;
	    return intersectionPathSelector;
	  };

	  Util.prototype.enableAttrHighLight = function() {
	    var self;
	    self = this;
	    $('body *').off('mouseover').off('mouseout').off('click').removeClass(self.attrHighlightClass).mouseover(function(e) {
	      var classNamePath;
	      e.stopPropagation();
	      classNamePath = $(this).getClassNamePath();
	      self.allEls = $(classNamePath);
	      return self.allEls.addClass(self.highlightClass);
	    }).mouseout(function(e) {
	      var _ref;
	      e.stopPropagation();
	      return (_ref = self.allEls) != null ? _ref.removeClass(self.highlightClass) : void 0;
	    }).click(function(e) {
	      var classNamePath, _ref;
	      e.stopPropagation();
	      e.preventDefault();
	      if (self.tuples && $(self.tuples).has(e.target).length) {
	        classNamePath = $(this).getClassNamePath().split(' > ').slice(self.tuples.split(' > ').length).join(' > ');
	        console.log(classNamePath);
	        classNamePath = self.replaceAddClassName(classNamePath);
	        $("" + self.tuples + " > " + classNamePath).addClass(self.attrHighlightClass);
	        return (_ref = parent.window.resultVM) != null ? _ref.setAttr(classNamePath) : void 0;
	      }
	    });
	    return this.isAttrHighLightEnabled = true;
	  };

	  return Util;

	})();

	util = new Util;

	module.exports = util;


/***/ }
/******/ ])