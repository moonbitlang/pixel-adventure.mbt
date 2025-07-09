///|
let player : Ref[@entity.Entity?] = { val: None }

///|
pub fn set_player(entity : @entity.Entity) -> Unit {
  player.val = Some(entity)
}

///|
let jmp_v : @math.Vec2D = @math.Vec2D::new(0, -2)

///|
let run_v : @math.Vec2D = @math.Vec2D::new(1, 0)

///|
let jmp_acc : @math.Vec2D = @math.Vec2D::new(0, 0.05)

///|
pub fn update() -> Unit {
  check_state()
  handle_input()
  check_collision()
}

///|
fn handle_input() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  match state {
    Idle =>
      if @external.is_pressed(ArrowLeft) {
        @object.enter_state(player, Run)
        @object.set_direction(player, Left)
        @location.set_velocity(player, -run_v)
      } else if @external.is_pressed(ArrowRight) {
        @object.enter_state(player, Run)
        @object.set_direction(player, Right)
        @location.set_velocity(player, run_v)
      } else if @external.is_pressed(ArrowUp) {
        @object.enter_state(player, Jump)
        @location.set_velocity(player, jmp_v)
        @location.set_acceleration(player, jmp_acc)
      }
    Run =>
      if @external.is_pressed(ArrowUp) {
        let mut v = jmp_v
        if @object.get_state(player) is Some(Run) {
          v += if @object.get_direction(player) is Some(Left) {
            -run_v
          } else {
            run_v
          }
        }
        @object.enter_state(player, Jump)
        @location.set_velocity(player, v)
        @location.set_acceleration(player, jmp_acc)
      } else if @external.is_pressed(ArrowLeft) {
        if @object.get_direction(player) is Some(Right) {
          @object.set_direction(player, Left)
          @location.set_velocity(player, -run_v)
        }
      } else if @external.is_pressed(ArrowRight) {
        if @object.get_direction(player) is Some(Left) {
          @object.set_direction(player, Right)
          @location.set_velocity(player, run_v)
        }
      } else {
        @object.enter_state(player, Idle)
        @location.set_velocity(player, @math.Vec2D::new(0, 0))
      }
    _ => ()
  }
}

///|
fn check_state() -> Unit {
  guard player.val is Some(player) else { return }
  guard @location.get_entity(player) is Some({ velocity: Some({ y, .. }), .. }) else {
    return
  }
  guard @object.get_state(player) is Some(state)
  if state is Jump && y > 0 {
    @object.enter_state(player, Fall)
  }
}

///|
fn check_collision() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  guard @location.get_entity(player) is Some({ hitbox, .. }) else { return }
  for entity in @entity.entities() {
    guard @object.get_object(entity) is Some(Terrain(_)) else { continue }
    guard @location.get_entity(entity) is Some({ hitbox: other_hitbox, .. }) else {
      continue
    }
    if hitbox.intersects(other_hitbox) {
      // Collision detected, handle it
      // TODO: determine the type of collision
      if state is Fall {
        @object.enter_state(player, Idle)
        @location.set_velocity(player, @math.Vec2D::new(0, 0))
        @location.set_acceleration(player, @math.Vec2D::new(0, 0))
        return
      }
    }
  }
}
