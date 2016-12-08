
# tappable v1.1.1 [![stable](http://badges.github.io/stability-badges/dist/stable.svg)](http://github.com/badges/stability-badges)

A [`Gesture.Responder`](https://github.com/aleclarson/gesture#gestureresponder) for detecting taps on a `View`.

```coffee
Tappable = require "tappable"

tap = Tappable
  maxTapCount: 2      # The amount of taps before the tap count is reset.
  maxTapDelay: 300    # The number of milliseconds before the tap count is reset.
  preventDistance: 10 # How far can the finger move until a tap is unrecognizable.

tap.onTap (taps, gesture) ->
  console.log "taps: " + taps

tap.onTouchStart (gesture) ->
  # Detect an 'onPressIn' event!

tap.onTouchEnd (gesture) ->
  # Detect an 'onPressOut' event!

# Mix this into the props of a View!
tap.touchHandlers
```
