var Event, Factory, Responder, define;

Responder = require("gesture").Responder;

Factory = require("factory");

define = require("define");

Event = require("event");

module.exports = Factory("Tappable", {
  kind: Responder,
  optionTypes: {
    maxTapCount: Number,
    maxTapDelay: Number,
    preventDistance: Number
  },
  optionDefaults: {
    maxTapCount: 1,
    maxTapDelay: Infinity,
    preventDistance: Infinity
  },
  initFrozenValues: function(options) {
    return {
      maxTapCount: options.maxTapCount,
      maxTapDelay: options.maxTapDelay,
      preventDistance: options.preventDistance,
      didTap: Event()
    };
  },
  initValues: function() {
    return {
      _tapCount: 0,
      _releaseTime: null
    };
  },
  _resetTapCount: function() {
    this._tapCount = 0;
    return this._releaseTime = null;
  },
  __onTouchMove: function() {
    var distance;
    if (this.isCaptured) {
      distance = Math.sqrt((Math.pow(this.gesture.dx, 2)) + (Math.pow(this.gesture.dy, 2)));
      if (distance >= this.preventDistance) {
        this.terminate();
        return;
      }
    }
    return Responder.prototype.__onTouchMove.apply(this, arguments);
  },
  __onRelease: function() {
    var now;
    now = Date.now();
    if ((this._releaseTime != null) && (now - this._releaseTime > this.maxTapDelay)) {
      this._resetTapCount();
    }
    this._releaseTime = now;
    this._tapCount += 1;
    this.didTap.emit(this._tapCount, this.gesture);
    if (this._tapCount === this.maxTapCount) {
      this._resetTapCount();
    }
    return Responder.prototype.__onRelease.apply(this, arguments);
  },
  __onTerminate: function() {
    this._resetTapCount();
    return Responder.prototype.__onTerminate.apply(this, arguments);
  }
});

//# sourceMappingURL=../../map/src/Tappable.map
