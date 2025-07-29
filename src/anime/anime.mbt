///|
pub const REFRESH_RATE : UInt = @config.GAME_FPS / 20

///|
pub let maskdude_idle : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png")
  Animation::new("MaskDudeIdle", element, max_frame=11, height=32.0, width=32.0)
}

///|
pub let maskdude_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Mask Dude/Hit (32x32).png")
  Animation::new(
    "MaskDudeHit",
    element,
    max_frame=7,
    loop_=false,
    height=32.0,
    width=32.0,
  )
}

///|
pub let maskdude_jump : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Mask Dude/Jump (32x32).png")
  Animation::new("MaskDudeJump", element, max_frame=1, height=32.0, width=32.0)
}

///|
pub let maskdude_fall : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Mask Dude/Fall (32x32).png")
  Animation::new("MaskDudeFall", element, max_frame=1, height=32.0, width=32.0)
}

///|
pub let maskdude_run : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Mask Dude/Run (32x32).png")
  Animation::new("MaskDudeRun", element, max_frame=12, height=32.0, width=32.0)
}

///|
pub let maskdude_disapper : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Desappearing (96x96).png")
  Animation::new(
    "MaskDudeDisapper",
    element,
    max_frame=7,
    loop_=false,
    height=96.0,
    width=96.0,
    offset=@math.Vec2D::new(-32, -32),
  )
}

///|
pub let mushroom_idle : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Enemies/Mushroom/Idle (32x32).png")
  Animation::new("MushroomIdle", element, max_frame=14, height=32.0, width=32.0)
}

///|
pub let mushroom_run : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Enemies/Mushroom/Run (32x32).png")
  Animation::new("MushroomRun", element, max_frame=16, height=32.0, width=32.0)
}

///|
pub let mushroom_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Enemies/Mushroom/Hit.png")
  Animation::new(
    "MushroomHit",
    element,
    max_frame=5,
    loop_=false,
    height=32.0,
    width=32.0,
  )
}

///|
pub let mushroom_disapper : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Main Characters/Desappearing (96x96).png")
  Animation::new(
    "MushroomDisapper",
    element,
    max_frame=7,
    loop_=false,
    height=96.0,
    width=96,
    offset=@math.Vec2D::new(-32, -32),
  )
}

///|
pub let banana_idle : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Items/Fruits/Bananas.png")
  Animation::new("BananaIdle", element, max_frame=17, height=32.0, width=32.0)
}

///|
pub let banana_disapper : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Items/Fruits/Collected.png")
  Animation::new(
    "BananaDisapper",
    element,
    max_frame=6,
    loop_=false,
    height=32.0,
    width=32.0,
  )
}

///|
pub let trophy_idle : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Items/Checkpoints/End/End (Idle).png")
  Animation::new("TrophyIdle", element, max_frame=1, height=64.0, width=64.0)
}

///|
pub let trophy_pressed : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src(
    "pixel_adventure/Items/Checkpoints/End/End (Pressed) (64x64).png",
  )
  Animation::new(
    "TrophyPressed",
    element,
    max_frame=8,
    loop_=false,
    height=64.0,
    width=64.0,
  )
}

///|
pub let rockhead_idle : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Idle.png")
  Animation::new(
    "RockHeadIdle",
    element,
    max_frame=1,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_blink : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Blink (42x42).png")
  Animation::new(
    "RockHeadBlink",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Hit (42x42).png")
  Animation::new(
    "RockHeadHit",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_bottom_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Bottom Hit (42x42).png")
  Animation::new(
    "RockHeadBottomHit",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_left_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Left Hit (42x42).png")
  Animation::new(
    "RockHeadLeftHit",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_right_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Right Hit (42x42).png")
  Animation::new(
    "RockHeadRightHit",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub let rockhead_top_hit : Animation = {
  let element = @dom.HTMLImageElement::new()
  element.set_src("/pixel_adventure/Traps/Rock Head/Top Hit (42x42).png")
  Animation::new(
    "RockHeadTopHit",
    element,
    max_frame=4,
    loop_=false,
    height=42.0,
    width=42.0,
    offset=@math.Vec2D::new(-5, -5),
  )
}

///|
pub struct Animation {
  sprite : @dom.HTMLImageElement
  id : String
  max_frame : UInt
  loop_ : Bool
  height : Double
  width : Double
  offset : @math.Vec2D
}

///|
fn Animation::new(
  id : String,
  sprite : @dom.HTMLImageElement,
  max_frame~ : UInt,
  loop_~ : Bool = true,
  height~ : Double,
  width~ : Double,
  offset~ : @math.Vec2D = @math.Vec2D::new(0, 0),
) -> Animation {
  {
    sprite,
    id,
    max_frame: max_frame * REFRESH_RATE,
    loop_,
    height,
    width,
    offset,
  }
}

///|
pub(all) struct Sprite {
  animation : Animation
  mut pos : UInt
  mut callbacks : Array[@event.Event]
}

///|
pub let sprites : Map[@entity.Entity, Sprite] = {}

///|
pub let default_sprites : Map[@object.Character, Animation] = {}

///|
fn init {
  default_sprites[MaskDude] = maskdude_idle
  default_sprites[Mushroom] = mushroom_idle
  default_sprites[Banana] = banana_idle
  default_sprites[Trophy] = trophy_idle
  default_sprites[RockHead] = rockhead_idle
}

///|
pub fn play_animation(
  entity : @entity.Entity,
  animation : Animation,
  from_start~ : Bool = false,
  callback~ : @event.Event? = None,
) -> Unit {
  match sprites.get(entity) {
    None =>
      sprites[entity] = {
        animation,
        pos: 0,
        callbacks: if callback is Some(cb) {
          [cb]
        } else {
          []
        },
      }
    Some(sprite) =>
      if sprite.animation.id != animation.id {
        sprites[entity] = {
          animation,
          pos: 0,
          callbacks: if callback is Some(cb) {
            [cb]
          } else {
            []
          },
        }
      } else if from_start {
        sprite.pos = 0
        if callback is Some(cb) {
          sprite.callbacks.push(cb)
        }
      }
  }
}
