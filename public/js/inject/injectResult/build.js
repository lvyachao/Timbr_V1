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
	  var result, util;
	  util = __webpack_require__(1);
	  return result = __webpack_require__(2);
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

	var Result,
	  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	Result = (function() {
	  function Result() {
	    this._setParentOutput = __bind(this._setParentOutput, this);
	    this.isHighLightEnabled = false;
	    this.isOneClickHighLightEnabled = false;
	    this.isTwoClickHighLightEnabled = false;
	    this.isAttrHighLightEnabled = false;
	    this.highlightClass = '__highlight';
	    this.permHighlightClass = '__perm-highlight';
	    this.attrHighlightClass = '__attr-highlight';
	    this.tuples = '';
	    this.parentOutput = 'selectorSimpleStr';
	    this._initGetDomPathPlugin();
	    this._bindEvents();
	  }

	  Result.prototype.api = {
	    enableOneClickHighLight: Result.enableOneClickHighLight,
	    enableTwoClickHighLight: Result.enableTwoClickHighLight,
	    enableAttrHighLight: Result.enableAttrHighLight
	  };

	  Result.prototype._bindEvents = function() {
	    var self, _events;
	    self = this;
	    _events = {
	      clearHighLight: function() {
	        return self._clearHighLight();
	      },
	      clearOneClick: function() {
	        self._clearHighLight();
	        return self.enableOneClickHighLight();
	      },
	      clearTwoClick: function() {
	        self._clearHighLight();
	        return self.enableTwoClickHighLight();
	      },
	      enableOneClickHighLight: function() {
	        self.parentOutput = 'selectorSimpleStr';
	        return self.enableOneClickHighLight();
	      },
	      enableTwoClickHighLight: function() {
	        self.parentOutput = 'selectorAdvancedStr';
	        return self.enableTwoClickHighLight();
	      },
	      enableAttrHighLight: function() {
	        return self.enableAttrHighLight();
	      },
	      enableNextButtonHighLight: function(e, nextButtonMode) {
	        self._clearHighLight();
	        if (nextButtonMode === 'button') {
	          self.parentOutput = 'selectorNext';
	          return self.enableOneClickHighLight();
	        } else if (nextButtonMode === 'links') {
	          self.parentOutput = 'selectorNext';
	          return self.enableTwoClickHighLight({
	            mustHaveLinks: true
	          });
	        }
	      },
	      absolutePath: function(e, url) {
	        return self.absolutePath(url);
	      }
	    };
	    return $('body').on(_events);
	  };

	  Result.prototype._clearHighLight = function() {
	    return $('*').off('mouseover').off('mouseout').off('click').removeClass(this.highlightClass).removeClass(this.permHighlightClass).removeClass(this.attrHighlightClass);
	  };

	  Result.prototype._setParentOutput = function(val) {
	    var escapedVal, _ref;
	    escapedVal = this._replaceAddClassName(val);
	    return (_ref = parent.window.resultVM) != null ? _ref.$set(this.parentOutput, escapedVal) : void 0;
	  };

	  Result.prototype._replaceAddClassName = function(str) {
	    var self;
	    self = this;
	    str = str.replace('.' + self.highlightClass, '').replace('.' + self.permHighlightClass, '').replace('.' + self.attrHighlightClass, '');
	    return str;
	  };

	  Result.prototype._initGetDomPathPlugin = function() {
	    var getClassStringForElement, getIdClassJsonForElement, self;
	    self = this;
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
	      $.fn.getClassNamePath = function() {
	        var el, p;
	        p = [];
	        el = $(this).first();
	        el.parents().not("html").each(function() {
	          p.push(getClassStringForElement(this));
	        });
	        p.reverse();
	        p.push(getClassStringForElement(el[0]));
	        return p.join(' > ');
	      };
	    }
	    getIdClassJsonForElement = function(el) {
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
	        p.push(getIdClassJsonForElement(this));
	      });
	      p.reverse();
	      p.push(getIdClassJsonForElement(el[0]));
	      return p;
	    } : void 0;
	  };

	  Result.prototype.enableOneClickHighLight = function() {
	    var self;
	    self = this;
	    $('*').off('mouseover').off('mouseout').off('click').removeClass(self.permHighlightClass).mouseover(function(e) {
	      e.stopPropagation();
	      return $(this).addClass(self.highlightClass);
	    }).mouseout(function(e) {
	      e.stopPropagation();
	      return $(this).removeClass(self.highlightClass);
	    }).click(function(e) {
	      var classNamePath, _ref;
	      e.stopPropagation();
	      e.preventDefault();
	      classNamePath = self._getClicksPath([$(this), $(this)]);
	      $(classNamePath).addClass(self.permHighlightClass);
	      self._setParentOutput(classNamePath);
	      if ((_ref = parent.window.resultVM) != null) {
	        _ref.isTuplesSelected = true;
	      }
	      return self.tuples = classNamePath;
	    });
	    return this.isOneClickHighLightEnabled = true;
	  };

	  Result.prototype.enableTwoClickHighLight = function(options) {
	    var self, twoClicks;
	    self = this;
	    twoClicks = [];
	    $('*').off('mouseover').off('mouseout').off('click').removeClass(self.permHighlightClass).mouseover(function(e) {
	      e.stopPropagation();
	      return $(e.target).addClass(self.highlightClass);
	    }).mouseout(function(e) {
	      e.stopPropagation();
	      return $(e.target).removeClass(self.highlightClass);
	    }).click(function(e) {
	      var intersectionPathSelector, _ref;
	      $(e.target).addClass(self.permHighlightClass);
	      e.stopPropagation();
	      e.preventDefault();
	      if (twoClicks.length <= 1) {
	        twoClicks.push($(e.target));
	      }
	      if (twoClicks.length === 2) {
	        intersectionPathSelector = self._getClicksPath(twoClicks);
	        if ((options != null ? options.mustHaveLinks : void 0) === true) {
	          intersectionPathSelector = self._shrimPathToHaveLinks(intersectionPathSelector);
	        }
	        if ((options != null ? options.looseSelector : void 0) === true) {
	          intersectionPathSelector = self._shrimPathToLength(intersectionPathSelector, options.looseSelectorLen);
	        }
	        $(intersectionPathSelector).addClass(self.permHighlightClass);
	        self._setParentOutput(intersectionPathSelector);
	        self.tuples = intersectionPathSelector;
	        if ((_ref = parent.window.resultVM) != null) {
	          _ref.isTuplesSelected = true;
	        }
	        return twoClicks = [];
	      }
	    });
	    return this.isTwoClickHighLightEnabled = true;
	  };

	  Result.prototype._shrimPathToLength = function(selector, len) {
	    var sArray;
	    sArray = selector.split(' > ');
	    return sArray.slice(-len).join(' > ');
	  };

	  Result.prototype._shrimPathToHaveLinks = function(selector) {
	    var s, sArray;
	    sArray = selector.split(' > ');
	    sArray.pop();
	    while (sArray.length > 0) {
	      s = sArray.join(' > ') + ' a';
	      if ($(s).length) {
	        return s;
	      } else {
	        sArray.pop();
	      }
	    }
	    return selector;
	  };

	  Result.prototype._intersectArray = function(a, b) {
	    return a.filter(function(item) {
	      return b.indexOf(item) !== -1;
	    });
	  };

	  Result.prototype._intersectPath = function(path1, path2, common) {
	    var commonIndex, i, json, pointer, r, result, self, _i, _j, _ref, _ref1;
	    self = this;
	    result = [];
	    pointer = common;
	    console.log(path1);
	    console.log(path2);
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
	    console.log(commonIndex);
	    console.log(result);
	    _ref1 = result.slice(0, +commonIndex + 1 || 9e9);
	    for (_j = _ref1.length - 1; _j >= 0; _j += -1) {
	      r = _ref1[_j];
	      if (pointer.parent().children(self._json2string(r)).length > 1) {
	        r.tagName = "" + r.tagName + ":nth-child(" + (pointer.index() + 1) + ")";
	      }
	      pointer = pointer.parent();
	    }
	    return result;
	  };

	  Result.prototype._json2string = function(json) {
	    var s;
	    s = "";
	    s += json.tagName;
	    if (json.id !== '') {
	      s += "#" + json.id;
	    }
	    if (json.classList.length !== 0) {
	      s += "." + (json.classList.join('.'));
	    }
	    return this._replaceAddClassName(s);
	  };

	  Result.prototype._pathToJQuerySelector = function(path) {
	    var json, s, self, stringArray, _i, _len;
	    self = this;
	    stringArray = [];
	    for (_i = 0, _len = path.length; _i < _len; _i++) {
	      json = path[_i];
	      stringArray.push(self._json2string(json));
	    }
	    return s = stringArray.join(' > ');
	  };

	  Result.prototype._getClicksPath = function(clicks) {
	    var common, intersectionPath, intersectionPathSelector, path1, path2, self;
	    self = this;
	    path1 = clicks[0].getIdClassNamePath();
	    path2 = clicks[1].getIdClassNamePath();
	    common = clicks[0].parents().has(clicks[1]).first();
	    intersectionPath = self._intersectPath(path1, path2, common);
	    intersectionPathSelector = self._pathToJQuerySelector(intersectionPath);
	    return intersectionPathSelector;
	  };

	  Result.prototype.enableAttrHighLight = function() {
	    var self;
	    self = this;
	    $(self.tuples).addClass(self.permHighlightClass);
	    $('*').off('mouseover').off('mouseout').off('click').removeClass(self.attrHighlightClass).mouseover(function(e) {
	      var classNamePath;
	      e.stopPropagation();
	      classNamePath = $(this).getClassNamePath();
	      self.allEls = $(classNamePath).filter(function(i, el) {
	        if ($(self.tuples).has(el).length) {
	          return true;
	        } else {
	          return false;
	        }
	      });
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
	        classNamePath = self._replaceAddClassName(classNamePath);
	        classNamePath = "" + classNamePath + ":nth-child(" + ($(e.target).index() + 1) + ")";
	        $("" + self.tuples + " > " + classNamePath).addClass(self.attrHighlightClass);
	        return (_ref = parent.window.resultVM) != null ? _ref.setAttr(classNamePath) : void 0;
	      }
	    });
	    return this.isAttrHighLightEnabled = true;
	  };

	  return Result;

	})();

	module.exports = new Result;


/***/ }
/******/ ])