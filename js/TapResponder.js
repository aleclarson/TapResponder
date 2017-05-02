// Generated by CoffeeScript 1.12.4
var Event, Responder, Type, emptyFunction, type;

Responder = require("gesture").Responder;

emptyFunction = require("emptyFunction");

Event = require("eve");

Type = require("Type");

type = Type("TapResponder");

type.inherits(Responder);

type.defineArgs(function() {
  return {
    types: {
      maxTapCount: Number,
      maxTapDelay: Number,
      maxReleaseDelay: Number,
      preventDistance: Number
    },
    defaults: {
      maxTapCount: 1,
      maxTapDelay: 2e308,
      maxReleaseDelay: 2e308,
      preventDistance: 2e308
    }
  };
});

type.defineFrozenValues(function(options) {
  return {
    maxTapCount: options.maxTapCount,
    maxTapDelay: options.maxTapDelay,
    maxReleaseDelay: options.maxReleaseDelay,
    preventDistance: options.preventDistance,
    didTap: Event(),
    _hasMovedTooFar: this.preventDistance === 2e308 ? emptyFunction.thatReturnsFalse : void 0
  };
});

type.defineValues({
  _tapCount: 0,
  _lastTapTime: null
});

type.defineMethods({
  _hasMovedTooFar: function() {
    return this.preventDistance < Math.sqrt((Math.pow(this._gesture.dx, 2)) + (Math.pow(this._gesture.dy, 2)));
  },
  _resetTapCount: function() {
    this._tapCount = 0;
    this._lastTapTime = null;
  },
  _didTap: function() {
    var elapsedTime, now;
    now = Date.now();
    elapsedTime = now - this._grantTime;
    if (this.maxReleaseDelay < elapsedTime) {
      return;
    }
    if (this._lastTapTime !== null) {
      elapsedTime = now - this._lastTapTime;
      if (this.maxTapDelay < elapsedTime) {
        this._resetTapCount();
      }
    }
    this._tapCount += 1;
    this._lastTapTime = now;
    this._gesture.tapCount = this._tapCount;
    this.didTap.emit(this._gesture);
    if (this._tapCount === this.maxTapCount) {
      this._resetTapCount();
    }
  }
});

type.overrideMethods({
  __onGrant: function() {
    this._grantTime = Date.now();
    return this.__super(arguments);
  },
  __onTouchMove: function(event) {
    this._gesture.__onTouchMove(event);
    if (this._hasMovedTooFar()) {
      this.terminate(event.nativeEvent);
      return;
    }
    this.didTouchMove.emit(this._gesture, event);
  },
  __onRelease: function(event, finished) {
    if (finished) {
      this._didTap();
    } else {
      this._resetTapCount();
    }
    this._grantTime = null;
    return this.__super(arguments);
  }
});

module.exports = type.build();