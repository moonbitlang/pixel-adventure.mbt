# Pixel Adventure Game 🎮

A 2D side-scrolling platformer adventure game built with
[MoonBit](https://moonbitlang.com), featuring pixel art graphics and web browser
gameplay.

## 🎯 Game Overview

Control a masked adventurer as they journey through a pixel world filled with
obstacles, enemies (to be added), and treasures. Navigate platforms, avoid
dangers, and reach the trophy at the end of the level!

### Controls

- **Arrow Keys**: Move left/move right/jump

### Objective

Navigate through the platforming level, collect as many bananas as possible, and
reach the golden trophy at the end while avoiding enemies and hazards.

## 🚀 Getting Started

### Prerequisites

- [MoonBit CLI tools](https://moonbitlang.com/download/)
- Modern web browser with JavaScript support

### Installation & Running

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pixel-adventure
   ```

2. **Build the game**
   ```bash
   moon build --target js
   ```

3. **Run a local web server**
   ```bash
   # Using Python (if available)
   python -m http.server 8000

   # Using Node.js (if available)
   npx serve .

   # Or any other static file server
   ```

4. **Open in browser** Navigate to `http://localhost:8000` and open `index.html`

## 🛠️ Development

### Project Structure

```
src/
├── main.mbt           # Game entry point and main loop
├── config/            # Game configuration and constants
├── entity/            # Entity component system
├── object/            # Game object types and states
├── location/          # Position and collision systems
├── map/               # Level generation and terrain
├── state/             # Game state management and AI
├── render/            # Graphics rendering system
├── external/          # Browser APIs and input handling
└── math/              # Vector math and utilities
```

## 🎨 Assets

The game uses the beautiful
[**Pixel Adventure**](https://pixelfrog-assets.itch.io/pixel-adventure-1) asset
pack, featuring:

- Character sprites with multiple animation states
- Diverse enemy types (RockHeads, Mushrooms, etc.)
- Environmental elements and terrain tiles
- Collectible items and interactive objects
- Menu and UI elements

## 🔧 Configuration

Game settings can be modified in `src/config/top.mbt`:

- **Screen Dimensions**: Game and viewport size
- **Frame Rate**: Game update frequency (default: 60 FPS)
- **Physics Constants**: Gravity, movement speed, jump height

---

**Embark on your pixel adventure today!** 🏆
