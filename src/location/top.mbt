///|
let state : Map[@entity.Entity, State] = {}

///|
let grounded : Map[@entity.Entity, Bool] = {}

///|
const GRAVITY_ACC = 0.05

///|
pub struct State {
  location : @math.Vec2D
  hitbox : @math.HitBox
  velocity : @math.Vec2D?
  /// The acceleration of the entity, e.g. gravity
  /// Currently, the acceleration is computed internally
  priv acceleration : @math.Vec2D?
}

///|
pub fn set_entity(
  entity : @entity.Entity,
  location : @math.Vec2D,
  hitbox : @math.HitBox,
  velocity? : @math.Vec2D
) -> Unit {
  if state.get(entity) is None {
    @entity.on_remove(entity, () => state.remove(entity))
  }
  state[entity] = { location, hitbox, velocity, acceleration: None }
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
pub fn is_grounded(entity : @entity.Entity) -> Bool {
  grounded.get(entity) is Some(true)
}

///|
pub fn update() -> Unit {
  // clear old state
  grounded.clear()
  quadtree.val = QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(@config.GAME_WIDTH, @config.GAME_HEIGHT),
    0,
  )

  // static objects
  let static_quadtree = QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(@config.GAME_WIDTH, @config.GAME_HEIGHT),
    0,
  )
  for entity, st in state {
    if @object.get_object(entity) is Some(Terrain(_)) {
      // Static objects are not updated, just insert them into the quadtree
      static_quadtree.insert(entity, st.hitbox)
    }
  }
  for entity, st in state {
    let mut new_location = st.location
    let mut new_hitbox = st.hitbox
    guard st.velocity is Some(velocity) else {
      quadtree.val.insert(entity, st.hitbox)
      continue
    }
    // Update velcity
    let mut new_velocity = velocity
    if st.acceleration is Some(acceleration) {
      guard st.velocity is Some(velocity)
      // Update the entity's velocity based on its acceleration
      new_velocity = velocity + acceleration
    }

    // Update the entity's location based on its velocity
    new_location = st.location + velocity
    new_hitbox = st.hitbox.shift(velocity)

    // Check for collisions with static objects
    let collisions = static_quadtree.query(new_hitbox)
    let mut move_x = 0.0
    let mut move_y = 0.0
    for static_entity in collisions {
      guard state.get(static_entity) is Some({ hitbox: static_hitbox, .. })
      guard @math.HitBox::intersects(new_hitbox, static_hitbox)
        is Some(collision_info) else {
        continue
      }
      // Resolve the collision by shifting the hitbox
      if collision_info.depth > 0.1 {
        move_x = if collision_info.direction.x > 0 {
          @cmp.maximum(
            move_x,
            collision_info.depth * collision_info.direction.x,
          )
        } else {
          @cmp.minimum(
            move_x,
            collision_info.depth * collision_info.direction.x,
          )
        }
        move_y = if collision_info.direction.y > 0 {
          @cmp.maximum(
            move_y,
            collision_info.depth * collision_info.direction.y,
          )
        } else {
          @cmp.minimum(
            move_y,
            collision_info.depth * collision_info.direction.y,
          )
        }
      }

      // reset velocity
      if collision_info.direction.y > 0 && new_velocity.y >= 0 {
        grounded[entity] = true
        new_velocity = @math.Vec2D::new(new_velocity.x, 0)
      } else if collision_info.direction.y < 0 && new_velocity.y < 0 {
        new_velocity = @math.Vec2D::new(new_velocity.x, 0)
      }
    }
    new_location = new_location - @math.Vec2D::new(move_x, move_y)
    new_hitbox = @math.HitBox::shift(
      new_hitbox,
      -@math.Vec2D::new(move_x, move_y),
    )
    // currently, the only acceleration comes from gravity
    let new_acceleration = if @object.has_gravity(entity) &&
      grounded.get(entity) is None {
      Some(@math.Vec2D::new(0, GRAVITY_ACC))
    } else {
      None
    }
    state[entity] = {
      location: new_location,
      hitbox: new_hitbox,
      velocity: Some(new_velocity),
      acceleration: new_acceleration,
    }
    quadtree.val.insert(entity, new_hitbox)
  }
}
