///|
let state : Map[@entity.Entity, State] = {}

///|
pub struct State {
  location : @math.Vec2D
  hitbox : @math.HitBox
  velocity : @math.Vec2D?
  acceleration : @math.Vec2D?
}

///|
pub fn set_entity(
  entity : @entity.Entity,
  location : @math.Vec2D,
  hitbox : @math.HitBox,
  velocity? : @math.Vec2D,
  acceleration? : @math.Vec2D
) -> Unit {
  if acceleration is Some(_) && velocity is None {
    abort("Cannot set acceleration without velocity")
  }
  state[entity] = { location, hitbox, velocity, acceleration }
}

///|
pub fn get_entity(entity : @entity.Entity) -> State? {
  state.get(entity)
}

///|
pub fn shift_entity(entity : @entity.Entity, dir : @math.Vec2D) -> Unit {
  if state.get(entity) is Some(st) {
    let new_location = st.location + dir
    let new_hitbox = st.hitbox.shift(dir)
    state[entity] = {
      location: new_location,
      hitbox: new_hitbox,
      velocity: st.velocity,
      acceleration: st.acceleration,
    }
  }
}

///|
pub fn update() -> Unit {
  for entity, st in state {
    let mut new_location = st.location
    let mut new_hitbox = st.hitbox
    if st.velocity is Some(velocity) {
      // Update the entity's location based on its velocity
      new_location = st.location + velocity
      new_hitbox = st.hitbox.shift(velocity)
    }
    let new_velocity = if st.acceleration is Some(acceleration) {
      guard st.velocity is Some(velocity)
      // Update the entity's velocity based on its acceleration
      Some(velocity + acceleration)
    } else {
      None
    }
    state[entity] = {
      location: new_location,
      hitbox: new_hitbox,
      velocity: new_velocity,
      acceleration: st.acceleration,
    }
  }
}
