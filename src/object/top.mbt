///|
pub(all) enum Character {
  MaskDude
  Mushroom
  Banana
  Trophy
} derive(Eq, Hash)

///|
pub(all) enum Object {
  Terrain(offset~ : @math.Vec2D, size~ : @math.Vec2D)
}

///|
pub(all) enum State {
  Idle
  Hit
  Jump
  Fall
  Run
  Disapper
  Pressed
} derive(Eq, Hash, Show)

///|
pub(all) enum Direction {
  Left
  Right
}

///|
pub(all) enum Stage {
  Enter
  Active
  Exit
} derive(Eq, Hash)

///|
let character : Map[@entity.Entity, Character] = {}

///|
pub fn set_character(entity : @entity.Entity, char : Character) -> Unit {
  if character.get(entity) is None {
    @entity.on_remove(entity, () => character.remove(entity))
  }
  character[entity] = char
}

///|
pub fn get_character(entity : @entity.Entity) -> Character? {
  character.get(entity)
}

///|
let state : Map[@entity.Entity, State] = {}

///|
pub fn enter_state(entity : @entity.Entity, new_state : State) -> Unit {
  if stage.get(entity) is None {
    @entity.on_remove(entity, () => stage.remove(entity))
  }
  if state.get(entity) is None {
    @entity.on_remove(entity, () => state.remove(entity))
  }
  state[entity] = new_state
  stage[entity] = Enter
}

///|
pub fn get_state(entity : @entity.Entity) -> State? {
  state.get(entity)
}

///|
let direction : Map[@entity.Entity, Direction] = {}

///|
pub fn set_direction(entity : @entity.Entity, dir : Direction) -> Unit {
  if direction.get(entity) is None {
    @entity.on_remove(entity, () => direction.remove(entity))
  }
  direction[entity] = dir
}

///|
pub fn get_direction(entity : @entity.Entity) -> Direction? {
  direction.get(entity)
}

///|
let stage : Map[@entity.Entity, Stage] = {}

///|
pub fn set_stage(entity : @entity.Entity, new_stage : Stage) -> Unit {
  if stage.get(entity) is None {
    @entity.on_remove(entity, () => stage.remove(entity))
  }
  stage[entity] = new_stage
}

///|
pub fn get_stage(entity : @entity.Entity) -> Stage? {
  stage.get(entity)
}

///|
let object : Map[@entity.Entity, Object] = {}

///|
pub fn set_object(entity : @entity.Entity, obj : Object) -> Unit {
  if object.get(entity) is None {
    @entity.on_remove(entity, () => object.remove(entity))
  }
  object[entity] = obj
}

///|
pub fn get_object(entity : @entity.Entity) -> Object? {
  object.get(entity)
}

///|
pub fn has_gravity(entity : @entity.Entity) -> Bool {
  get_character(entity) is Some(MaskDude | Mushroom)
}
