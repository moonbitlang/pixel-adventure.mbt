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
pub enum HitBox {
  Rect(position~ : Vec2D, size~ : Vec2D)
  Circle(position~ : Vec2D, radius~ : Double)
}

///|
pub fn HitBox::rect(position : Vec2D, size : Vec2D) -> HitBox {
  HitBox::Rect(position~, size~)
}

///|
pub fn HitBox::circle(position : Vec2D, radius : Double) -> HitBox {
  HitBox::Circle(position~, radius~)
}

///|
pub fn HitBox::intersects(box1 : HitBox, box2 : HitBox) -> Bool {
  match (box1, box2) {
    (Rect(position=pos1, size=size1), Rect(position=pos2, size=size2)) =>
      pos1.x <= pos2.x + size2.x &&
      pos1.x + size1.x >= pos2.x &&
      pos1.y <= pos2.y + size2.y &&
      pos1.y + size1.y >= pos2.y
    (Circle(position=pos1, radius=rad1), Circle(position=pos2, radius=rad2)) =>
      (pos1.x - pos2.x).pow(2) + (pos1.y - pos2.y).pow(2) <=
      (rad1 + rad2).pow(2)
    (Rect(position=pos1, size=size1), Circle(position=pos2, radius=rad2)) => {
      let closestX = pos2.x
        |> @cmp.maximum(pos1.x)
        |> @cmp.minimum(pos1.x + size1.x)
      let closestY = pos2.y
        |> @cmp.maximum(pos1.y)
        |> @cmp.minimum(pos1.y + size1.y)
      let distanceX = pos2.x - closestX
      let distanceY = pos2.y - closestY
      distanceX * distanceX + distanceY * distanceY <= rad2 * rad2
    }
    (Circle(position=pos1, radius=rad1), Rect(position=pos2, size=size2)) => {
      let closestX = pos1.x
        |> @cmp.maximum(pos2.x)
        |> @cmp.minimum(pos2.x + size2.x)
      let closestY = pos1.y
        |> @cmp.maximum(pos2.y)
        |> @cmp.minimum(pos2.y + size2.y)
      let distanceX = pos1.x - closestX
      let distanceY = pos1.y - closestY
      distanceX * distanceX + distanceY * distanceY <= rad1 * rad1
    }
  }
}

///|
pub fn HitBox::shift(hitbox : HitBox, dir : Vec2D) -> HitBox {
  match hitbox {
    Rect(position~, size~) => Rect(position=position + dir, size~)
    Circle(position~, radius~) => Circle(position=position + dir, radius~)
  }
}
