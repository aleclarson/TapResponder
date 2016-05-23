var Factory, Responder;

Responder = require("gesture").Responder;

Factory = require("factory");

module.exports = Factory("Touchable", {
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
  initFrozenValues: function() {
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
  _onPanResponderMove: function() {
    var distance;
    if (!this._gesture) {
      return;
    }
    distance = Math.sqrt((Math.pow(this._gesture.dx, 2)) + (Math.pow(this._gesture.dy, 2)));
    if (distance >= this.preventDistance) {
      return this._onPanResponderTerminate();
    }
    return Responder.prototype._onPanResponderMove.call(this);
  },
  _onPanResponderRelease: function() {
    var now;
    if (!this._gesture) {
      return;
    }
    now = Date.now();
    if ((this._releaseTime != null) && (now - this._releaseTime > this.maxTapDelay)) {
      this._resetTapCount();
    }
    this._releaseTime = now;
    this._tapCount += 1;
    this.didTap.emit(this._tapCount, this._gesture);
    if (this._tapCount === this.maxTapCount) {
      this._resetTapCount();
    }
    return Responder.prototype._onPanResponderRelease.call(this);
  }
});

//# sourceMappingURL=../../map/src/Tappable.map
