///|
pub typealias () -> Unit as Event

///|
let deferred_events : Array[Event] = []

///|
pub fn defer_event(event : Event) -> Unit {
  deferred_events.push(event)
}

///|
pub fn update() -> Unit {
  for event in deferred_events {
    event()
  }
  deferred_events.clear()
}
