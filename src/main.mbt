///|
fn main {
  // add player
  let player = @entity.Entity::new()
  @object.set_character(player, MaskDude)
  @object.enter_state(player, Idle)
  @object.set_direction(player, Right)
  @location.set_entity(
    player,
    @math.Vec2D::new(0, @render.HEIGHT - 40),
    @math.HitBox::rect(
      @math.Vec2D::new(0, @render.HEIGHT - 40),
      @math.Vec2D::new(32, 32),
    ),
  )
  @state.set_player(player)

  // add floor
  for i = 0; i < @render.WIDTH.to_int() / 16 + 1; i = i + 1 {
    let terrain = @entity.Entity::new()
    @object.set_object(
      terrain,
      Terrain(offset=@math.Vec2D::new(16, 0), size=@math.Vec2D::new(16, 8)),
    )
    @location.set_entity(
      terrain,
      @math.Vec2D::new(i.to_double() * 16, @render.HEIGHT - 8),
      @math.HitBox::rect(
        @math.Vec2D::new(i.to_double() * 16, @render.HEIGHT - 8),
        @math.Vec2D::new(16, 8),
      ),
    )
  }

  // add fruit
  let fruit = @entity.Entity::new()
  @object.set_character(fruit, Banana)
  @object.enter_state(fruit, Idle)
  @location.set_entity(
    fruit,
    @math.Vec2D::new(100, @render.HEIGHT - 40),
    @math.HitBox::rect(
      @math.Vec2D::new(100, @render.HEIGHT - 40),
      @math.Vec2D::new(32, 32),
    ),
  )

  // add enemy
  let enemy = @entity.Entity::new()
  @object.set_character(enemy, Mushroom)
  @object.enter_state(enemy, Idle)
  @object.set_direction(enemy, Left)
  @location.set_entity(
    enemy,
    @math.Vec2D::new(200, @render.HEIGHT - 40),
    @math.HitBox::rect(
      @math.Vec2D::new(200, @render.HEIGHT - 40),
      @math.Vec2D::new(32, 32),
    ),
  )

  // move the player around
  @external.schedule_with_fixed_interval(1000 / 100, () => {
    @location.update_collision()
    @state.update()
    @location.update()
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
