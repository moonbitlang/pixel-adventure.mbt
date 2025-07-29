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
// pub(all) enum State {
//   Idle
//   Hit
//   Jump
//   Fall
//   Run
//   Disapper
//   Pressed
//   Blink
//   BottomHit
//   RightHit
//   TopHit
//   LeftHit
// } derive(Eq, Hash, Show)

///|
pub(all) enum Direction {
  Left
  Right
}

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
typealias Int as Mass

///|
pub fn get_mass(entity : @entity.Entity) -> Mass {
  match get_character(entity) {
    Some(RockHead) => 50
    Some(Banana) => 10
    Some(Mushroom) => 20
    Some(MaskDude) => 30
    Some(Trophy) => 0
    None => 100
  }
}

///| Only the lighter entity can be pushed by the heavier one.
pub fn collides(entity1 : @entity.Entity, entity2 : @entity.Entity) -> Bool {
  get_mass(entity1) < get_mass(entity2)
}
