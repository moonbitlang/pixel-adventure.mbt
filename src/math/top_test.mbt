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
  inspect(
    @math.HitBox::intersects(rect1, rect2),
    content="Some({direction: {x: 0, y: 1}, depth: 5})",
  )
  inspect(@math.HitBox::intersects(rect1, rect3), content="None")
}
