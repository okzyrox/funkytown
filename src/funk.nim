#-------------------------------------------------------------------------------
#   debugtextprintf.nim
#
#   How to do formatted printing with sokol/debugtext
#-------------------------------------------------------------------------------
import sokol/log as slog
import sokol/gfx as sg
import sokol/app as sapp
import sokol/debugtext as sdtx
import sokol/glue as sglue
import std/[strformat, times]

import stuff/[app, utils, draw]

type Color = object
  r, g, b: uint8

const
  numFonts = 3
  passAction = PassAction(
    colors: [
      ColorAttachmentAction(loadAction: loadActionClear, clearValue: (0, 0.125, 0.25, 1))
    ]
  )
  palette = [
    Color(r:0xf4, g:0x43, b:0x36),
    Color(r:0x21, g:0x96, b:0xf3),
    Color(r:0x4c, g:0xaf, b:0x50)
  ]

## Either put funcs here or below


# sapp.run(sapp.Desc(
#   initCb: init,
#   frameCb: frame,
#   cleanupCb: cleanup,
#   width: 1366,
#   height: 768,
#   windowTitle: "funk",
#   icon: IconDesc(sokol_default: true),
#   logger: sapp.Logger(fn: slog.fn),
# ))

#var mainApp = new_game_app(init, frame, cleanup)
var mainApp = new_game_app()

proc init() {.cdecl.} =
  sg.setup(sg.Desc(
    environment: sglue.environment(),
    logger: sg.Logger(fn: slog.fn),
  ))
  sdtx.setup(sdtx.Desc(
    fonts: [
      sdtx.fontKc854(),
      sdtx.fontC64(),
      sdtx.fontOric()
    ],
    logger: sdtx.Logger(fn: slog.fn),
  ))

proc frame() {.cdecl.} =
  let frameCount = sapp.frameCount()
  let frameTime = sapp.frameDuration() * 1000

  let fps = app.get_fps()

  sdtx.canvas(sapp.widthf() * 0.5, sapp.heightf() * 0.5)
  draw_text(&"FPS: {fps:.2f}", 0, 0)
  sdtx.origin(3, 3)
  for i in 0..<numFonts:
    let color = palette[i]
    let str = "Sokol"
    sdtx.font(i.int32)
    sdtx.color3b(color.r, color.g, color.b)
    sdtx.puts((&"Hello '{str}'!\n").cstring)
    sdtx.puts((&"\tFrame Time:\t\t{frameTime:.3f}\n").cstring)
    sdtx.puts((&"\tFrame Count:\t{frameCount}\t{frameCount:#X}\n").cstring)
    sdtx.putr("Range Test 1 (xyzbla)", 12)
    sdtx.putr("\nRange Test 2\n", 32)
    sdtx.moveY(2)
  sg.beginPass(Pass(action: passAction, swapchain: sglue.swapchain()))
  sdtx.draw()
  sg.endPass()
  sg.commit()

proc cleanup() {.cdecl.} =
  sdtx.shutdown()
  sg.shutdown()

mainApp.init = init
mainApp.frame = frame
mainApp.shutdown = cleanup

mainApp.run()