///|
pub const WIDTH : Double = 512.0

///|
pub const HEIGHT : Double = 256.0

///|
const DEBUG = true

///|
let next_frame : Map[@entity.Entity, UInt] = {}

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
  { sprite, max_frame, loop_, height, width, offset }
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
}

///|
pub fn render(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.clear_rect(0, 0, WIDTH, HEIGHT)
  render_background(context)
  for entity in @entity.entities() {
    if @object.get_character(entity) is Some(_) {
      render_character(context, entity)
    }
    if @object.get_object(entity) is Some(_) {
      render_object(context, entity)
    }
  }
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
      @object.set_stage(entity, Exit)
    }
    next_frame[entity] = 0
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
    context.translate(location.x, location.y)
  }
  context.draw_image_with_src_and_dst_size(
    sprite.sprite |> @js.Value::cast_from |> @js.Value::cast,
    sprite.width * curr_frame.to_double(),
    0,
    sprite.width,
    sprite.height,
    0,
    0,
    sprite.width,
    sprite.height,
  )
  context.restore()

  // Draw the hitbox if in debug mode
  if DEBUG {
    guard @location.get_entity(entity) is Some({ hitbox, .. })
    match hitbox {
      Rect(position~, size~) => {
        context.save()
        context.set_stroke_style(@js.Union3::from0("red"))
        context.stroke_rect(position.x, position.y, size.x, size.y)
        context.restore()
      }
      Circle(position~, radius~) => {
        context.save()
        context.set_stroke_style(@js.Union3::from0("red"))
        context.begin_path()
        context.arc(
          position.x,
          position.y,
          radius,
          0.0,
          2.0 * @moonbitlang/core/math.PI,
        )
        context.stroke()
        context.restore()
      }
    }
  }
}

///|
extern "js" fn @dom.CanvasRenderingContext2D::create_pattern(
  self : @dom.CanvasRenderingContext2D,
  image : @dom.HTMLImageElement,
  repetition : String
) -> @dom.CanvasPattern =
  #|(self, image, repetition) => self.createPattern(image, repetition)

///|
let background : @dom.HTMLImageElement = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Background/Blue.png")
  element
}

///|
fn render_background(context : @dom.CanvasRenderingContext2D) -> Unit {
  let pattern = context.create_pattern(background, "repeat")
  context.save()
  context.set_fill_style(@js.Union3::from2(pattern))
  context.fill_rect(0, 0, WIDTH, HEIGHT)
  context.restore()
}

///|
let terrain : @dom.HTMLImageElement = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Terrain/Terrain (16x16).png")
  element
}

///|
fn render_object(
  context : @dom.CanvasRenderingContext2D,
  entity : @entity.Entity
) -> Unit {
  guard @object.get_object(entity) is Some(object)
  guard @location.get_entity(entity) is Some({ location, .. }) else { return }
  if object is Terrain(offset~, size~) {
    context.draw_image_with_src_and_dst_size(
      terrain |> @js.Value::cast_from |> @js.Value::cast,
      offset.x,
      offset.y,
      size.x,
      size.y,
      location.x,
      location.y,
      size.x,
      size.y,
    )
  }
}
