var Event, Responder, Type, fromArgs, type;

Responder = require("gesture").Responder;

fromArgs = require("fromArgs");

Event = require("Event");

Type = require("Type");

type = Type("Tappable");

type.inherits(Responder);

type.defineOptions({
  maxTapCount: Number.withDefault(1),
  maxTapDelay: Number.withDefault(2e308),
  preventDistance: Number.withDefault(2e308)
});

type.defineFrozenValues({
  maxTapCount: fromArgs("maxTapCount"),
  maxTapDelay: fromArgs("maxTapDelay"),
  preventDistance: fromArgs("preventDistance"),
  didTap: function() {
    return Event();
  }
});

type.defineValues({
  _tapCount: 0,
  _releaseTime: null
});

type.defineMethods({
  _isTapPrevented: function() {
    return this.preventDistance > Math.sqrt((Math.pow(this.gesture.dx, 2)) + (Math.pow(this.gesture.dy, 2)));
  },
  _resetTapCount: function() {
    this._tapCount = 0;
    return this._releaseTime = null;
  },
  _recognizeTap: function() {
    var now;
    now = Date.now();
    if ((this._releaseTime != null) && (now - this._releaseTime > this.maxTapDelay)) {
      this._resetTapCount();
    }
    this._releaseTime = now;
    this._tapCount += 1;
    this.didTap.emit(this._tapCount, this.gesture);
    if (this._tapCount === this.maxTapCount) {
      return this._resetTapCount();
    }
  }
});

type.overrideMethods({
  __onRelease: function() {
    this._isTapPrevented() || this._recognizeTap();
    return this.__super(arguments);
  },
  __onTerminate: function() {
    this._resetTapCount();
    return this.__super(arguments);
  }
});

module.exports = type.build();

//# sourceMappingURL=map/Tappable.map
