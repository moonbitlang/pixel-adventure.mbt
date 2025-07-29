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
priv enum CollisionLayer {
  MaskDude
  RockHead
  Pickup
  Terrain
} derive(Eq)

///|
typealias Array[CollisionLayer] as CollisionMask

///|
fn get_collision_mask(entity : @entity.Entity) -> CollisionMask {
  match @object.get_character(entity) {
    Some(MaskDude) => [Terrain, RockHead]
    Some(RockHead) => [RockHead, Terrain]
    Some(Mushroom) => [MaskDude, Terrain]
    Some(Banana) => [MaskDude, Terrain]
    Some(Trophy) => [MaskDude, Terrain]
    _ => []
  }
}

///|
fn get_collision_layer(entity : @entity.Entity) -> CollisionLayer {
  match @object.get_character(entity) {
    Some(MaskDude) => MaskDude
    Some(RockHead) => RockHead
    Some(Mushroom) => Pickup
    Some(Banana) => Pickup
    Some(Trophy) => Pickup
    _ => Terrain
  }
}

///|
fn collides(entity : @entity.Entity, other : @entity.Entity) -> Bool {
  if entity == other {
    return false
  }
  let mask = get_collision_mask(entity)
  let layer = get_collision_layer(other)
  mask.contains(layer)
}

///|
const MAX_DEPTH = 5

///|
pub let quadtree : Ref[QuadTree] = {
  val: QuadTree::new(
    @math.Vec2D::new(0, 0),
    @math.Vec2D::new(@config.GAME_WIDTH, @config.GAME_HEIGHT),
    0,
  ),
}

///|
pub fn get_collision(
  entity : @entity.Entity,
) -> Map[@entity.Entity, @math.CollisionInfo] {
  state
  .get(entity)
  .map(st => quadtree.val
    .query(st.hitbox)
    .iter()
    .filter_map(
      // The entity could have been removed
      e => if state.get(e) is Some({ hitbox, .. }) &&
        e != entity &&
        hitbox.intersects(st.hitbox) is Some(vec) {
        Some((e, vec))
      } else {
        None
      },
    )
    |> Map::from_iter)
  .unwrap_or({})
}

///|
pub struct QuadTree {
  position : @math.Vec2D
  size : @math.Vec2D
  children : Array[QuadTree]
  priv depth : Int
  priv bounding_box : @math.HitBox
  priv entities : @set.Set[@entity.Entity]
}

///|
fn QuadTree::new(
  position : @math.Vec2D,
  size : @math.Vec2D,
  depth : Int,
) -> QuadTree {
  {
    position,
    size,
    depth,
    entities: @set.Set::new(),
    children: [],
    bounding_box: @math.HitBox::rect(position, size),
  }
}

///|
fn QuadTree::insert(
  self : Self,
  entity : @entity.Entity,
  hitbox : @math.HitBox,
) -> Unit {
  if self.bounding_box.intersects(hitbox) is None {
    return
  }
  if self.depth >= MAX_DEPTH {
    self.entities.add(entity)
    return
  }
  if self.children.is_empty() {
    let half_size = @math.Vec2D::new(self.size.x * 0.5, self.size.y * 0.5)
    self.children
    ..push(QuadTree::new(self.position, half_size, self.depth + 1))
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D::new(half_size.x, 0),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(
      QuadTree::new(
        self.position + @math.Vec2D::new(0, half_size.y),
        half_size,
        self.depth + 1,
      ),
    )
    ..push(QuadTree::new(self.position + half_size, half_size, self.depth + 1))
  }
  for child in self.children {
    child.insert(entity, hitbox)
  }
}

///|
fn QuadTree::query(
  self : Self,
  area : @math.HitBox,
) -> @set.Set[@entity.Entity] {
  let mut trees = @list.of([self])
  let mut results = @set.Set::new()
  while trees is More(hd, tail=rest) {
    trees = rest
    if hd.bounding_box.intersects(area) is None {
      continue
    }
    if hd.children is [] {
      results = results.union(hd.entities)
    } else {
      hd.children.each(t => trees = trees.add(t))
    }
  }
  results
}
