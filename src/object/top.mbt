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
pub(all) enum Character {
  MaskDude
  Mushroom
  Banana
  RockHead
  Trophy
} derive(Eq, Hash)

///|
pub(all) enum Terrain {
  Flat_Steel
  GrassBlock
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
  Blink
  BottomHit
  RightHit
  TopHit
  LeftHit
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
let terrain : Map[@entity.Entity, Terrain] = {}

///|
pub fn set_terrain(entity : @entity.Entity, obj : Terrain) -> Unit {
  if terrain.get(entity) is None {
    @entity.on_remove(entity, () => terrain.remove(entity))
  }
  terrain[entity] = obj
}

///|
pub fn get_terrain(entity : @entity.Entity) -> Terrain? {
  terrain.get(entity)
}

///|
pub fn has_gravity(entity : @entity.Entity) -> Bool {
  get_character(entity) is Some(MaskDude | Mushroom)
}

///|
/// Check if two entities should collide and the first entity should give way to the second
/// 
/// i.e. if the first entity should resolve the collision by moving out of the way
pub fn collides(entity1 : @entity.Entity, entity2 : @entity.Entity) -> Bool {
  guard get_character(entity1) is Some(character) else {
    // Terrain never moves
    false
  }
  if character is Banana {
    // Bananas never move
    return false
  }
  if character is RockHead {
    return get_terrain(entity2) is Some(_) ||
      !(get_character(entity2) is Some(Banana))
  } else {
    get_terrain(entity2) is Some(_) || get_character(entity2) is Some(RockHead)
  }
}
