///|
let player : Ref[@entity.Entity?] = { val: None }

///|
pub fn set_player(entity : @entity.Entity) -> Unit {
  player.val = Some(entity)
}

///|
pub fn handle_input() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  match state {
    Idle =>
      if @external.is_pressed(ArrowLeft) {
        @object.enter_state(player, Run)
        @object.set_direction(player, Left)
        @location.set_velocity(player, @math.Vec2D::new(-1, 0))
      } else if @external.is_pressed(ArrowRight) {
        @object.enter_state(player, Run)
        @object.set_direction(player, Right)
        @location.set_velocity(player, @math.Vec2D::new(1, 0))
      }
    Run =>
      if @external.is_pressed(ArrowLeft) {
        if @object.get_direction(player) is Some(Right) {
          @object.set_direction(player, Left)
          @location.set_velocity(player, @math.Vec2D::new(-1, 0))
        }
      } else if @external.is_pressed(ArrowRight) {
        if @object.get_direction(player) is Some(Left) {
          @object.set_direction(player, Right)
          @location.set_velocity(player, @math.Vec2D::new(1, 0))
        }
      } else {
        @object.enter_state(player, Idle)
        @location.set_velocity(player, @math.Vec2D::new(0, 0))
      }
    _ => ()
  }
}
