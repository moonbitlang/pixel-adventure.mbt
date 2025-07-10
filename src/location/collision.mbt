// TODO: use quadtree

///|
let collision : Map[@entity.Entity, @set.Set[@entity.Entity]] = {}

///|
pub fn update_collision() -> Unit {
  collision.clear()
  let objs = @entity.entities()
    .filter_map(e => if get_entity(e) is Some(location) {
      Some((e, location.hitbox))
    } else {
      None
    })
    .collect()
  for o1 in objs {
    for o2 in objs {
      if o1.0 == o2.0 {
        continue
      }
      let intersections1 = if collision.get(o1.0) is Some(intersections) {
        intersections
      } else {
        let intersections = @set.Set::new()
        collision[o1.0] = intersections
        intersections
      }
      let intersection2 = if collision.get(o2.0) is Some(intersections) {
        intersections
      } else {
        let intersections = @set.Set::new()
        collision[o2.0] = intersections
        intersections
      }
      if o1.1.intersects(o2.1) {
        intersections1.add(o2.0)
        intersection2.add(o1.0)
      }
    }
  }
}

///|
pub fn get_collision(entity : @entity.Entity) -> @set.Set[@entity.Entity] {
  collision.get(entity).unwrap_or(@set.Set::new())
}
