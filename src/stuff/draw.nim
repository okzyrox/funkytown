## Draw utils


import sokol/gfx as sg
import sokol/debugtext as sdtx

type Color* = object
  r*, g*, b*: uint8

proc draw_text*(text: string, x, y: float32) =
    sdtx.pos(x, y)
    sdtx.puts(text.cstring)

proc new_color*(r, g, b: uint8): Color =
    Color(r: r, g: g, b: b)

const
    ColorRed* = new_color(255, 0, 0)
    ColorGreen* = new_color(0, 255, 0)
    ColorBlue* = new_color(0, 0, 255)
    ColorWhite* = new_color(255, 255, 255)
    ColorBlack* = new_color(0, 0, 0)