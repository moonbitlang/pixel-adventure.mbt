///|
const WIDTH = 512.0

///|
const HEIGHT = 256.0

///|
const MAX_DEPTH = 5

///|
pub let quadtree : Ref[QuadTree] = {
  val: QuadTree::new(@math.Vec2D::new(0, 0), @math.Vec2D::new(WIDTH, HEIGHT), 0),
}

///|
pub fn get_collision(entity : @entity.Entity) -> @set.Set[@entity.Entity] {
  state
  .get(entity)
  .map(st => quadtree.val
    .query(st.hitbox)
    .iter()
    .filter(e => {
      let hitbox = state.get(e).unwrap().hitbox
      e != entity && hitbox.intersects(st.hitbox)
    })
    |> @set.Set::from_iter)
  .unwrap_or(@set.Set::new())
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
  depth : Int
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
  hitbox : @math.HitBox
) -> Unit {
  if !self.bounding_box.intersects(hitbox) {
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
  area : @math.HitBox
) -> @set.Set[@entity.Entity] {
  let mut trees = @list.of([self])
  let mut results = @set.Set::new()
  while trees is More(hd, tail=rest) {
    trees = rest
    if !hd.bounding_box.intersects(area) {
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
