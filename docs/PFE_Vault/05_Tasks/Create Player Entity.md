
**Status:**  To Do
**Type:** #gameplay 
**Priority:** #critical   
**Effort:** #short`(≤1 day)`  
**Created:** 2026-08-19  
**Last Updated:** 2026-08-19  
**Owner:** Eddie 
**Related GitHub Issue (if any):** 


---

## Overview
Briefly describe the **goal** of this task and what it adds to the game.

- To create the core entity and components of the players in the match engine
- Decide what information is relevant for the player in the match engine, here the smaller is better

---

##  Background / Rationale
Explain **why this task exists** and what problem or opportunity it addresses.  
This helps remind you (or future collaborators) of the reasoning behind it.

> _Example:_  
> The player movement system is the foundation for all in-game actions. It needs to feel responsive, intuitive, and work across controllers and keyboards.

This task is needed to set the ground work for the player and its data inside the match scene. The entire match engine logic is dependent on this 


---

## Scope Breakdown
List out the **specific elements** or deliverables that define this task.

| Category          | Description                           |
| ----------------- | ------------------------------------- |
| **Feature**       | Ball movement and collision logic     |
| **UI**            | Stamina bar display                   |
| **Audio**         | Kick sound effects                    |
| **Art/Animation** | Player running and turning animations |


---

## Implementation Steps
Concrete, actionable steps for completing the task.  
Mark them off as you go.

- [ ] Step 1: Design the player entity and its components
- [ ] Step 2: Ensure the entity is as small as possible in memory
- [ ] Step 3: Start planning the systems that would interact with different components of this player entity


> ⏳ **Tip:** Use `Ctrl + Enter` to check off tasks as you progress.

---

## Dependencies
List what this task depends on or what depends on it.

As of right now, no dependencies


---

## Testing & QA Checklist
Ensure this task is **verified and functional** before moving to “Review.”


---

## Review Notes
Use this section during peer/self-review or testing.

| Reviewer | Date     | Notes                       |
| -------- | -------- | --------------------------- |
| {{Name}} | 2026-08-19 | {{Observation or feedback}} |
| {{Name}} | 2026-08-19 | {{Observation or feedback}} |


---

## Completion Criteria
Define what “**Done**” means clearly, so you know when to stop tweaking.

> _Example:_  
> - Player can move in all directions with realistic momentum.  
> - Ball dribbling feels smooth and consistent.  
> - No visible jitter or clipping.  
> - Code is committed and reviewed.  
> - Task marked as `#done`.

Player Entity is create and is can be added to the Bevy ECS model for the match. 

---

## Documentation & Resources
Link to any design docs, reference materials, or related systems.

[[01_Development/Player Entity]]

---

## Lessons Learned / Notes
Once completed, reflect briefly on what worked or didn’t.

> _Example:_  
> - Learned that FixedUpdate is better for physics sync.  
> - Need to optimize ball collision layers next sprint.



---

## 🧾 Status Log (Optional)
Track the evolution of the task as it moves between Kanban columns.

| Date       | Status  | Notes                                     |
| ---------- | ------- | ----------------------------------------- |
| 2026-08-19 | Backlog | Added as first task to start Match Engine |
| 2026-08-19 | To Do   | Scheduled for current sprint              |




---
