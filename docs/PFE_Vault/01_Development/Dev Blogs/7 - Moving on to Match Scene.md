

**Date:** 2025-11-20  
**Author(s):** Eddie
**Version:** v0.1 MVP
**Tags**: #dev-blog
**Links:** [[Development]]

---

## 🏟️ Overview
*A short paragraph summarizing the blog post.*  

For the most part, the functionality of the [[Team Selection Menu]] is done. The scene itself is not yet pretty, nor is it completely done, but it does allow us to select two teams: User Team and the Opponent Team. We are moving on to the Match Scene for now. I want to get some basic functionality for that too before we move on to save selection scene and Team tactics editing scene. For now, we have designed some basic aspects of the match scene



---

## ⚽ Features / Updates
*List the new features, updates, or fixes. Include visuals if possible.*

- Updated Image Loading system, now assets like images are pulled from the user:// folder instead of the res:// folder. This feature will allow the flexibility of users to upload their own images to replace in game logos, flags, etc. Does slow down image loading a little bit, but not significantly.
- Resized and changed format to WebP image format for all images. All original images were originally PNG, so now in WebP we sped up loading times and almost halved our memory space for images. 
- Finalized logic for Team Selection Scene, ensured it worked with the two previous changes
- Created a match scene, the overarching the entire match of football
- Created a player scene
- Created a football ball scene. Added a quick mesh from Poly Pizza to make it appear like a real football. 
- Input real life physics parameters for the football for the physics engine such as friction, radius, bounce, and even weight. 
- Player scene has a simple capsule mesh and collision shape to test movement soon
- Designed a simple Finite State Machine for the match states, that covers all aspects of a football match from a full 90 minutes match to a match that goes to extra time and penalties
- Created different resource scripts for each state, need to implement more
- Currently working on Input Manager for the player, to get the player to move correctly with controller like inputs.


---

## 🛠️ Technical Details
*Explain what was implemented, languages/tools used, and challenges faced.*



---

## 🎨 Art / Design Updates
*Share updates on player models, stadiums, UI mockups, or animations.*


---

## 📊 Metrics / Progress

---

## 💭 Thoughts / Reflections
*Share lessons learned, future ideas, or design decisions.*


---
## 🔮 Next Steps
*Outline what’s coming next in development.*

- Design Input system
- Get player to move



---
## 📝 Links / References
- GitHub Issue / PR Links  
- Relevant Documentation  
- Reference Images / Inspiration  



*Thank you for following the development of People’s Football Experience! Stay tuned for the next update.*
