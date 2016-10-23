
{ Responder } = require "gesture"

emptyFunction = require "emptyFunction"
Event = require "Event"
Type = require "Type"

type = Type "Tappable"

type.inherits Responder

type.defineOptions
  maxTapCount: Number.withDefault 1
  maxTapDelay: Number.withDefault Infinity
  maxReleaseDelay: Number.withDefault Infinity
  preventDistance: Number.withDefault Infinity

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

    return if @_hasMovedTooFar()

    now = Date.now()
    elapsedTime = now - @_grantTime
    return if @maxReleaseDelay < elapsedTime

    if @_lastTapTime isnt null
      elapsedTime = now - @_lastTapTime
      if @maxTapDelay < elapsedTime
        @_resetTapCount()

    @_tapCount += 1
    @_lastTapTime = now

    @didTap.emit @_tapCount, @gesture

    if @_tapCount is @maxTapCount
      @_resetTapCount()
    return

type.overrideMethods

  __onGrant: ->
    @_grantTime = Date.now()
    @__super arguments

  __onRelease: ->
    @_recognizeTap()
    @_grantTime = null
    @__super arguments

  __onTerminate: ->
    @_resetTapCount()
    @__super arguments

module.exports = type.build()
