///|
test {
  let entity = Entity::new()
  let entity2 = Entity::new()
  assert_not_eq(entity, entity2)
  assert_eq(entity, entity)
}
