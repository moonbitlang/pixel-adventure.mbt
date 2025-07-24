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

    // Generate floor in the air
    if i > 10 &&
      i < @config.GAME_WIDTH.to_int() / 16 - 20 &&
      rand.int(limit=10) == 0 {
      let width = rand.int(limit=3) + 3
      for j = 0; j < width; j = j + 1 {
        let terrain = @entity.Entity::new()
        @object.set_terrain(terrain, GrassBlock)
        @location.set_entity(
          terrain,
          @math.Vec2D::new((i + j).to_double() * 16, @config.GAME_HEIGHT - 60),
          @math.HitBox::rect(
            @math.Vec2D::new((i + j).to_double() * 16, @config.GAME_HEIGHT - 60),
            @math.Vec2D::new(16, 16),
          ),
        )
      }
      continue
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
    @object.set_terrain(terrain, GrassBlock)
    @location.set_entity(
      terrain,
      @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 16),
      @math.HitBox::rect(
        @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 16),
        @math.Vec2D::new(16, 16),
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
          @math.Vec2D::new(i.to_double() * 16, @config.GAME_HEIGHT - 48),
        )
      }
    }
  }

  // Generate game end trophy
  @state.add_trophy(
    @math.Vec2D::new(@config.GAME_WIDTH - 72, @config.GAME_HEIGHT - 80),
  )

  // Generate player
  @state.add_player(@math.Vec2D::new(0, @config.GAME_HEIGHT - 48))
}
