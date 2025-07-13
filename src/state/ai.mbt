///|
priv enum Dir2D {
  Up
  Down
  Left
  Right
}

///|
priv enum RockHeadPhase {
  Waiting
  Attacking
  Resting(countdown~ : Int)
  Returning
}

///|
priv struct RockHeadAI {
  origin : @math.Vec2D
  direction : Dir2D
  mut phase : RockHeadPhase
}

///|
fn RockHeadAI::new(origin : @math.Vec2D, direction : Dir2D) -> RockHeadAI {
  { origin, direction, phase: Waiting }
}

///|
let rockheads : Map[@entity.Entity, RockHeadAI] = {}
