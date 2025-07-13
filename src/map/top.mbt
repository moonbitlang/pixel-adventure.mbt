///|
let rand : @random.Rand = @random.Rand::chacha8()

///|
pub fn generate() -> Unit {
  let mut missing_size = 0
  let mut rockhead_dist = 0
  // Generate floors
  for i = 0; i < @config.GAME_WIDTH.to_int() / 16 + 1; i = i + 1 {
    if rockhead_dist > 0 {
      rockhead_dist -= 1
    }
    // Randomly skip some floors
    if missing_size > 1 {
      missing_size -= 1
      continue
    } else if missing_size == 1 {
      missing_size = 0
    } else if i > 10 && i < @config.GAME_WIDTH.to_int() / 16 - 20 {
      if rand.int(limit=5) == 0 {
        missing_size = rand.int(limit=3) + 2
        continue
      }
    }
    // Generate a floor
    let terrain = @entity.Entity::new()
    @object.set_terrain(terrain, Flat_Steel)
    @location.set_entity(
      terrain,
      @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 8),
      @math.HitBox::rect(
        @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 8),
        @math.Vec2D::new(16, 8),
      ),
    )

    // Generate a banana

    // Generate a rockhead
    if i > 10 && i < @config.GAME_WIDTH.to_int() / 16 - 20 {
      if rockhead_dist == 0 && rand.int(limit=10) == 0 {
        rockhead_dist = 3
        @state.add_rockhead(
          @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 200),
        )
      } else if rand.int(limit=20) == 0 {
        @state.add_banana(
          @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 40),
        )
      }
    }
  }

  // Generate game end trophy
  @state.add_trophy(
    @math.Vec2D::new(@config.GAME_WIDTH - 72, @config.GAME_HEIGHT - 72),
  )

  // Generate player
  @state.add_player(@math.Vec2D::new(0, @config.GAME_HEIGHT - 40))
}
