var Event, Responder, Type, type;

Responder = require("gesture").Responder;

Event = require("event");

Type = require("Type");

type = Type("Tappable");

type.inherits(Responder);

type.optionTypes = {
  maxTapCount: Number,
  maxTapDelay: Number,
  preventDistance: Number
};

type.optionDefaults = {
  maxTapCount: 1,
  maxTapDelay: 2e308,
  preventDistance: 2e308
};

type.defineFrozenValues({
  maxTapCount: function(options) {
    return options.maxTapCount;
  },
  maxTapDelay: function(options) {
    return options.maxTapDelay;
  },
  preventDistance: function(options) {
    return options.preventDistance;
  },
  didTap: function() {
    return Event();
  }
});

type.defineValues({
  _tapCount: 0,
  _releaseTime: null
});

type.defineMethods({
  _resetTapCount: function() {
    this._tapCount = 0;
    return this._releaseTime = null;
  }
});

type.overrideMethods({
  __onTouchMove: function() {
    var distance;
    if (this.isCaptured) {
      distance = Math.sqrt((Math.pow(this.gesture.dx, 2)) + (Math.pow(this.gesture.dy, 2)));
      if (distance >= this.preventDistance) {
        this.terminate();
        return;
      }
    }
    return this.__super(arguments);
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
    return this.__super(arguments);
  },
  __onTerminate: function() {
    this._resetTapCount();
    return this.__super(arguments);
  }
});

module.exports = type.build();

//# sourceMappingURL=../../map/src/Tappable.map
