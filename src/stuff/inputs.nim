# Adapated from that one open source golf game because sokol as NO documentation
# and i genuinally couldnt find the variables when looking at the source
# credits to whoever
import sokol/app as sapp
import sokol/gl
import sokol/gfx
import sokol/glue

import std/tables

const MAX_KEYCODES = 512
const MAX_MOUSEBUTTONS = 3

type
  Vec2* = object
    x*, y*: float32

  Vec3* = object
    x*, y*, z*: float32

proc `+`*(a, b: Vec2): Vec2 =
  Vec2(x: a.x + b.x, y: a.y + b.y)

proc `-`*(a, b: Vec2): Vec2 =
  Vec2(x: a.x - b.x, y: a.y - b.y)

proc `+`*(a: Vec2, b: float32): Vec2 =
  Vec2(x: a.x + b, y: a.y + b)

proc `-`*(a: Vec2, b: float32): Vec2 =
  Vec2(x: a.x - b, y: a.y - b)

proc `*`*(a: Vec2, b: float32): Vec2 =
  Vec2(x: a.x * b, y: a.y * b)

proc `/`*(a: Vec2, b: float32): Vec2 =
  Vec2(x: a.x / b, y: a.y / b)

proc `*`*(a, b: Vec2): Vec2 =
  Vec2(x: a.x * b.x, y: a.y * b.y)

proc `/`*(a, b: Vec2): Vec2 =
  Vec2(x: a.x / b.x, y: a.y / b.y)

type
  Inputs* = object
    mousePos*, prevMousePos*, mouseDownPos*, screenMousePos*, screenMouseDownPos*: Vec2
    mouseRayOrig*, mouseRayDir*: Vec3
    mouseScrollDelta*: Vec2
    screenMouseDownDelta*, mouseDownDelta*: float
    mouseDelta*: Vec2
    touchPos*, prevTouchPos*, touchDownPos*: Vec2
    mouseDown*: Table[int32, bool]
    mouseClicked*: Table[int32, bool]
    buttonDown*: Table[int32, bool]
    buttonClicked*: Table[int32, bool]
    touchDown*, touchBegan*, touchEnded*, isTouch*: bool
    frameNum*, frameTouchBegan*, frameTouchEnded*: int

var inputs*: Inputs

proc getInputs*(): ptr Inputs =
    addr inputs

proc inputsInit*() =
    reset(inputs)
    when defined(android) or defined(ios):
        inputs.isTouch = true
    else:
        inputs.isTouch = false

proc inputsStart*() =
  inputs.mouseDelta = inputs.mousePos - inputs.prevMousePos
  #[
  if inputs.mouseDown.getOrDefault(mouseButtonLeft.int32):
    inputs.mouseDownDelta = (inputs.mousePos - inputs.mouseDownPos)
    inputs.screenMouseDownDelta = inputs.screenMousePos - inputs.screenMouseDownPos

  ]#
proc inputsStop*() =
  inputs.frameNum += 1
  if inputs.touchEnded:
    inputs.touchDown = false
  inputs.touchBegan = false
  inputs.touchEnded = false
  inputs.prevMousePos = inputs.mousePos
  inputs.prevTouchPos = inputs.touchPos
  for i in 0 ..< MAX_KEYCODES:
    var i = i.int32
    if inputs.buttonClicked.getOrDefault(i):
      inputs.buttonClicked[i] = false
  for i in 0 ..< MAX_MOUSEBUTTONS:
    var i = i.int32
    if inputs.mouseClicked.getOrDefault(i):
      inputs.mouseClicked[i] = false
  inputs.mouseScrollDelta = Vec2(x:0.0, y:0.0)

proc inputsHandler*(event: ptr Event) =
  case event.type:
  of eventTypeTouchesBegan:
    if event.num_touches > 0:
      inputs.touchPos = Vec2(x:event.touches[0].pos_x, y:event.touches[0].pos_y)
    inputs.frameTouchBegan = inputs.frameNum
    inputs.touchBegan = true
    inputs.touchDown = true
    inputs.touchDownPos = inputs.touchPos
    inputs.prevTouchPos = inputs.touchPos
  of eventTypeTouchesMoved:
    if event.num_touches > 0:
      inputs.touchPos = Vec2(x:event.touches[0].pos_x, y:event.touches[0].pos_y)
  of eventTypeTouchesCancelled, eventTypeTouchesEnded:
    inputs.frameTouchEnded = inputs.frameNum
    inputs.touchEnded = true
  of eventTypeMouseDown:
    inputs.mouseDownPos = inputs.mousePos
    inputs.screenMouseDownPos = inputs.screenMousePos
    inputs.mouseDown[event.mouse_button.int32] = true
  of eventTypeMouseUp:
    inputs.mouseDown[event.mouse_button.int32] = false
    inputs.mouseClicked[event.mouse_button.int32] = true
  of eventTypeMouseScroll:
    inputs.mouseScrollDelta = Vec2(x:event.scroll_x, y:event.scroll_y)
  of eventTypeKeyDown:
    inputs.buttonDown[event.key_code.int32] = true
  of eventTypeKeyUp:
    inputs.buttonDown[event.key_code.int32] = false
    inputs.buttonClicked[event.key_code.int32] = true
  else:
    discard
