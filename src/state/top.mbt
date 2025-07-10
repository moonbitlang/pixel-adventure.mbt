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
const GRAVITY_ACC = 0.05

///|
pub fn update() -> Unit {
  check_collision()
  check_state()
  handle_input()
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
        @location.set_vertical_acceleration(player, GRAVITY_ACC)
      }
    Run => {
      if @external.is_pressed(ArrowUp) {
        @object.enter_state(player, Jump)
        @location.set_vertical_velocity(player, JUMP_V)
        @location.set_vertical_acceleration(player, GRAVITY_ACC)
      }
      if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      } else {
        @object.enter_state(player, Idle)
        @location.set_horizontal_velocity(player, 0)
      }
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
        // if is grounded, i.e. vertical acceleration is 0
        if @location.get_entity(player)
          is Some({ acceleration: Some({ y, .. }), .. }) &&
          y == 0 {
          @location.set_vertical_velocity(player, JUMP_V)
          @location.set_vertical_acceleration(player, GRAVITY_ACC)
        }
      } else if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      } else {
        @location.set_horizontal_velocity(player, 0)
      }
    Disapper => ()
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
  for entity in @entity.entities() {
    if @object.get_character(entity) is Some(Mushroom) {
      if @object.get_state(entity) is Some(Hit) &&
        @object.get_stage(entity) is Some(Exit) {
        @object.enter_state(entity, Disapper)
      } else if @object.get_state(entity) is Some(Disapper) &&
        @object.get_stage(entity) is Some(Exit) {
        @entity.remove_entities(entity)
      }
    }
  }
}

///|
fn check_collision() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  let collisions = @location.get_collision(player)
  // By default, player has gravity
  @location.set_vertical_acceleration(player, GRAVITY_ACC)
  for entity in collisions {
    if @object.get_object(entity) is Some(Terrain(_)) {
      // is grounded, remove gravity
      @location.set_vertical_acceleration(player, 0)
      @location.set_vertical_velocity(player, 0)
      // has friction, remove velocity
      @location.set_horizontal_velocity(player, 0)
      if state is Fall {
        @object.enter_state(player, Idle)
      }
    }
    if @object.get_character(entity) is Some(Mushroom) {
      // Handle collision if none is already in Hit or Disapper state
      if !(@object.get_state(entity) is Some(Hit | Disapper)) &&
        !(@object.get_state(player) is Some(Hit)) {
        // Collision with a character, handle it
        guard @location.get_entity(player) is Some({ location: player_loc, .. })
        guard @location.get_entity(entity) is Some({ location: entity_loc, .. })
        if player_loc.y < entity_loc.y - 16 {
          @object.enter_state(entity, Hit)
        } else {
          @object.enter_state(player, Hit)
        }
      }
    }
  }
}
