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
pub struct Vec2D {
  x : Double
  y : Double
} derive(Show)

///|
pub fn Vec2D::new(x : Double, y : Double) -> Vec2D {
  { x, y }
}

///|
pub impl Add for Vec2D with op_add(this, other) {
  Vec2D::new(this.x + other.x, this.y + other.y)
}

///|
pub impl Mul for Vec2D with op_mul(this, other) {
  Vec2D::new(this.x * other.x, this.y * other.y)
}

///|
pub impl Neg for Vec2D with op_neg(this) {
  Vec2D::new(-this.x, -this.y)
}

///|
pub impl Sub for Vec2D with op_sub(this, other) {
  Vec2D::new(this.x - other.x, this.y - other.y)
}

///|
pub fn Vec2D::magnitude(this : Vec2D) -> Double {
  (this.x * this.x + this.y * this.y).sqrt()
}

///|
pub fn Vec2D::normalize(this : Vec2D) -> Vec2D {
  let mag = this.magnitude()
  if mag > 0.0 {
    Vec2D::new(this.x / mag, this.y / mag)
  } else {
    Vec2D::new(1.0, 0.0) // Default direction if magnitude is zero
  }
}

///|
pub enum HitBox {
  Rect(position~ : Vec2D, size~ : Vec2D)
}

///|
pub fn HitBox::rect(position : Vec2D, size : Vec2D) -> HitBox {
  HitBox::Rect(position~, size~)
}

///| Collision information containing the direction and penetration depth
pub struct CollisionInfo {
  direction : Vec2D // Unit vector pointing from box1 to box2
  depth : Double // How much the boxes overlap
} derive(Show)

///| Check if two hitboxes intersect and return collision resolution information
pub fn HitBox::intersects(box1 : HitBox, box2 : HitBox) -> CollisionInfo? {
  match (box1, box2) {
    (Rect(position=pos1, size=size1), Rect(position=pos2, size=size2)) => {
      let overlap_x = @cmp.minimum(pos1.x + size1.x, pos2.x + size2.x) -
        @cmp.maximum(pos1.x, pos2.x)
      let overlap_y = @cmp.minimum(pos1.y + size1.y, pos2.y + size2.y) -
        @cmp.maximum(pos1.y, pos2.y)
      if overlap_x > 0.0 && overlap_y > 0.0 {
        let center1 = Vec2D::new(pos1.x + size1.x / 2.0, pos1.y + size1.y / 2.0)
        let center2 = Vec2D::new(pos2.x + size2.x / 2.0, pos2.y + size2.y / 2.0)
        let direction = center2 - center1

        // Choose the axis with smaller overlap for resolution
        if overlap_x < overlap_y {
          let dir = if direction.x > 0.0 { 1.0 } else { -1.0 }
          Some({ direction: Vec2D::new(dir, 0.0), depth: overlap_x })
        } else {
          let dir = if direction.y > 0.0 { 1.0 } else { -1.0 }
          Some({ direction: Vec2D::new(0.0, dir), depth: overlap_y })
        }
      } else {
        None
      }
    }
  }
}

///|
pub fn HitBox::shift(hitbox : HitBox, dir : Vec2D) -> HitBox {
  match hitbox {
    Rect(position~, size~) => Rect(position=position + dir, size~)
  }
}

///| Resolve collision by moving box1 out of box2
pub fn HitBox::resolve_collision(box1 : HitBox, box2 : HitBox) -> HitBox? {
  match HitBox::intersects(box1, box2) {
    Some(collision) => {
      // Move box1 away from box2 by the collision depth
      let resolution = Vec2D::new(
        collision.direction.x * collision.depth,
        collision.direction.y * collision.depth,
      )
      Some(HitBox::shift(box1, resolution))
    }
    None => None
  }
}

///| Get the minimum translation vector to separate two colliding boxes
pub fn HitBox::get_separation_vector(box1 : HitBox, box2 : HitBox) -> Vec2D? {
  match HitBox::intersects(box1, box2) {
    Some(collision) =>
      Some(
        Vec2D::new(
          collision.direction.x * collision.depth,
          collision.direction.y * collision.depth,
        ),
      )
    None => None
  }
}
