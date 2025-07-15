///|
pub(all) enum Code {
  KeyA
  KeyB
  KeyC
  KeyD
  KeyE
  KeyF
  KeyG
  KeyH
  KeyI
  KeyJ
  KeyK
  KeyL
  KeyM
  KeyN
  KeyO
  KeyP
  KeyQ
  KeyR
  KeyS
  KeyT
  KeyU
  KeyV
  KeyW
  KeyX
  KeyY
  KeyZ
  ArrowUp
  ArrowDown
  ArrowLeft
  ArrowRight
  Space
  Enter
  Escape
} derive(Eq, Show, Hash)

///|
fn Code::from_string(code : String) -> Code? {
  match code {
    "KeyA" => Some(KeyA)
    "KeyB" => Some(KeyB)
    "KeyC" => Some(KeyC)
    "KeyD" => Some(KeyD)
    "KeyE" => Some(KeyE)
    "KeyF" => Some(KeyF)
    "KeyG" => Some(KeyG)
    "KeyH" => Some(KeyH)
    "KeyI" => Some(KeyI)
    "KeyJ" => Some(KeyJ)
    "KeyK" => Some(KeyK)
    "KeyL" => Some(KeyL)
    "KeyM" => Some(KeyM)
    "KeyN" => Some(KeyN)
    "KeyO" => Some(KeyO)
    "KeyP" => Some(KeyP)
    "KeyQ" => Some(KeyQ)
    "KeyR" => Some(KeyR)
    "KeyS" => Some(KeyS)
    "KeyT" => Some(KeyT)
    "KeyU" => Some(KeyU)
    "KeyV" => Some(KeyV)
    "KeyW" => Some(KeyW)
    "KeyX" => Some(KeyX)
    "KeyY" => Some(KeyY)
    "ArrowUp" => Some(ArrowUp)
    "ArrowDown" => Some(ArrowDown)
    "ArrowLeft" => Some(ArrowLeft)
    "ArrowRight" => Some(ArrowRight)
    "Space" => Some(Space)
    "Enter" => Some(Enter)
    "Escape" => Some(Escape)
    _ => None
  }
}

///|
let pressedKeys : Set[Code] = @set.Set::new()

///|
let window : @dom.Window = @dom.window()

///|
let keyup_callbacks : Map[Code, Array[() -> Unit]] = {}

///|
let keydown_callbacks : Map[Code, Array[() -> Unit]] = {}

///|
pub fn on_keydown(code : Code, callback : () -> Unit) -> Unit {
  let callbacks = if keydown_callbacks.get(code) is Some(callbacks) {
    callbacks
  } else {
    let callbacks = []
    keydown_callbacks[code] = callbacks
    callbacks
  }
  callbacks.push(callback)
}

///|
pub fn on_keyup(code : Code, callback : () -> Unit) -> Unit {
  let callbacks = if keyup_callbacks.get(code) is Some(callbacks) {
    callbacks
  } else {
    let callbacks = []
    keyup_callbacks[code] = callbacks
    callbacks
  }
  callbacks.push(callback)
}

///|
fn init {
  window.add_event_listener("keyup", event => {
    let keyboardEvent = event.to_keyboard_event().unwrap()
    let keycode = keyboardEvent.code() |> Code::from_string
    if keycode is Some(c) {
      pressedKeys.remove(c)
      if keyup_callbacks.get(c) is Some(callbacks) {
        for callback in callbacks {
          callback()
        }
      }
    }
  })
  window.add_event_listener("keydown", event => {
    let keyboardEvent = event.to_keyboard_event().unwrap()
    let keycode = keyboardEvent.code() |> Code::from_string
    if keycode is Some(c) {
      pressedKeys.add(c)
      if keydown_callbacks.get(c) is Some(callbacks) {
        for callback in callbacks {
          callback()
        }
      }
    }
  })
}

///|
pub fn is_pressed(code : Code) -> Bool {
  pressedKeys.contains(code)
}

///|
pub fn schedule_with_fixed_interval(
  interval : Double,
  callback : () -> Unit,
) -> () -> Unit {
  let lastTime = { val: 0.0 }
  let lastId = { val: 0.0 }
  fn update(time : Double) -> Unit {
    if lastTime.val == 0.0 {
      lastTime.val = time
    }
    let elapsed = time - lastTime.val
    if elapsed >= interval {
      callback()
      lastTime.val = time
      lastId.val = window.request_animation_frame(update)
    } else {
      lastId.val = window.request_animation_frame(update)
    }
  }

  lastId.val = window.request_animation_frame(update)
  () => if lastId.val != 0.0 {
    // Cancel the scheduled animation frame
    window.cancel_animation_frame(lastId.val)
  }
}
