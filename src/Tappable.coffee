
{ Responder } = require "gesture"

Factory = require "factory"
define = require "define"
Event = require "event"

module.exports = Factory "Tappable",

  kind: Responder

  optionTypes:
    maxTapCount: Number
    maxTapDelay: Number
    preventDistance: Number

  optionDefaults:
    maxTapCount: 1
    maxTapDelay: Infinity
    preventDistance: Infinity

  initFrozenValues: (options) ->

    maxTapCount: options.maxTapCount

    maxTapDelay: options.maxTapDelay

    preventDistance: options.preventDistance

    didTap: Event()

  initValues: ->

    _tapCount: 0

    _releaseTime: null

  _resetTapCount: ->
    @_tapCount = 0
    @_releaseTime = null

#
# Responder.prototype
#

  __onTouchMove: ->

    if @isCaptured
      distance = Math.sqrt (Math.pow @gesture.dx, 2) + (Math.pow @gesture.dy, 2)
      if distance >= @preventDistance
        @terminate()
        return

    Responder::__onTouchMove.apply this, arguments

  __onRelease: ->

    now = Date.now()

    if @_releaseTime? and (now - @_releaseTime > @maxTapDelay)
      @_resetTapCount()

    @_releaseTime = now

    @_tapCount += 1

    @didTap.emit @_tapCount, @gesture

    if @_tapCount is @maxTapCount
      @_resetTapCount()

    Responder::__onRelease.apply this, arguments

  __onTerminate: ->

    @_resetTapCount()

    Responder::__onTerminate.apply this, arguments
