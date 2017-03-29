
{ Responder } = require "gesture"

emptyFunction = require "emptyFunction"
Event = require "eve"
Type = require "Type"

type = Type "TapResponder"

type.inherits Responder

type.defineArgs ->

  types:
    maxTapCount: Number
    maxTapDelay: Number
    maxReleaseDelay: Number
    preventDistance: Number

  defaults:
    maxTapCount: 1
    maxTapDelay: Infinity
    maxReleaseDelay: Infinity
    preventDistance: Infinity

type.defineFrozenValues (options) ->

  maxTapCount: options.maxTapCount

  maxTapDelay: options.maxTapDelay

  maxReleaseDelay: options.maxReleaseDelay

  preventDistance: options.preventDistance

  didTap: Event()

  _hasMovedTooFar: emptyFunction.thatReturnsFalse if @preventDistance is Infinity

type.defineValues

  _tapCount: 0

  _lastTapTime: null

type.defineMethods

  _hasMovedTooFar: ->
    @preventDistance < Math.sqrt (Math.pow @gesture.dx, 2) + (Math.pow @gesture.dy, 2)

  _resetTapCount: ->
    @_tapCount = 0
    @_lastTapTime = null
    return

  _recognizeTap: ->

    now = Date.now()
    elapsedTime = now - @_grantTime
    return if @maxReleaseDelay < elapsedTime

    if @_lastTapTime isnt null
      elapsedTime = now - @_lastTapTime
      if @maxTapDelay < elapsedTime
        @_resetTapCount()

    @_tapCount += 1
    @_lastTapTime = now

    @gesture.tapCount = @_tapCount
    @didTap.emit @gesture

    if @_tapCount is @maxTapCount
      @_resetTapCount()
    return

type.overrideMethods

  __onGrant: ->
    @_grantTime = Date.now()
    @__super arguments

  __onTouchMove: (event) ->
    @_gesture.__onTouchMove event
    if @_hasMovedTooFar()
      @terminate event.nativeEvent
      return
    @didTouchMove.emit @_gesture, event
    return

  __onRelease: (event, finished) ->
    if finished
    then @_recognizeTap()
    else @_resetTapCount()
    @_grantTime = null
    @__super arguments

module.exports = type.build()
