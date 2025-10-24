
### 🎯 Purpose

This is the **heart** of your vault. It defines what your game _is and will be_.  
Every mechanic, rule, system, and interaction lives here.  
It’s where _ideas become features_ and _features become systems._

### 🧠 What Goes Here

1. **Features:** tangible gameplay mechanics (movement, passing, shooting)
2. **Systems:** large interlocking components (match engine, AI, tournaments)
3. **Design Concepts:** theoretical or planned ideas (player morale, career mode)
4. **Game Balance:** number tuning, difficulty, parameters
5. **Technical Design:** implementation details, algorithm outlines
6. Technical documentation (architecture, dependencies, scripts)

### 🔗 Connections

- Pulls ideas from `00_Inbox`
- Links to technical notes in `01_Development`
- Connects to player documentation in `03_Guides`
- Eventually feeds world data into `04_Wiki`

### 🧰 Best Practices

- Give each feature/system its own note.
- Link related systems (`[[Feature – Passing]]` links to `[[System – Match Engine]]`).
- Include **status fields** (“Planned / In Progress / Done”).
- Include **testing checklists** and **future ideas** sections inside each note.

### 📝 Example Note

`# Feature – Player Movement Tags: #feature #gameplay #task Status: In Progress Linked: [[Feature – Ball Physics]], [[System – Input Manager]]  ## Overview Defines how players move and accelerate on the field.  ## Mechanics - WASD controls with analog scaling - Acceleration curve based on stamina - Sprint limited by stamina bar  ## Technical Notes - Rigidbody for collisions - AnimatorController for direction changes  ## Future Ideas - Add dribbling animations with skill levels - Weather effects impacting speed`