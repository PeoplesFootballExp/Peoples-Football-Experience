
**Status:** `Backlog | To Do | In Progress | Review | Done 
**Type:** #gameplay | #ai | #ui | #assets | #tech | #testing | #docs
**Priority:** #critical | #moderate | #polish | #optional`  
**Effort:** #short`(≤1 day)` | #medium`(2–6 days)` | #long `(1–2 weeks+)`  
**Created:** {{Date}}  
**Last Updated:** {{Date}}  
**Owner:** {{Your Name or Team Member}}  
**Related GitHub Issue (if any):** 


---

## 🧠 Overview
Briefly describe the **goal** of this task and what it adds to the game.

> _Example:_  
> Implement player movement and ball control using Unity physics.  
> Core gameplay feature for the MVP phase.

Type Here...

---

## 🔍 Background / Rationale
Explain **why this task exists** and what problem or opportunity it addresses.  
This helps remind you (or future collaborators) of the reasoning behind it.

> _Example:_  
> The player movement system is the foundation for all in-game actions. It needs to feel responsive, intuitive, and work across controllers and keyboards.

Type Here...

---

## 🧩 Scope Breakdown
List out the **specific elements** or deliverables that define this task.

| Category | Description |
|-----------|--------------|
| **Feature** | Ball movement and collision logic |
| **UI** | Stamina bar display |
| **Audio** | Kick sound effects |
| **Art/Animation** | Player running and turning animations |

> 💡 Keep it focused — if this table gets too long, consider splitting the task into smaller ones.

---

## 🧰 Implementation Steps
Concrete, actionable steps for completing the task.  
Mark them off as you go.

- [ ] Step 1: {{First action — e.g., create new Unity scene or prefab}}
- [ ] Step 2: {{Add required scripts, logic, or art assets}}
- [ ] Step 3: {{Integrate with existing systems (e.g., physics, AI)}}
- [ ] Step 4: {{Run internal test and debug issues}}
- [ ] Step 5: {{Document implementation in Dev Wiki}}

> ⏳ **Tip:** Use `Ctrl + Enter` to check off tasks as you progress.

---

## 🔗 Dependencies
List what this task depends on or what depends on it.

| Type | Task/Link | Status |
|------|------------|--------|
| **Requires** | [[Task - Input System]] | ✅ Done |
| **Requires** | [[Task - Animation Controller]] | ⏳ Pending |
| **Blocks** | [[Task - Stamina System]] | ❌ Not Started |

> 💡 Keeps you from starting tasks that rely on unfinished work.

---

## 🧪 Testing & QA Checklist
Ensure this task is **verified and functional** before moving to “Review.”

- [ ] Confirm expected behavior in play mode  
- [ ] Check performance and FPS impact  
- [ ] Validate on multiple screen sizes/resolutions  
- [ ] Verify interactions with other systems  
- [ ] Gather playtest feedback  
- [ ] Update documentation with final behavior

> ✅ Move task to **Review** once all checks pass.

---

## 👀 Review Notes
Use this section during peer/self-review or testing.

| Reviewer | Date | Notes |
|-----------|------|-------|
| {{Name}} | {{Date}} | {{Observation or feedback}} |
| {{Name}} | {{Date}} | {{Observation or feedback}} |

> 💬 Optional, but extremely useful for tracking changes over time.

---

## 🏁 Completion Criteria
Define what “**Done**” means clearly, so you know when to stop tweaking.

> _Example:_  
> - Player can move in all directions with realistic momentum.  
> - Ball dribbling feels smooth and consistent.  
> - No visible jitter or clipping.  
> - Code is committed and reviewed.  
> - Task marked as `#done`.

---

## 🗃️ Documentation & Resources
Link to any design docs, reference materials, or related systems.

- [[System – Match Engine]]
- [[Design – Player Controls]]
- [[Doc – Game Physics Overview]]
- [Unity Physics Docs](https://docs.unity3d.com/Manual/class-Rigidbody.html)

> 💡 Add screenshots, code snippets, or diagrams here if relevant.

---

## 🧠 Lessons Learned / Notes
Once completed, reflect briefly on what worked or didn’t.

> _Example:_  
> - Learned that FixedUpdate is better for physics sync.  
> - Need to optimize ball collision layers next sprint.

---

## 🧾 Status Log (Optional)
Track the evolution of the task as it moves between Kanban columns.

| Date | Status | Notes |
|------|---------|-------|
| {{Date}} | Backlog | Added as idea after AI meeting |
| {{Date}} | To Do | Scheduled for Sprint 02 |
| {{Date}} | In Progress | Working on Rigidbody tuning |
| {{Date}} | Review | Sent for feedback |
| {{Date}} | Done | Approved and merged into build 0.3.2 |

> 💡 You’ll love this when reviewing progress or writing devlogs.

---
