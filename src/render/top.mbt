///|
const DEBUG_HITBOX = true

///|
const DEBUG_QUADTREE = true

///|
let next_frame : Map[@entity.Entity, UInt] = {}

///|
let refresh_rate : UInt = @config.GAME_FPS / 20

///|
priv struct Animation {
  sprite : @dom.HTMLImageElement
  max_frame : UInt
  loop_ : Bool
  height : Double
  width : Double
  offset : @math.Vec2D
}

///|
fn Animation::new(
  sprite : @dom.HTMLImageElement,
  max_frame~ : UInt,
  loop_~ : Bool = true,
  height~ : Double,
  width~ : Double,
  offset~ : @math.Vec2D = @math.Vec2D::new(0, 0)
) -> Animation {
  { sprite, max_frame: max_frame * refresh_rate, loop_, height, width, offset }
}

///|
let sprites : Map[(@object.Character, @object.State), Animation] = {}

///|
fn init {
  sprites[(MaskDude, Idle)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
    )
    Animation::new(element, max_frame=11, height=32.0, width=32.0)
  }
  sprites[(MaskDude, Hit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Hit (32x32).png",
    )
    Animation::new(element, max_frame=7, loop_=false, height=32.0, width=32.0)
  }
  sprites[(MaskDude, Jump)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Jump (32x32).png",
    )
    Animation::new(element, max_frame=1, height=32.0, width=32.0)
  }
  sprites[(MaskDude, Fall)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png",
    )
    Animation::new(element, max_frame=1, height=32.0, width=32.0)
  }
  sprites[(MaskDude, Run)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
    )
    Animation::new(element, max_frame=12, height=32.0, width=32.0)
  }
  sprites[(MaskDude, Disapper)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Main Characters/Desappearing (96x96).png")
    Animation::new(
      element,
      max_frame=7,
      loop_=false,
      height=96.0,
      width=96,
      offset=@math.Vec2D::new(-32, -32),
    )
  }
  sprites[(Mushroom, Idle)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Enemies/Mushroom/Idle (32x32).png")
    Animation::new(element, max_frame=14, height=32.0, width=32.0)
  }
  sprites[(Mushroom, Run)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Enemies/Mushroom/Run (32x32).png")
    Animation::new(element, max_frame=16, height=32.0, width=32.0)
  }
  sprites[(Mushroom, Hit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Enemies/Mushroom/Hit.png")
    Animation::new(element, max_frame=5, loop_=false, height=32.0, width=32.0)
  }
  sprites[(Mushroom, Disapper)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Main Characters/Desappearing (96x96).png")
    Animation::new(
      element,
      max_frame=7,
      loop_=false,
      height=96.0,
      width=96,
      offset=@math.Vec2D::new(-32, -32),
    )
  }
  sprites[(Banana, Idle)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Items/Fruits/Bananas.png")
    Animation::new(element, max_frame=17, height=32.0, width=32.0)
  }
  sprites[(Banana, Disapper)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Items/Fruits/Collected.png")
    Animation::new(element, max_frame=6, loop_=false, height=32.0, width=32.0)
  }
  sprites[(Trophy, Idle)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Items/Checkpoints/End/End (Idle).png")
    Animation::new(element, max_frame=1, height=64.0, width=64.0)
  }
  sprites[(Trophy, Pressed)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "pixel_adventure/Items/Checkpoints/End/End (Pressed) (64x64).png",
    )
    Animation::new(element, max_frame=8, loop_=false, height=64.0, width=64.0)
  }
  sprites[(RockHead, Idle)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Idle.png")
    Animation::new(
      element,
      max_frame=1,
      height=42.0,
      width=42.0,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
  sprites[(RockHead, Blink)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Blink (42x42).png")
    Animation::new(
      element,
      max_frame=4,
      loop_=false,
      height=42.0,
      width=42.0,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
  sprites[(RockHead, BottomHit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Bottom Hit (42x42).png")
    Animation::new(
      element,
      max_frame=4,
      height=42.0,
      width=42.0,
      loop_=false,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
  sprites[(RockHead, LeftHit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Left Hit (42x42).png")
    Animation::new(
      element,
      max_frame=4,
      height=42.0,
      width=42.0,
      loop_=false,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
  sprites[(RockHead, RightHit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Right Hit (42x42).png")
    Animation::new(
      element,
      max_frame=4,
      height=42.0,
      width=42.0,
      loop_=false,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
  sprites[(RockHead, TopHit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src("/pixel_adventure/Traps/Rock Head/Top Hit (42x42).png")
    Animation::new(
      element,
      max_frame=4,
      height=42.0,
      width=42.0,
      loop_=false,
      offset=@math.Vec2D::new(-5, -5),
    )
  }
}

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
  entity : @entity.Entity
) -> Unit {
  guard @object.get_character(entity) is Some(character)
  guard @object.get_state(entity) is Some(state)
  guard sprites.get((character, state)) is Some(sprite) else { return }

  // Compute next frame
  guard @object.get_stage(entity) is Some(stage)
  // Remove data when the entity is removed
  if next_frame.get(entity) is None {
    @entity.on_remove(entity, () => next_frame.remove(entity))
  }
  let (sprite, curr_frame) = if stage == Enter {
    // It's a new stage, so reset the frame counter
    @object.set_stage(entity, Active)
    (sprite, 0U)
    // update the frame
  } else if next_frame.get(entity) is Some(f) {
    // Otherwise, just increment the frame
    (sprite, f)
  } else {
    // Wasn't initialized, so initialize it
    (sprite, 0U)
  }
  // Compute next frame
  if curr_frame + 1 == sprite.max_frame {
    if !sprite.loop_ {
      // Does not move forward. Will be reset by entering a new stage
      @object.set_stage(entity, Exit)
    } else {
      next_frame[entity] = 0
    }
  } else {
    next_frame[entity] = curr_frame + 1
  }

  // Draw the character
  guard @location.get_entity(entity) is Some({ location, .. })
  let direction = @object.get_direction(entity).unwrap_or(Right)
  context.save()
  if direction is Left {
    context.translate(
      location.x + sprite.width + sprite.offset.x,
      location.y + sprite.offset.y,
    )
    context.scale(-1, 1)
  } else {
    context.translate(
      location.x + sprite.offset.x,
      location.y + sprite.offset.y,
    )
  }
  context.draw_image_with_src_and_dst_size(
    sprite.sprite |> @js.Value::cast_from |> @js.Value::cast,
    sprite.width * (curr_frame / refresh_rate).to_double(),
    0,
    sprite.width,
    sprite.height,
    0,
    0,
    sprite.width,
    sprite.height,
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
  entity : @entity.Entity
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
