
{ Responder } = require "gesture"

fromArgs = require "fromArgs"
Event = require "Event"
Type = require "Type"

type = Type "Tappable"

type.inherits Responder

type.defineOptions
  maxTapCount: Number.withDefault 1
  maxTapDelay: Number.withDefault Infinity
  preventDistance: Number.withDefault Infinity

type.defineFrozenValues

  maxTapCount: fromArgs "maxTapCount"

  maxTapDelay: fromArgs "maxTapDelay"

  preventDistance: fromArgs "preventDistance"

  didTap: -> Event()

type.defineValues

  _tapCount: 0

  _releaseTime: null

type.defineMethods

  _isTapPrevented: ->
    @preventDistance > Math.sqrt (Math.pow @gesture.dx, 2) + (Math.pow @gesture.dy, 2)

  _resetTapCount: ->
    @_tapCount = 0
    @_releaseTime = null

  _recognizeTap: ->

    now = Date.now()

    @_resetTapCount() if @_releaseTime? and (now - @_releaseTime > @maxTapDelay)

    @_releaseTime = now

    @_tapCount += 1

    @didTap.emit @_tapCount, @gesture

    @_resetTapCount() if @_tapCount is @maxTapCount

type.overrideMethods

  __onRelease: ->
    @_isTapPrevented() or @_recognizeTap()
    @__super arguments

  __onTerminate: ->
    @_resetTapCount()
    @__super arguments

module.exports = type.build()
