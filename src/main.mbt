// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
