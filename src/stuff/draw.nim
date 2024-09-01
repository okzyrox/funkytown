## Draw utils


import sokol/gfx as sg
import sokol/debugtext as sdtx
import utils


proc draw_text*(text: string, x, y: float32) =
    sdtx.pos(x, y)
    sdtx.puts(text.cstring)

