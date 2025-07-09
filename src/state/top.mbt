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
  check_collision()
  handle_input()
}

///|
fn handle_input() -> Unit {
  guard player.val is Some(player) else { return }
  guard @object.get_state(player) is Some(state)
  match state {
    Idle => {
      // Ensure player stays still when on ground and no input
      if @location.get_entity(player) is Some({ hitbox, .. }) &&
        hitbox.intersects(
          @math.HitBox::rect(
            @math.Vec2D::new(0, 150 - 8),
            @math.Vec2D::new(300, 8),
          ),
        ) {
        @location.set_velocity(player, @math.Vec2D::new(0, 0))
      }
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
  if hitbox.intersects(
      @math.HitBox::rect(@math.Vec2D::new(0, 150 - 8), @math.Vec2D::new(300, 8)),
    ) &&
    state is Fall {
    @object.enter_state(player, Idle)
    @location.set_acceleration(player, @math.Vec2D::new(0, 0))
    @location.set_velocity(player, @math.Vec2D::new(0, 0))
  }
}
