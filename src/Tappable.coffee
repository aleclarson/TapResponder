
{ Responder } = require "gesture"

Factory = require "factory"

module.exports = Factory "Touchable",

  kind: Responder

  optionTypes:
    maxTapCount: Number
    maxTapDelay: Number
    preventDistance: Number

  optionDefaults:
    maxTapCount: 1
    maxTapDelay: Infinity
    preventDistance: Infinity

  initFrozenValues: ->

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

  _onPanResponderMove: ->
    return unless @_gesture
    distance = Math.sqrt (Math.pow @_gesture.dx, 2) + (Math.pow @_gesture.dy, 2)
    return @_onPanResponderTerminate() if distance >= @preventDistance
    Responder::_onPanResponderMove.call this

  _onPanResponderRelease: ->
    return unless @_gesture
    now = Date.now()
    @_resetTapCount() if @_releaseTime? and (now - @_releaseTime > @maxTapDelay)
    @_releaseTime = now
    @_tapCount += 1
    @didTap.emit @_tapCount, @_gesture
    @_resetTapCount() if @_tapCount is @maxTapCount
    Responder::_onPanResponderRelease.call this
