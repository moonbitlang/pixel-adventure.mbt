// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
  velocity : @math.Vec2D
  /// The acceleration of the entity, e.g. gravity
  /// Currently, the acceleration is computed internally
  priv acceleration : @math.Vec2D?
}

///|
pub fn set_entity(
  entity : @entity.Entity,
  location : @math.Vec2D,
  hitbox : @math.HitBox,
  velocity~ : @math.Vec2D = @math.Vec2D::new(0, 0),
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
  vertical_velocity : Double,
) -> Unit {
  guard state.get(entity) is Some({ velocity: v, .. } as st)
  let velocity = @math.Vec2D::new(v.x, vertical_velocity)
  state[entity] = { ..st, velocity, }
}

///|
pub fn set_horizontal_velocity(
  entity : @entity.Entity,
  horizontal_velocity : Double,
) -> Unit {
  guard state.get(entity) is Some({ velocity: v, .. } as st)
  let velocity = @math.Vec2D::new(horizontal_velocity, v.y)
  state[entity] = { ..st, velocity, }
}

pub fn get_velocity(entity : @entity.Entity) -> @math.Vec2D {
  guard state.get(entity) is Some({ velocity, .. })
  velocity
}

///|
pub fn is_grounded(entity : @entity.Entity) -> Bool {
  grounded.get(entity) is Some(true)
}

///|
let collide_callbacks : Array[
  (@entity.Entity, @entity.Entity, @math.CollisionInfo) -> Unit,
] = []

///|
pub fn register_collide_callback(
  callback : (@entity.Entity, @entity.Entity, @math.CollisionInfo) -> Unit,
) -> Unit {
  collide_callbacks.push(callback)
}

///|
let last_collides : Set[(@entity.Entity, @entity.Entity)] = Set::new()

///|
pub fn update() -> Unit {
  // clear old state
  grounded.clear()
  let collide_set = Set::new()
  let old_tree = quadtree.val
  quadtree.val = QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(@config.GAME_WIDTH, @config.GAME_HEIGHT),
    0,
  )
  for entity, st in state {
    let mut new_location = st.location
    let mut new_hitbox = st.hitbox
    let velocity = st.velocity
    // Update velcity
    let mut new_velocity = velocity
    if st.acceleration is Some(acceleration) {
      // Update the entity's velocity based on its acceleration
      new_velocity = st.velocity + acceleration
    }

    // Update the entity's location based on its velocity
    new_location = st.location + velocity
    new_hitbox = st.hitbox.shift(velocity)

    // Check for collisions with static objects
    let collisions = old_tree.query(new_hitbox)
    let mut move_x = 0.0
    let mut move_y = 0.0
    for prev_entity in collisions {
      guard prev_entity != entity && collides(entity, prev_entity) else {
        continue
      }
      guard state.get(prev_entity) is Some({ hitbox: static_hitbox, .. }) else {
        continue
      }
      guard @math.HitBox::intersects(new_hitbox, static_hitbox)
        is Some(collision_info) else {
        continue
      }
      if !last_collides.contains((entity, prev_entity)) {
        collide_callbacks.each(fn(callback) {
          callback(entity, prev_entity, collision_info)
        })
      }
      collide_set.add((entity, prev_entity))

      // Resolve the collision by shifting the hitbox, but remain intersected if possible
      let bar = 0.01
      if collision_info.depth > bar {
        move_x = if collision_info.direction.x > 0 {
          @cmp.maximum(
            move_x,
            (collision_info.depth - bar) * collision_info.direction.x,
          )
        } else {
          @cmp.minimum(
            move_x,
            (collision_info.depth - bar) * collision_info.direction.x,
          )
        }
        move_y = if collision_info.direction.y > 0 {
          @cmp.maximum(
            move_y,
            (collision_info.depth - bar) * collision_info.direction.y,
          )
        } else {
          @cmp.minimum(
            move_y,
            (collision_info.depth - bar) * collision_info.direction.y,
          )
        }
      }

      // reset velocity
      if collision_info.direction.y > 0 {
        grounded[entity] = true
        new_velocity = @math.Vec2D::new(
          new_velocity.x,
          @cmp.minimum(new_velocity.y, 0),
        )
      } else if collision_info.direction.y < 0 {
        grounded[prev_entity] = true
        new_velocity = @math.Vec2D::new(
          new_velocity.x,
          @cmp.maximum(new_velocity.y, 0),
        )
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
      velocity: new_velocity,
      acceleration: new_acceleration,
    }
    quadtree.val.insert(entity, new_hitbox)
  }
  last_collides.clear()
  for pair in collide_set {
    last_collides.add(pair)
  }
}
