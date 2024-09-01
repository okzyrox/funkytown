# App

import sokol/app as sapp
import sokol/log as slog
import std/[strformat, times]

import utils

##


type GameApp = object
    window_title*: Value[string]
    window_size*: (int, int)
    window_icon*: Value[IconDesc]

    init*: proc(): void {.cdecl.}
    frame*: proc(): void {.cdecl.}
    shutdown*: proc(): void {.cdecl.}



proc new_game_app*(init: proc(): void {.cdecl.}, frame: proc(): void {.cdecl.}, shutdown: proc(): void {.cdecl.}): GameApp =
    let title = new_value("Sokol App", proc(value: string) = sapp.setWindowTitle(value.cstring))
    let size = (800, 600)

    GameApp(window_title: title, window_size: size, init: init, frame: frame, shutdown: shutdown)

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