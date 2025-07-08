///|
test "Vec2D creation and basic operations" {
  let v1 = @math.Vec2D::new(3.0, 4.0)
  let v2 = @math.Vec2D::new(1.0, 2.0)
  let sum = v1 + v2
  assert_eq(sum.x, 4.0)
  assert_eq(sum.y, 6.0)
  let product = v1 * v2
  assert_eq(product.x, 3.0)
  assert_eq(product.y, 8.0)
}

///|
test "Vec2D magnitude calculation" {
  let v1 = @math.Vec2D::new(3.0, 4.0)
  let magnitude = v1.magnitude()
  assert_eq(magnitude, 5.0)
  let v2 = @math.Vec2D::new(0.0, 0.0)
  assert_eq(v2.magnitude(), 0.0)
}

///|
test "HitBox rect creation and intersection" {
  let rect1 = @math.HitBox::rect(
    @math.Vec2D::new(0.0, 0.0),
    @math.Vec2D::new(10.0, 10.0),
  )
  let rect2 = @math.HitBox::rect(
    @math.Vec2D::new(5.0, 5.0),
    @math.Vec2D::new(10.0, 10.0),
  )
  let rect3 = @math.HitBox::rect(
    @math.Vec2D::new(20.0, 20.0),
    @math.Vec2D::new(5.0, 5.0),
  )
  assert_true(@math.HitBox::intersects(rect1, rect2))
  assert_false(@math.HitBox::intersects(rect1, rect3))
}

///|
test "HitBox circle creation and intersection" {
  let circle1 = @math.HitBox::circle(@math.Vec2D::new(0.0, 0.0), 5.0)
  let circle2 = @math.HitBox::circle(@math.Vec2D::new(3.0, 4.0), 3.0)
  let circle3 = @math.HitBox::circle(@math.Vec2D::new(20.0, 20.0), 2.0)
  assert_true(@math.HitBox::intersects(circle1, circle2))
  assert_false(@math.HitBox::intersects(circle1, circle3))
}

///|
test "HitBox rect and circle intersection" {
  let rect = @math.HitBox::rect(
    @math.Vec2D::new(0.0, 0.0),
    @math.Vec2D::new(10.0, 10.0),
  )
  let circle1 = @math.HitBox::circle(@math.Vec2D::new(5.0, 5.0), 2.0)
  let circle2 = @math.HitBox::circle(@math.Vec2D::new(20.0, 20.0), 2.0)
  assert_true(@math.HitBox::intersects(rect, circle1))
  assert_true(@math.HitBox::intersects(circle1, rect))
  assert_false(@math.HitBox::intersects(rect, circle2))
  assert_false(@math.HitBox::intersects(circle2, rect))
}

///|
test "HitBox edge cases" {
  let rect = @math.HitBox::rect(
    @math.Vec2D::new(0.0, 0.0),
    @math.Vec2D::new(10.0, 10.0),
  )
  let circle_touching = @math.HitBox::circle(@math.Vec2D::new(15.0, 5.0), 5.0)
  let circle_corner = @math.HitBox::circle(@math.Vec2D::new(10.0, 10.0), 1.0)
  assert_true(@math.HitBox::intersects(rect, circle_touching))
  assert_true(@math.HitBox::intersects(rect, circle_corner))
}
