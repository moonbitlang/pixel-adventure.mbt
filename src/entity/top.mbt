///|
type Entity UInt derive(Eq, Show, Hash)

///|
let generator : Ref[UInt] = { val: 0 }

///|
pub fn Entity::new() -> Entity {
  let entity = generator.val
  generator.val += 1
  all_entities.add(entity)
  entity
}

///|
let all_entities : @set.Set[Entity] = @set.Set::new()

///|
let callbacks : Map[Entity, Array[() -> Unit]] = {}

///|
pub fn entities() -> Iter[Entity] {
  all_entities.iter()
}

///|
pub fn remove_entities(entity : Entity) -> Unit {
  all_entities.remove(entity)
  let cbs = callbacks.get(entity).unwrap_or([])
  for callback in cbs {
    callback()
  }
  callbacks.remove(entity)
}

///|
pub fn on_remove(entity : Entity, callback : () -> Unit) -> Unit {
  if callbacks.get(entity) is Some(cbs) {
    cbs.push(callback)
  } else {
    callbacks[entity] = [callback]
  }
}
