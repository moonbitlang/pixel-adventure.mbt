///|
fn main {
  // add player
  let player = @entity.Entity::new()
  @object.set_character(player, MaskDude)
  @object.enter_state(player, Idle)
  @object.set_direction(player, Right)
  @location.set_entity(
    player,
    @math.Vec2D::new(0, @config.GAME_HEIGHT - 40),
    @math.HitBox::rect(
      @math.Vec2D::new(0, @config.GAME_HEIGHT - 40),
      @math.Vec2D::new(32, 32),
    ),
    velocity=@math.Vec2D::new(0, 0),
  )
  @state.set_player(player)

  // add floor
  for i = 0; i < @config.GAME_WIDTH.to_int() / 16 + 1; i = i + 1 {
    let terrain = @entity.Entity::new()
    @object.set_terrain(terrain, Flat_Steel)
    @location.set_entity(
      terrain,
      @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 8),
      @math.HitBox::rect(
        @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 8),
        @math.Vec2D::new(16, 8),
      ),
    )
  }

  // add floor in the air
  for i = 0; i < 10; i = i + 1 {
    let terrain = @entity.Entity::new()
    @object.set_terrain(terrain, Flat_Steel)
    @location.set_entity(
      terrain,
      @math.Vec2D::new(100 + i.to_double() * 16, @config.GAME_HEIGHT - 50),
      @math.HitBox::rect(
        @math.Vec2D::new(100 + i.to_double() * 16, @config.GAME_HEIGHT - 50),
        @math.Vec2D::new(16, 8),
      ),
    )
  }

  // move the player around
  @external.schedule_with_fixed_interval(1000 / 100, () => {
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
