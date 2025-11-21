---
Scene Name: Selection Tile
Godot Path: res://scenes/ui/elements/selection_tile/selection_tile.tscn
Scene Complexity: 1
Scene Type: UI Element
documentation: "[[Selection Tile]]"
---
### 🎯 Purpose

This is your **execution layer** — where strategy becomes action.  
It’s where you track what’s being worked on, who’s doing it, and what’s next.

### 🧠 What Goes Here

- Kanban board (`Kanban – Dev Tasks.md`)
- Roadmaps and milestones
- Sprint notes or task lists
- Task breakdowns for each system or feature
- Bugs and polish lists

### 🔗 Connections

- Each task should link to a feature in `02_Design`
- Progress updates should appear in `01_Development` (DevLogs)
- Completed items may feed patch notes or release logs

### 🧰 Best Practices

- Keep Kanban as your main planning view.
- Each card links to its own task note for details.
- Use tags like `#priority-high`, `#bug`, `#feature`.


### Kanban Usage

This Kanban board is used to plan, organize, and track the progress of all development tasks for the project.  
It follows an **Agile-style workflow**, allowing for flexibility, clarity, and iterative progress.

---

## 🎯 **Purpose**

The goal of this board is to:

- Break down the game’s development into **manageable tasks**
- Visualize what’s being worked on at any time
- Keep development focused, organized, and transparent for all contributors

Every task should represent a **small, actionable step** that can be completed within a short time frame (ideally within a day or two but up to 2 weeks).

---

## 🧱 **Board Columns**

|**Column**|**Description**|
|---|---|
|**Backlog**|All ideas, features, and tasks not yet scheduled. Think of this as the “idea pool.”|
|**To Do**|Tasks selected for the next sprint or current development cycle. Prioritized and ready to start.|
|**In Progress**|Tasks actively being worked on. Keep this list short to stay focused.|
|**Review**|Completed tasks that need testing, code review, or validation before being finalized.|
|**Done**|Fully completed, tested, and approved tasks.|

---

## 🏷️ **Tag System**

To keep tasks organized, each card/note uses **tags** to identify which part of the project it belongs to.

### Task Type Tags

| **Tag**     | **Purpose**                                                 |
| ----------- | ----------------------------------------------------------- |
| `#gameplay` | Core mechanics (movement, ball control, passing, shooting). |
| `#ai`       | Opponent and teammate logic.                                |
| `#ui`       | Menus, HUD, and user interaction.                           |
| `#assets`   | 3D models, textures, audio, animations.                     |
| `#tech`     | Backend systems, Rust integration, pipelines.               |
| `#testing`  | QA, bug reports, balancing, test cases.                     |
| `#docs`     | Documentation, design notes, coding standards.              |

> 💡 **Tip:** Each task should have at least one tag. Use a second tag if it spans multiple areas (e.g. a Rust-based UI system → `#ui #tech`).

### Priority Tags

| **Tag**     | **Purpose**                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------------- |
| `#critical` | Tasked need to be addressed immediately for game to work. Includes important bug fixes, core features, etc    |
| `#moderate` | Less important tasks but still needed soon                                                                    |
| `#polish`   | Not needed, but will make the game look, feel, or sound better                                                |
| `#optional` | Optional features that can converted to the other three priorities in the future, mainly for far future tasks |

### Effort Tags

| **Tag**     | **Purpose**                                                                                                    |
| ----------- | -------------------------------------------------------------------------------------------------------------- |
| `#short`    | Tasks that are simple and easy to complete within a day                                                        |
| `#medium`   | Tasks that would take multiple days to a week                                                                  |
| `#long`     | Tasks that would take at least a week or more. These tasks are also usually the most complex tasks to complete |


---

## 🔄 **Workflow Example**

1. Add a new task idea to **Backlog**.
2. When ready to start, move it to **To Do** and assign yourself (or tag your name).
3. Once you begin work, move it to **In Progress**.
4. When finished, move to **Review** for testing or feedback.
5. After testing and verification, move it to **Done**.

This flow ensures visibility of progress while keeping the workload balanced.

---

## 👥 **For Future Contributors**

- Always check the **To Do** column before starting new work.
- If creating new tasks, include a **clear title, short description, and relevant tags**.
- Don’t overload the **In Progress** column — focus on one or two tasks at a time.
- Use comments or linked notes to track discussions, related bugs, or dependencies.

---

## ✅ **Best Practices**

- Keep tasks small and actionable.
- Use consistent naming (e.g., `Implement Player Movement`, `Fix Ball Physics Bug`, `Create Pause Menu`).
- Review the board weekly to move stale tasks or reprioritize items.
- Maintain clarity — the board should reflect the _current truth_ of the project.