
**Date:** 2025-11-6 
**Author(s):** Eddie  
**Version:**  v0.1 MVP
**Tags**: #dev-blog

---

## 🏟️ Overview
*A short paragraph summarizing the blog post.* 

Back home from vacation, can continue working on project. Have mostly spent the past days working on data collection and setting up the collection of data automatically in the future. I have gathered two sources of data that are free and open for the public to use. This should work well for gathering data for the teams and ensuring they stay up to date. 



---

## ⚽ Features / Updates
*List the new features, updates, or fixes. Include visuals if possible.*

- Decided on using SQLite for project, all data will be stored this way. 
- Worked on creating schema for database, using DrawDB, a free and open source browser tool for creating visual graphs for SQL databases
- Installed LibreOffice, Affinity, and DB Browser. More tools for creating
- Gathered and correctly named all territories flags. Storing them inside of the repo under the assets/textures folders
- Expanded to include new territories, including some smaller island territories like Saba and Easter Island
- Gathered all data I wanted for now on territories such as population, area, gdp, climate, and football ethusiasm.
- Moved on to the creation of the team selection scene before loading into the game
- Created good logical flow for team selection, going from Confederation -> Territory -> Gender Selection -> League Selection -> Team Selection
- Created a first prototype, but scraped it for different idea as collapseable item lists seemed to not work out well in Godot
- Gathered Confederation images, using real life examples as simple place holders for now
- Decided on using Wikidata for a queryable database to gather information about football teams (works across languages)
- Started working on queries to use for future, to ensure team data, country data, and confederation data stays correct.
- Found out about SportDB, and open and free data base that contains images, files, and data about teams across the soccer world. Also includes a Free API that can be used for projects. 
- Wrote python scripts to automatically gather data from Wikidata, soon for SportDB as well
- Finalized data I collected for Territories and Confederations into a SQLite database, going to be used to ensure the Team Selection screen works


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

- Collect some team data (only top five leagues in Europe) to input into SQLite database and test it works alongside the Team Selection screen
- Work on fully automating team, country, and confederation data collection, to make future data updates a lot easier
- Contribute to SportsDB and Wikidata, so latest data is as accurate as possible
- Completely finish Team Selection screen



---
## 📝 Links / References
- GitHub Issue / PR Links  
- Relevant Documentation  
- Reference Images / Inspiration  



*Thank you for following the development of People’s Football Experience! Stay tuned for the next update.*
