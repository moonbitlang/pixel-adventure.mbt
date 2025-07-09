///|
const WIDTH : Double = 300.0

///|
const HEIGHT : Double = 150.0

///|
let next_frame : Map[@entity.Entity, UInt] = {}

///|
priv struct Animation {
  sprite : @dom.HTMLImageElement
  max_frame : UInt
  next_state : @object.State?
  height : Double
  width : Double
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
    {
      sprite: element,
      max_frame: 11,
      next_state: None,
      height: 32.0,
      width: 32.0,
    }
  }
  sprites[(MaskDude, Hit)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Hit (32x32).png",
    )
    {
      sprite: element,
      max_frame: 7,
      next_state: Some(Idle),
      height: 32.0,
      width: 32.0,
    }
  }
  sprites[(MaskDude, Jump)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Jump (32x32).png",
    )
    {
      sprite: element,
      max_frame: 1,
      next_state: None,
      height: 32.0,
      width: 32.0,
    }
  }
  sprites[(MaskDude, Fall)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png",
    )
    {
      sprite: element,
      max_frame: 1,
      next_state: None,
      height: 32.0,
      width: 32.0,
    }
  }
  sprites[(MaskDude, Run)] = {
    let element = @dom.HTMLImageElement::new()
    element.set_src(
      "/pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
    )
    {
      sprite: element,
      max_frame: 12,
      next_state: None,
      height: 32.0,
      width: 32.0,
    }
  }
}

///|
pub fn render(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.clear_rect(0, 0, WIDTH, HEIGHT)
  render_background(context)
  render_floor(context)
  for entity in @entity.entities() {
    if @object.get_character(entity) is Some(_) {
      render_character(context, entity)
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
    if sprite.next_state is Some(next_state) {
      @object.enter_state(entity, next_state)
    }
    next_frame[entity] = 0
  } else {
    next_frame[entity] = curr_frame + 1
  }

  // Draw the character
  guard @location.get_entity(entity) is Some({ location, .. })
  guard @object.get_direction(entity) is Some(direction)
  context.save()
  if direction is Left {
    context.translate(location.x + sprite.width, location.y)
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
fn render_floor(context : @dom.CanvasRenderingContext2D) -> Unit {
  context.save()
  for i = 0; i <= WIDTH.to_int() / 16; i = i + 1 {
    context.draw_image_with_src_and_dst_size(
      terrain |> @js.Value::cast_from |> @js.Value::cast,
      16,
      0,
      16,
      8,
      i.to_double() * 16.0,
      HEIGHT - 8.0,
      16,
      8,
    )
  }
  context.restore()
}
