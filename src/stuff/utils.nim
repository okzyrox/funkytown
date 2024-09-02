# Utils stuff

type Value*[T] = object
    on_set*: proc(value: T): void
    value*: T


proc new_value*[T](value: T): Value[T] =
    Value[T](value: value)

proc new_value*[T](value: T, on_set: proc(value: T): void): Value[T] =
    Value[T](value: value, on_set: on_set)

proc set_value*[T](s: var Value[T], value: T) =
    s.value = value
    if s.on_set != nil:
        s.on_set(value)
    else:
        echo "on_set is nil"

proc get_value*[T](s: Value[T]): T = s.value

proc connect*[T](s: var Value[T], on_set: proc(value: T): void) =
    s.on_set = on_set