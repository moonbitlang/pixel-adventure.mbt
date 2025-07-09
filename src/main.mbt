///|
fn main {
  let player = @entity.Entity::new()
  @object.set_character(player, MaskDude)
  @object.enter_state(player, Idle)
  @object.set_direction(player, Right)
  @location.set_entity(
    player,
    @math.Vec2D::new(0, 110),
    @math.HitBox::rect(@math.Vec2D::new(0, 0), @math.Vec2D::new(32, 32)),
  )

  // move the player around
  @external.schedule_with_fixed_interval(1000 / 60, () => if @external.is_pressed(
      ArrowRight,
    ) {
    guard @object.get_state(player) is Some(Run) else {
      @object.enter_state(player, Run)
    }
    @object.set_direction(player, Right)
    @location.shift_entity(player, @math.Vec2D::new(1, 0))
  } else if @external.is_pressed(ArrowLeft) {
    guard @object.get_state(player) is Some(Run) else {
      @object.enter_state(player, Run)
    }
    @object.set_direction(player, Left)
    @location.shift_entity(player, @math.Vec2D::new(-1, 0))
  } else {
    guard @object.get_state(player) is Some(Idle) else {
      @object.enter_state(player, Idle)
    }
  })
  |> ignore
  // Render
  let canvas = @dom.document()
    .get_element_by_id("canvas")
    .unwrap()
    .to_html_element()
    .unwrap()
    .to_html_canvas_element()
    .unwrap()
  let context = canvas.get_context("2d").to0().unwrap()
  @external.schedule_with_fixed_interval(1000 / 20, () => @render.render(
    context,
  ))
  |> ignore
}
