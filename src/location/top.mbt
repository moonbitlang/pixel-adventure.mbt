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
  if state.get(entity) is None {
    @entity.on_remove(entity, () => state.remove(entity))
  }
  if acceleration is Some(_) && velocity is None {
    abort("Cannot set acceleration without velocity")
  }
  state[entity] = { location, hitbox, velocity, acceleration }
  quadtree.val.insert(entity, hitbox)
}

///|
pub fn get_entity(entity : @entity.Entity) -> State? {
  state.get(entity)
}

///|
pub fn set_vertical_velocity(
  entity : @entity.Entity,
  vertical_velocity : Double
) -> Unit {
  guard state.get(entity) is Some({ velocity: Some(v), .. } as st)
  let velocity = @math.Vec2D::new(v.x, vertical_velocity)
  state[entity] = { ..st, velocity: Some(velocity) }
}

///|
pub fn set_horizontal_velocity(
  entity : @entity.Entity,
  horizontal_velocity : Double
) -> Unit {
  guard state.get(entity) is Some({ velocity: Some(v), .. } as st)
  let velocity = @math.Vec2D::new(horizontal_velocity, v.y)
  state[entity] = { ..st, velocity: Some(velocity) }
}

///|
pub fn set_vertical_acceleration(
  entity : @entity.Entity,
  vertical_acceleration : Double
) -> Unit {
  guard state.get(entity) is Some({ acceleration: Some(a), .. } as st)
  let acceleration = @math.Vec2D::new(a.x, vertical_acceleration)
  state[entity] = { ..st, acceleration: Some(acceleration) }
}

///|
pub fn set_horizontal_acceleration(
  entity : @entity.Entity,
  horizontal_acceleration : Double
) -> Unit {
  guard state.get(entity) is Some({ acceleration: Some(a), .. } as st)
  let acceleration = @math.Vec2D::new(horizontal_acceleration, a.y)
  state[entity] = { ..st, acceleration: Some(acceleration) }
}

///|
pub fn update() -> Unit {
  quadtree.val = QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(WIDTH, HEIGHT),
    0,
  )
  for entity, st in state {
    let mut new_location = st.location
    let mut new_hitbox = st.hitbox
    if st.velocity is Some(velocity) {
      // Update the entity's location based on its velocity
      new_location = st.location + velocity
      new_hitbox = st.hitbox.shift(velocity)
    }
    let mut new_velocity = st.velocity
    if st.acceleration is Some(acceleration) {
      guard st.velocity is Some(velocity)
      // Update the entity's velocity based on its acceleration
      new_velocity = Some(velocity + acceleration)
    }
    state[entity] = {
      ..st,
      location: new_location,
      hitbox: new_hitbox,
      velocity: new_velocity,
    }
    quadtree.val.insert(entity, new_hitbox)
  }
}
