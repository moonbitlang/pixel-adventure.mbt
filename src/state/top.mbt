///|
let player : Ref[@entity.Entity?] = { val: None }

///|
pub fn set_player(entity : @entity.Entity) -> Unit {
  player.val = Some(entity)
}

///|
const JUMP_V = -2.0

///|
const RUN_V = 1.0

///|
const JUMP_ACC = 0.05

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
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.enter_state(player, Run)
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      } else if @external.is_pressed(ArrowUp) {
        @object.enter_state(player, Jump)
        @location.set_vertical_velocity(player, JUMP_V)
        @location.set_vertical_acceleration(player, JUMP_ACC)
      }
    Run =>
      if @external.is_pressed(ArrowUp) {
        @object.enter_state(player, Jump)
        @location.set_vertical_velocity(player, JUMP_V)
        @location.set_vertical_acceleration(player, JUMP_ACC)
      } else if @external.is_pressed(ArrowLeft) {
        if @object.get_direction(player) is Some(Right) {
          @object.set_direction(player, Left)
          @location.set_horizontal_velocity(player, -RUN_V)
        }
      } else if @external.is_pressed(ArrowRight) {
        if @object.get_direction(player) is Some(Left) {
          @object.set_direction(player, Right)
          @location.set_horizontal_velocity(player, RUN_V)
        }
      } else {
        @object.enter_state(player, Idle)
        @location.set_horizontal_velocity(player, 0)
      }
    Jump | Fall =>
      if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      }
    Hit =>
      if @external.is_pressed(ArrowUp) {
        if @location.get_entity(player)
          is Some({ acceleration: Some({ y, .. }), .. }) &&
          y == 0 {
          @location.set_vertical_velocity(player, JUMP_V)
          @location.set_vertical_acceleration(player, JUMP_ACC)
        }
      } else if @external.is_pressed(ArrowLeft) {
        if @object.get_direction(player) is Some(Right) {
          @object.set_direction(player, Left)
          @location.set_horizontal_velocity(player, -RUN_V)
        }
      } else if @external.is_pressed(ArrowRight) {
        if @object.get_direction(player) is Some(Left) {
          @object.set_direction(player, Right)
          @location.set_horizontal_velocity(player, RUN_V)
        }
      } else {
        @location.set_horizontal_velocity(player, 0)
      }
  }
}

///|
fn check_state() -> Unit {
  guard player.val is Some(player) else { return }
  guard @location.get_entity(player) is Some({ velocity: Some({ x, y }), .. }) else {
    return
  }
  guard @object.get_state(player) is Some(state)
  guard @object.get_stage(player) is Some(stage)
  if state is Jump && y > 0 {
    @object.enter_state(player, Fall)
  } else if state is Hit && stage is Exit {
    if y < 0 {
      @object.enter_state(player, Jump)
    } else if y > 0 {
      @object.enter_state(player, Fall)
    } else if x > 0 {
      @object.enter_state(player, Run)
      @object.set_direction(player, Right)
    } else if x < 0 {
      @object.enter_state(player, Run)
      @object.set_direction(player, Left)
    } else {
      @object.enter_state(player, Idle)
    }
  }
}

///|
fn check_collision() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  guard @location.get_entity(player) is Some({ hitbox, .. }) else { return }
  for entity in @entity.entities() {
    guard @location.get_entity(entity) is Some({ hitbox: other_hitbox, .. }) else {
      continue
    }
    if hitbox.intersects(other_hitbox) {
      if @object.get_object(entity) is Some(Terrain(_)) {
        // Collision detected, handle it
        if !(state is Jump) {
          @location.set_vertical_velocity(player, 0)
          @location.set_vertical_acceleration(player, 0)
        }
        if state is Fall {
          @object.enter_state(player, Idle)
        }
      }
      if @object.get_character(entity) is Some(Mushroom) &&
        !(@object.get_state(player) is Some(Hit)) {
        // Collision with a character, handle it
        @object.enter_state(player, Hit)
      }
    }
  }
}
