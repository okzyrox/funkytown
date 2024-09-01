# Utils stuff

type Value*[T] = object
    value: T 
    on_set: proc(value: T): void

proc new_value*[T](value: T, on_set: proc(value: T): void): Value[T] =
    Value[T](value: value, on_set: on_set)

proc set*[T](s: var Value[T], value: T) =
    s.value = value
    s.on_set(value)

proc get*[T](s: Value[T]): T = s.value

proc connect*[T](s: var Value[T], on_set: proc(value: T): void) =
    s.on_set = on_set