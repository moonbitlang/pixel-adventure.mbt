///|
fn main {
  // add player
  @map.generate()

  // move the player around
  @external.schedule_with_fixed_interval(1000 / 500, () => {
    @state.update()
    @location.update()
  })
  |> ignore
  // Render
  let canvas = @dom.document()
    .get_element_by_id("canvas")
    .unwrap()
    .to_html_canvas_element()
    .unwrap()
  let context = canvas.get_context("2d").to0().unwrap()
  @external.schedule_with_fixed_interval(1000 / @config.GAME_FPS.to_double(), () => @render.render(
    context,
  ))
  |> ignore
}
