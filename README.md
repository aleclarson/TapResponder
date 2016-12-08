
# TapResponder v1.1.1 [![stable](http://badges.github.io/stability-badges/dist/stable.svg)](http://github.com/badges/stability-badges)

A [`Gesture.Responder`](https://github.com/aleclarson/gesture#gestureresponder) for detecting taps on a `View`.

```coffee
TapResponder = require "TapResponder"

tap = TapResponder
  maxTapCount: 2      # The amount of taps before the tap count is reset.
  maxTapDelay: 300    # The number of milliseconds before the tap count is reset.
  preventDistance: 10 # How far can the finger move until a tap is unrecognizable.

listener = tap.didTap (taps, gesture) ->
  console.log "taps: " + taps

listener = tap.didTouchStart (gesture) ->
  console.log "A new finger touched the screen!"

listener = tap.didTouchEnd (gesture) ->
  console.log "One or more fingers stopped touching!"

render: (props) ->
  Object.assign props, tap.touchHandlers
  return <View {...props} />
```
