///|
pub fn add_player(position : @math.Vec2D) -> Unit {
  guard player.val is None else { return }
  let entity = @entity.Entity::new()
  @object.set_character(entity, MaskDude)
  @object.enter_state(entity, Idle)
  @object.set_direction(entity, Right)
  @location.set_entity(
    entity,
    position,
    @math.HitBox::rect(
      position + @math.Vec2D::new(2, 0),
      @math.Vec2D::new(28, 32),
    ),
  )
  player.val = Some(entity)
  @entity.on_remove(entity, () => player.val = None)
}

///|
pub fn add_rockhead(position : @math.Vec2D) -> Unit {
  let rockhead = @entity.Entity::new()
  @object.set_character(rockhead, RockHead)
  @object.enter_state(rockhead, Idle)
  @object.set_direction(rockhead, Right)
  @location.set_entity(
    rockhead,
    position,
    @math.HitBox::rect(position, @math.Vec2D::new(32, 32)),
  )
  rockheads.set(rockhead, RockHeadAI::new(position, Down))
  @entity.on_remove(rockhead, () => rockheads.remove(rockhead))
}

///|
pub fn add_mushroom(position : @math.Vec2D) -> Unit {
  let mushroom = @entity.Entity::new()
  @object.set_character(mushroom, Mushroom)
  @object.enter_state(mushroom, Idle)
  @object.set_direction(mushroom, Right)
  @location.set_entity(
    mushroom,
    position,
    @math.HitBox::rect(
      position + @math.Vec2D::new(0, 12),
      @math.Vec2D::new(32, 20),
    ),
  )
}

///|
pub fn add_trophy(position : @math.Vec2D) -> Unit {
  let trophy = @entity.Entity::new()
  @object.set_character(trophy, Trophy)
  @object.enter_state(trophy, Idle)
  @object.set_direction(trophy, Right)
  @location.set_entity(
    trophy,
    position,
    @math.HitBox::rect(
      position + @math.Vec2D::new(4, 16),
      @math.Vec2D::new(56, 48),
    ),
  )
}

///|
pub fn add_banana(position : @math.Vec2D) -> Unit {
  let banana = @entity.Entity::new()
  @object.set_character(banana, Banana)
  @object.enter_state(banana, Idle)
  @object.set_direction(banana, Right)
  @location.set_entity(
    banana,
    position,
    @math.HitBox::rect(
      position,
      @math.Vec2D::new(32, 32),
    ),
  )
}
