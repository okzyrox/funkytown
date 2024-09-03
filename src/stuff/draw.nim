## Draw utils


import sokol/app as sapp
import sokol/gfx as sg
import sokol/debugtext as sdtx

import std/[strformat]

type Color* = object
  r*, g*, b*: uint8

type DrawAlignment* = enum
    drawAlignLeft
    drawAlignCenterX
    drawAlignCenterY
    drawAlignRight
    drawAlignTop
    drawAlignBottom

var current_color: Color = Color(r: 255, g: 255, b: 255)

proc draw_text*(text: string, x, y: float32) =
    sdtx.origin(0, 0)
    sdtx.pos(x, y)
    sdtx.puts(text.cstring)


proc draw_text*(text: string, x, y: float32, color: Color) =
    sdtx.origin(0, 0)
    sdtx.pos(x, y)
    if current_color != color:
        current_color = color
    sdtx.color3b(current_color.r, current_color.g, current_color.b)
    sdtx.puts(text.cstring)

proc draw_text_aligned*(text: string, x, y: float32, aligns: seq[DrawAlignment]) =
    var posx: float32
    var posy: float32
    var xoff: float32 = 0
    var yoff: float32 = 0

    for align in aligns:
        case align:
            of drawAlignLeft:   xoff = 0
            of drawAlignCenterX: xoff = sapp.widthf() / 35
            of drawAlignCenterY: yoff = sapp.heightf() / 35
            of drawAlignRight:  xoff = sapp.widthf() / 34.5 * 2
            of drawAlignTop:    yoff = 0
            of drawAlignBottom: yoff = sapp.heightf() / 16.5

    posx = x + xoff
    posy = y + yoff
    echo &"str: {text}, posx: {posx}, posy: {posy}"
    sdtx.origin(0, 0)
    sdtx.pos(posx, posy)
    sdtx.puts(text.cstring)

proc new_color*(r, g, b: uint8): Color =
    Color(r: r, g: g, b: b)

const
    ColorRed* = new_color(255, 0, 0)
    ColorGreen* = new_color(0, 255, 0)
    ColorBlue* = new_color(0, 0, 255)
    ColorWhite* = new_color(255, 255, 255)
    ColorBlack* = new_color(0, 0, 0)