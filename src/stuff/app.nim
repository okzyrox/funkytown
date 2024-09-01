# App

import sokol/app as sapp
import sokol/debugtext as sdtx
import sokol/log as slog
import std/[strformat, times]

import utils
##


type GameFonts* = enum
    fntKc853
    fntKc854
    fntZ1013
    fntCPC
    fntC64
    fntOric

type GameApp = object
    window_title*: Value[string]
    window_size*: (int, int)
    window_icon*: Value[IconDesc]

    init*: proc(): void {.cdecl.}
    frame*: proc(): void {.cdecl.}
    shutdown*: proc(): void {.cdecl.}



proc new_game_app*(init: proc(): void {.cdecl.}, frame: proc(): void {.cdecl.}, shutdown: proc(): void {.cdecl.}): GameApp =
    let title = new_value("Sokol App", proc(value: string) = sapp.setWindowTitle(value.cstring))
    let icon = new_value(IconDesc(sokol_default: true), proc(value: IconDesc) = sapp.setIcon(value))
    let size = (800, 600)

    GameApp(
        window_title: title, 
        window_size: size, 
        window_icon: icon, 
        
        init: init, 
        frame: frame, 
        shutdown: shutdown
    )

proc new_game_app*(): GameApp =
    let title = new_value("Sokol App", proc(value: string) = sapp.setWindowTitle(value.cstring))
    let size = (800, 600)

    GameApp(window_title: title, window_size: size)

    
proc run*(app: var GameApp) =
    sapp.run(sapp.Desc(
        initCb: app.init,
        frameCb: app.frame,
        cleanupCb: app.shutdown,
        width: 1366,
        height: 768,
        windowTitle: app.window_title.get().cstring,
        icon: IconDesc(sokol_default: true),
        logger: sapp.Logger(fn: slog.fn),
    ))

proc get_fps*(): float =
  let frameTime = sapp.frameDuration() * 1000
  return (1 / frameTime * 1000)

proc get_fonts*(fontList: seq[GameFonts]): array[5, FontDesc] =
    var arr: array[5, FontDesc]
    var index = 0

    for fnt in fontList:
        case fnt:
            of fntKc853: arr[index] = fontKc853()
            of fntKc854: arr[index] = fontKc854()
            of fntZ1013: arr[index] = fontZ1013()
            of fntCPC: arr[index] = fontCPC()
            of fntC64: arr[index] = fontC64()
            of fntOric: arr[index] = fontOric()
            else: 
                echo "Unsupported font"
                discard
    
        index += 1
    
    return arr

proc get_fonts*(fontList: seq[string]): array[5, FontDesc] =
    var arr: array[5, FontDesc]
    var index = 0

    for fnt in fontList:
        case fnt:
            of "kc853": arr[index] = fontKc853()
            of "kc854": arr[index] = fontKc854()
            of "z1013": arr[index] = fontZ1013()
            of "cpc": arr[index] = fontCPC()
            of "c64": arr[index] = fontC64()
            of "oric": arr[index] = fontOric()
            else: discard

        index += 1
    
    return arr