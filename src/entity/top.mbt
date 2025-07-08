///|
type Entity UInt derive(Eq, Show, Hash)

///|
let generator : Ref[UInt] = { val: 0 }

///|
pub fn Entity::new() -> Entity {
  generator.val += 1
  generator.val
}
