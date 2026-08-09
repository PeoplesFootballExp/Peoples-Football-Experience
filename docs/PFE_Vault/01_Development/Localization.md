
While the documentation, and most of the code, of People's Football Experience is in English by default, we need to ensure we have a good way of localizing the game for various languages. While over a billion people around the world speak English to varying degrees, there are still billions who don't speak English at all. For this reason, and to meet the goal of having PFE be accessible to everyone, I hope to localize the game to as many languages as possible. 

Localization will depend on volunteers from around the world to help localize the game. The game will release being fully localized in **English** and **Spanish**. 

# Godot Localization

Godot already has a built in system for localizing text which relies on CSV files.  Each column inside the CSV file has the header of the locale ("en", "fr", etc) and all the text in that language below it. In essence, it is a one to one translation system where each row contains the default text and all its translations into various languages. This simple system is designed around easy of access for translating text across the game. 

## Pros

1. Automatic UI Binding
2. Built-In CSV Importer
3. Native Gettext (.po) support
4. Layout and Script Features
## Cons

1. Fragile CSV Merge Conflicts and Git Overhead
2. Limited Complex Grammar & Dynamic Formatting
3. Limited Dialect Fallback Control
4. Built-in POT generation can be clunky

# Project Fluent

This project uses Project Fluent (.ftl) for localizing all human-readable text. To maintain a strict separation between presentation and simulation logic, no user-facing text is stored inside the SQLite database or raw Rust Backend components. This also simplifies editing user-facing text as all of it would be stored inside ftl files, allowing you to edit text in game without directly editing SQLite Database or Rust code, helping to prevent game breaking changes. 

SQLite holds structural data and unique string keys, while ftl files serve as the single source of truth for all human-readable strings, dynamic text templates, and regional dialects.

Project Fluent was created by Mozilla specifically to solve the limitations of legacy localization frameworks (like Gettext .po or static JSON/CSV tables).
- Grammar & Gender Awareness: Handles gendered adjectives, complex plurals, and grammatical cases natively across world languages.
- Dynamic Variable Interpolation: Evaluates conditional rules and variables at runtime without requiring fragile code concatenation
- Blazing Fast in Rust: Implemented via the official *fluent* crate, parsing .ftl files at boot into zero-allocation or microsecond lookup in memory bundles.
- Git & Version Control Friendly: Text files merge cleanly line-by-line during concurrent development, unlike monolithic tables or binary assets

To read more about Project Fluent, please visit the [official website](https://projectfluent.org/)

## Design Pattern: Pure Key-Based Separation

Core Benefits:
1. Non-Destructive Modding: Modders can create .ftl override files to customize club/league names or add translations without altering game logic or risking save-file corruption.
2. Cache & Memory Efficiency: Simulation components stay small and numeric (u32 keys), eliminating string allocation during game-loop iterations and SQL deserialization.

## Directory Structure & Folder Organization

Fluent assets live in the asset/locales/ directory, organized by BCP 47 language tags (e.g., *en-GB*, *en-US*, *fr-FR*) and broken down by functional category.

```
assets/
└── locales/
    ├── en-GB/                  # Base English (Great Britain)
    │   ├── ui.ftl             # Interface buttons, headers, navigation
    │   ├── tactics.ftl        # Positions, roles, tactical instructions
    │   ├── match.ftl          # Match engine commentary & event templates
    │   └── news.ftl           # Media inbox, headlines, contract text
    ├── en-US/                  # Dialect Override (United States)
    │   └── ui.ftl             # Overrides ONLY (e.g., "Field" instead of "Pitch")
    └── fr-FR/                  # Generic French
        ├── ui.ftl
        ├── tactics.ftl
        ├── match.ftl
        └── news.ftl
```

To avoid memory duplication and redundant maintenance across regional dialects (e.g., British vs. American English):
1. **Base Locale**: The primary language file (*en-US*) contains the complete dataset of all strings.
2. **Override Locale**: Regional sub-locales (*en-GB*) contain only the deltas - the specific words or spelling differences that change for that region.
3. **Runtime Fallback Chain**: The engine loads the active locale bundle with a fallback priority. If a key isn't found in *en-GB*, Fluent automatically falls ack to *en-US* with zero runtime memory duplication or missing-key crashes.

## Keys inside FTL files

Since .ftl files rely on key-value pairs, it is very important that key names are consistent and clear to someone what they store. The value portion of the key-value pair is simple, it is simply the text that would be displayed to the user. The keys on the other hand, need some naming convention to ensure the keys remain consistent and clear to developers. A naming convention that I choose is based on the directory structure and folder organization chosen above. Since the files are seperated by locale folders, we can leave out the locale from the key name entirely. We will include the domain of the file in the key. The naming convention is shown below by order of the title.


> [!NOTE] FTL Key Naming Convention
> **Domain** - **Category** - **Entity** . **Attribute**

1. **Domain**: Maps directly to the .ftl file where the key lives. It is composed of big domains of the text such as things like "ui", "name", "entity", etc.
2. **Category**: The functional sub-group or classification of the domains. Can be things like "fname", "btn", "event", etc.
3. **Entity**: The specific object, ISO code, or identifier. Can be things such as "mateo", "eng", "save"
4. **Attribute**: The variant, grammatical form, or formatting rule. Can contain things such as "full", "short", "demonym", etc.

For all of these titles, terms can be abbreviated. Once a term it abbreviated, such as Button gets shorted to Btn, it must remain consistent throughout the ftl files. All keys should also be written in snake case but with dashes. Also, all keys, regardless of language, should be written in English. While the text in the value can be in any language, the key must remain in English following the convention shown above.


