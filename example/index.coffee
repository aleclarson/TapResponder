
###
This example uses `modx` for creating the component class.
Though not required, it is recommended.

Steps:
  - Copy n' paste this file into your React project
  - Import this file via `MyView = require "./MyView"`
  - Render the component via `element = MyView {style, children}`
  - Try tapping the rendered element, then look at the console
###

{Component} = require "modx"
{View} = require "modx/views"

TapResponder = require "TapResponder"

type = Component "MyView"

type.defineValues ->
  tap: TapResponder()

type.defineListeners ->

  @tap.didTap (gesture) ->
    console.log "Tap detected!"

  @tap.didTouchStart (gesture) ->
    console.log "One (or more) fingers began touching!"

  @tap.didTouchEnd (gesture) ->
    console.log "One (or more) fingers stopped touching!"

type.render ->
  return View
    style: @props.style
    children: @props.children
    mixins: [@tap.touchHandlers]

module.exports = type.build()
