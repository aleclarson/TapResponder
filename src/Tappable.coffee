
{ Responder } = require "gesture"

Event = require "event"
Type = require "Type"

type = Type "Tappable"

type.inherits Responder

type.optionTypes =
  maxTapCount: Number
  maxTapDelay: Number
  preventDistance: Number

type.optionDefaults =
  maxTapCount: 1
  maxTapDelay: Infinity
  preventDistance: Infinity

type.defineFrozenValues

  maxTapCount: (options) -> options.maxTapCount

  maxTapDelay: (options) -> options.maxTapDelay

  preventDistance: (options) -> options.preventDistance

  didTap: -> Event()

type.defineValues

  _tapCount: 0

  _releaseTime: null

type.defineMethods

  _resetTapCount: ->
    @_tapCount = 0
    @_releaseTime = null

  __onTouchMove: ->

    if @isCaptured
      distance = Math.sqrt (Math.pow @gesture.dx, 2) + (Math.pow @gesture.dy, 2)
      if distance >= @preventDistance
        @terminate()
        return

    @__super arguments

  __onRelease: ->

    now = Date.now()

    if @_releaseTime? and (now - @_releaseTime > @maxTapDelay)
      @_resetTapCount()

    @_releaseTime = now

    @_tapCount += 1

    @didTap.emit @_tapCount, @gesture

    if @_tapCount is @maxTapCount
      @_resetTapCount()

    @__super arguments

  __onTerminate: ->

    @_resetTapCount()

    @__super arguments

module.exports = type.build()
