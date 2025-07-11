///|
let player : Ref[@entity.Entity?] = { val: None }

///|
let hp : Ref[Int] = { val: 1 }

///|
let score : Ref[Int] = { val: 0 }

///|
let game_won : Ref[Bool?] = { val: None }

///|
pub fn game_ended() -> Bool? {
  game_won.val
}

///|
pub fn set_player(entity : @entity.Entity) -> Unit {
  @entity.on_remove(entity, () => player.val = None)
  player.val = Some(entity)
}

///|
pub fn get_score() -> Int {
  score.val
}

///|
pub fn get_hp() -> Int {
  hp.val
}

///|
const JUMP_V = -2.5

///|
const RUN_V = 1.0

///|
pub fn update() -> Unit {
  check_collision()
  check_transition()
  handle_input()
}

///|
/// Check if the player is in a valid state
fn handle_input() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  // Special handling for character
  guard @location.get_entity(player) is Some({ velocity: Some({ y, .. }), .. })
  if y > 0 && !(state is (Hit | Disapper)) {
    @object.enter_state(player, Fall)
  }

  // Handle input
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
      }
    Run => {
      if @external.is_pressed(ArrowUp) {
        @object.enter_state(player, Jump)
        @location.set_vertical_velocity(player, JUMP_V)
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
    Jump =>
      if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      }
    Hit => {
      if @external.is_pressed(ArrowUp) && @location.is_grounded(player) {
        @location.set_vertical_velocity(player, JUMP_V)
      }
      if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      } else {
        @location.set_horizontal_velocity(player, 0)
      }
    }
    Fall => {
      if @external.is_pressed(ArrowLeft) {
        @object.set_direction(player, Left)
        @location.set_horizontal_velocity(player, -RUN_V)
      } else if @external.is_pressed(ArrowRight) {
        @object.set_direction(player, Right)
        @location.set_horizontal_velocity(player, RUN_V)
      }
      if @location.is_grounded(player) {
        @location.set_horizontal_velocity(player, 0)
        @object.enter_state(player, Idle)
      }
    }
    _ => ()
  }
}

///|
/// Check the transition based on animation
fn check_transition() -> Unit {
  for entity in @entity.entities() {
    guard @object.get_stage(entity) is Some(Exit) else { continue }
    match @object.get_character(entity) {
      Some(Mushroom) =>
        if @object.get_state(entity) is Some(Hit) {
          @object.enter_state(entity, Disapper)
        } else if @object.get_state(entity) is Some(Disapper) {
          @entity.remove_entities(entity)
        }
      Some(Banana) =>
        if @object.get_state(entity) is Some(Disapper) {
          @entity.remove_entities(entity)
        }
      Some(MaskDude) => {
        let player = entity
        if @object.get_state(player) is Some(Hit) {
          guard hp.val != 0 else {
            @object.enter_state(player, Disapper)
            game_won.val = Some(false)
            continue
          }
          guard @location.get_entity(player)
            is Some({ velocity: Some({ x, y }), .. })
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
        } else if @object.get_state(player) is Some(Disapper) {
          @entity.remove_entities(player)
        }
      }
      _ => ()
    }
  }
}

///|
/// Check for collisions with other entities
fn check_collision() -> Unit {
  guard player.val is Some(player) else { return }
  let collisions = @location.get_collision(player)
  for collision in collisions {
    let (entity, collision_info) = collision
    if @object.get_character(entity) is Some(Mushroom) {
      // Handle collision if none is already in Hit or Disapper state
      if !(@object.get_state(entity) is Some(Hit | Disapper)) &&
        !(@object.get_state(player) is Some(Hit | Disapper)) {
        // Collision with a character, handle it
        if collision_info.direction.y < 0 {
          // Player is above the mushroom, so hit it
          @object.enter_state(entity, Hit)
          score.val += 100
        } else {
          // Player is below the mushroom, so hit the player
          @object.enter_state(player, Hit)
          if game_won.val is None {
            hp.val -= 1
          }
        }
      }
    } else if @object.get_character(entity) is Some(Banana) {
      if !(@object.get_state(entity) is Some(Disapper)) {
        @object.enter_state(entity, Disapper)
      }
    } else if @object.get_character(entity) is Some(Trophy) {
      // Handle collision with trophy
      if !(@object.get_state(entity) is Some(Pressed)) {
        @object.enter_state(entity, Pressed)
        game_won.val = Some(true)
      }
    }
  }
}
