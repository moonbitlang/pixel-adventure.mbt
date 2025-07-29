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
const DEBUG_HITBOX = true

///|
const DEBUG_QUADTREE = true

///|
let view_port : Ref[Double] = { val: 0.0 }

///|
pub fn render(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.clear_rect(0, 0, @config.VIEW_PORT_WIDTH, @config.VIEW_PORT_HEIGHT)

  // Compute the view port
  view_port.val = if @state.get_player() is Some(player) &&
    @location.get_entity(player) is Some({ location, .. }) {
    // Center the view port on the player
    let center_x = location.x - @config.VIEW_PORT_WIDTH / 2
    // Make sure we don't scroll past the edges of the game
    @cmp.maximum(
      0.0,
      @cmp.minimum(center_x, @config.GAME_WIDTH - @config.VIEW_PORT_WIDTH),
    )
  } else {
    view_port.val
  }
  // Apply the view port translation
  context.save()
  context.translate(-view_port.val, 0)

  // Start rendering
  render_background(context)
  if DEBUG_QUADTREE {
    render_quadtree(context)
  }
  if DEBUG_HITBOX {
    render_hitbox(context)
  }
  for entity in @entity.entities() {
    // Skip entities that are outside of the view port (with safety margin of one viewport width)
    if @location.get_entity(entity) is Some({ location, .. }) &&
      (
        location.x < view_port.val - @config.VIEW_PORT_WIDTH ||
        location.x > view_port.val + @config.VIEW_PORT_WIDTH * 2
      ) {
      continue
    }
    if @object.get_character(entity) is Some(_) {
      render_character(context, entity)
    }
    if @object.get_terrain(entity) is Some(_) {
      render_terrain(context, entity)
    }
  }

  // Restore the context to the original state
  context.restore()
  render_game_state(context)
}

///|
fn render_character(
  context : @dom.CanvasRenderingContext2D,
  entity : @entity.Entity,
) -> Unit {
  guard @object.get_character(entity) is Some(character)
  guard @anime.sprites.get(entity) is Some(sprite) else { return }
  let anime = sprite.animation
  let cur_frame = sprite.pos
  if cur_frame >= anime.max_frame - 1 {
    if anime.loop_ {
      sprite.pos = 0
    } else {
      sprite.callbacks.each(fn(callback) { callback() })
      @anime.play_animation(
        entity,
        @anime.default_sprites.get(character).unwrap(),
        from_start=true,
      )
    }
  } else {
    sprite.pos += 1
  }

  // Draw the character
  guard @location.get_entity(entity) is Some({ location, .. })
  let direction = @object.get_direction(entity).unwrap_or(Right)
  context.save()
  if direction is Left {
    context.translate(
      location.x + anime.width + anime.offset.x,
      location.y + anime.offset.y,
    )
    context.scale(-1, 1)
  } else {
    context.translate(location.x + anime.offset.x, location.y + anime.offset.y)
  }
  context.draw_image_with_src_and_dst_size(
    anime.sprite |> @js.Value::cast_from |> @js.Value::cast,
    anime.width * (cur_frame / @anime.REFRESH_RATE).to_double(),
    0,
    anime.width,
    anime.height,
    0,
    0,
    anime.width,
    anime.height,
  )
  context.restore()
}

///|
let background : @dom.HTMLImageElement = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Background/Blue.png")
  element
}

///|
fn render_background(context : @dom.CanvasRenderingContext2D) -> Unit {
  let pattern = context.create_pattern(@js.Union7::from0(background), "repeat")
  context.save()
  context.set_fill_style(@js.Union3::from2(pattern))
  context.fill_rect(0, 0, @config.GAME_WIDTH, @config.GAME_HEIGHT)
  context.restore()
}

///|
let terrain : @dom.HTMLImageElement = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Terrain/Terrain (16x16).png")
  element
}

///|
fn render_terrain(
  context : @dom.CanvasRenderingContext2D,
  entity : @entity.Entity,
) -> Unit {
  guard @object.get_terrain(entity) is Some(object)
  guard @location.get_entity(entity) is Some({ location, .. }) else { return }
  match object {
    Flat_Steel =>
      context.draw_image_with_src_and_dst_size(
        terrain |> @js.Value::cast_from |> @js.Value::cast,
        16,
        0,
        16,
        8,
        location.x,
        location.y,
        16,
        8,
      )
    GrassBlock =>
      context.draw_image_with_src_and_dst_size(
        terrain |> @js.Value::cast_from |> @js.Value::cast,
        96,
        0,
        48,
        48,
        location.x,
        location.y,
        16,
        16,
      )
  }
}

///|
fn render_game_state(context : @dom.CanvasRenderingContext2D) -> Unit {
  if @state.game_ended() is Some(result) {
    context.save()
    context.set_font("24px ThaleahFat")
    if result {
      context.set_fill_style(@js.Union3::from0("green"))
      context.fill_text(
        "You won!",
        @config.VIEW_PORT_WIDTH / 2 - 50,
        @config.VIEW_PORT_HEIGHT / 2,
      )
    } else {
      context.set_fill_style(@js.Union3::from0("red"))
      context.fill_text(
        "You lost!",
        @config.VIEW_PORT_WIDTH / 2 - 50,
        @config.VIEW_PORT_HEIGHT / 2,
      )
    }
    context.restore()
  }
  context.save()
  context.set_font("20px ThaleahFat")
  context.set_fill_style(@js.Union3::from0("black"))
  context.fill_text("HP : \{@state.get_hp()}", 20, 20)
  context.fill_text("Score : \{@state.get_score()}", 400, 20)
  context.restore()
}

///|
fn render_quadtree(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.save()
  context.set_stroke_style(@js.Union3::from0("blue"))
  fn render_node(node : @location.QuadTree) -> Unit {
    context.stroke_rect(
      node.position.x,
      node.position.y,
      node.size.x,
      node.size.y,
    )
    for child in node.children {
      render_node(child)
    }
  }

  render_node(@location.quadtree.val)
  context.restore()
}

///|
fn render_hitbox(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.save()
  context.set_stroke_style(@js.Union3::from0("red"))
  for entity in @entity.entities() {
    guard @location.get_entity(entity) is Some({ hitbox, .. }) else { continue }
    match hitbox {
      Rect(position~, size~) =>
        context.stroke_rect(position.x, position.y, size.x, size.y)
    }
  }
  context.restore()
}
