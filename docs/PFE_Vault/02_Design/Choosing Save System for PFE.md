
# Requirements For Our Save System

The following are the requirements that we need for our save system.

1. Scaleable: Able to handle lots of data
2. Secure: As Secure as possible, as users should be able to save data
3. Serverless: As a single player first game there everything should be saved on user's device
4. Performant: Able to handle fast writing and reading
5. Reliable: Most not corrupt data or can easily be backed up
# What are the options to save info in Godot?

In Godot, there are a lot of different ways to save information about the game. Since each "save" of football will need to save the state of the footballing world, we will need a way to save everything for each individual world of football. Godot has various ways to implement save files for games. The main three are to use FileAccess, Configfile, and Resources.

## File Access:

This file is mainly used by saving and loading variables from either a plain text file or a binary file. This system is natively supported by Godot. This system, while easy to quickly implement and iterate, can become complex very quickly and does not allow easy editable files nor exportable to other systems outside of Godot

- **Pros:**
    - **Handles Most Godot Types:** Can serialize and deserialize a wide range of Godot data types automatically, including built-in types like `Vector2`, `Vector3`, `Dictionary`, and `Array`.
    - **Simpler for Structured Data:** Much easier to save complex data structures like dictionaries and arrays compared to manual text or binary writing.
    - **Built-in Serialization:** Leverages Godot's internal, robust serialization mechanism.
- **Cons:**
    - **Not Human-Readable:** The output is in Godot's internal binary format.
    - **Can Have Versioning Challenges:** Changes to complex data structures might still require careful handling when loading older saves.

## ConfigFile:

The `ConfigFile` class is designed for storing configuration-like data in an INI-style format. It's suitable for saving settings, preferences, or simple game state data that can be represented as key-value pairs within sections.

**Pros:** 
	- **Easy for Key-Value Pairs:** Excellent for saving simple settings, preferences, or straightforward game state data that fits a section/key/value structure.  
	- **Human-Readable (INI-style):** The output format is easy for humans to read and edit, making it suitable for user-configurable settings files. 
	- **Convenient API:** Provides simple methods for setting and getting values by section and key, with built-in support for default values. 
	- **Supports Basic Godot Types:** Can handle common types like strings, numbers, and booleans, and even some Godot-specific types like `Vector2`.

- **Cons:**
    - **Less Suitable for Complex Game State:** Not ideal for saving intricate game states with deeply nested data or complex object relationships.
    - **Limited Data Type Handling (compared to `store_var`):** While it handles basic types well, it's not as comprehensive as `store_var()` for all possible Godot variants.
    - **Doesn't Preserve Comments on Save:** While you can include comments in a manually created config file, they will be lost if you save the `ConfigFile` object back to the file.

## Resources:

Godot's Resource system is a powerful way to manage data assets. You can define custom resources (scripts that extend `Resource`) to hold your game state data. These resources can then be saved and loaded directly using `ResourceSaver.save()` and `ResourceLoader.load()`.

-**Pros:** 
	- **Godot-Idiomatic:** Integrates well with Godot's existing asset and data management workflow. 
	- **Handles Complex Data Structures:** Can serialize and deserialize custom resources, which can contain other resources, allowing you to model and save complex game states effectively.
	- **Supports Text and Binary Formats:** Can save resources as human-readable `.tres` (text) files or more compact `.res` (binary) files.
	- **Can Include Functionality:** Resources can have scripts attached, potentially allowing save data to contain some logic (though this is also a security consideration).

- **Cons:**
    - **Potential Security Risk:** Loading resources directly from user-provided files (like save files) can be a security vulnerability if the resource contains malicious scripts, as these scripts can be executed upon loading. This is a significant concern, especially for games with online features or where users might share save files.
    - **Requires Custom Resource Scripts:** You need to define custom scripts that extend `Resource` to hold your save data.
    - **May Require Duplication:** Loaded resources might share references, requiring manual duplication of collections (like Arrays or Dictionaries) if you intend to modify them without affecting the loaded resource.
    - **Not Ideal for All Data:** Primarily designed for data assets and can be less intuitive for saving transient game state that doesn't map cleanly to a Resource structure.


# Options Outside Godot

There are a various other systems that can work well with Godot to save information. These are text-based or structured text formats that are widely used for data interchange. You would typically collect your game data into a structure (like a Dictionary or Array in Godot), serialize it into one of these formats using a library, and save it using Godot's `FileAccess`. Loading involves reading the file and parsing the data back into your game's data structures.

The following are the pros and cons for various different file formats
- **JSON (JavaScript Object Notation)**
    
    - **Pros:**
        - **Human-Readable:** Relatively easy to read and understand.
        - **Widely Supported:** Excellent support across almost all programming languages and platforms, making it good for interoperability (e.g., web services). Godot has built-in JSON parsing.
        - **Relatively Compact (compared to XML):** Less verbose than XML.
        - **Flexible:** Handles nested data structures (objects/dictionaries and arrays) well.
    - **Cons:**
        - **Less Compact than Binary:** Larger file sizes compared to binary formats.
        - **Limited Data Types:** Doesn't strictly differentiate between integers and floats, and has limited built-in support for complex types like dates or binary data (though these can be represented).
        - **No Built-in Schema Enforcement:** While schemas exist for JSON, the format itself doesn't enforce them by default, which can make validation necessary.
- **XML (Extensible Markup Language)**
    
    - **Pros:**
        - **Highly Structured:** Very robust for complex, hierarchical data.
        - **Extensible:** Allows for defining custom tags and structures.
        - **Widespread Use (Historically):** Still used in many enterprise systems and document formats. Has strong support for schemas (XSD) for validation.
    - **Cons:**
        - **Very Verbose:** Results in larger file sizes compared to JSON or binary formats due to repeating tags.
        - **Less Human-Readable than JSON:** Can be visually noisy due to extensive tagging.
        - **More Complex to Parse:** Generally requires more complex parsing logic compared to JSON.
- **YAML (YAML Ain't Markup Language)**
    
    - **Pros:**
        - **Very Human-Readable:** Designed for easy human reading and writing, often used for configuration files.
        - **Supports Complex Structures:** Can represent complex data structures like nested lists and dictionaries.
        - **Less Verbose than XML:** More concise than XML.
    - **Cons:**
        - **Requires External Parser in Godot:** Godot does not have built-in support for parsing YAML, so you would need a third-party library or implement a parser yourself.
        - **Whitespace Sensitive:** Formatting (indentation) is significant, which can sometimes be a source of errors.
        - **Can Be Ambiguous:** Its flexibility and human-centric design can sometimes lead to parsing ambiguities.
- **CSV (Comma-Separated Values) / TSV (Tab-Separated Values)**
    
    - **Pros:**
        - **Extremely Simple:** Very easy to read and write, often usable directly in spreadsheet software.
        - **Lightweight:** Minimal overhead.
    - **Cons:**
        - **Limited Structure:** Primarily for simple tabular data. Difficult to represent complex or nested relationships.
        - **Manual Type Handling:** All data is essentially stored as strings, requiring manual conversion to appropriate types when loading.
        - **Issues with Special Characters:** Commas, tabs, or newlines within the data itself can cause parsing problems unless properly handled (e.g., quoting).

# Chosen System For Save System

The system that PFE will use is SQLite. This system is a database system that like other SQL systems like PostgreSQL or MySQL, allows for efficient storing or information, enforcing schemas, and fast queries. However, unlike most other SQL flavors, SQLite saves information on the user's local device. For this reason, SQLite is VERY commonly used in everything from browsers, mobile applications, embedded systems, and even other video games. Below are the big pros and cons of 

SQLite

- **Pros:**
	- **Structured and Relational:** Provides a powerful way to organize and query complex data with relationships.
	- **Serverless and Self-Contained:** The database is stored in a single file and doesn't require a separate server process, making it suitable for local game saves.
	- **Robust and Mature:** A widely used and well-tested database engine.
	- **Supports Transactions:** Ensures data integrity during save operations.
- **Cons:**
	- **Requires Integration:** Godot does not have built-in SQLite support, so you would need a third-party add-on or implement the integration yourself (likely via a GDExtension).
	- **Overhead for Simple Data:** Can be overkill and add unnecessary complexity for saving only a small amount of simple data.
	- **Performance Considerations:** While fast for querying, the overhead of interacting with the database engine might be slower than direct file serialization for simple read/write operations.
	- **Not Human-Readable:** The database file is not easily human-readable or editable outside of dedicated database tools.

SQLite meets our requirements perfectly, and a lot of the downsides are not applicable here. There is thankfully a popular GDExtension that integrates SQLite with Godot. While the files themselves may not be human readable, the save files can be easily opened with any SQLite or SQL database openers. This allows for quick development testing and bug fixing. 

SQLite will NOT be the only save system for the entire video games. For example, JSON may be used for simple things such as user settings, metadata, and other simple things. But SQLite will be used to store all the data about the footballing world in each save such as Player details, Team details, country information, and even economy data. Everything from trophy history to transfer information will be stored in this SQL database. 

SQLite will also serve as the query system as we can use it to query all our data very quickly. Previous, Resources was attempted to be used but it meant implementing a lot of the query functions and saving everything into one large file. With SQLite, we only need to design the database and its table and then the query system is already implemented for us. This means SQLite works as both a storage system but also query system. 

SQLite can also be extended to another SQL server system such as MySQL when multiplayer is eventually added. Not to mention, even without multiplayer, this system can be more easily extended to include new features or data we need to save. 

Designing the database correctly is very important and documentation of the entire system is important for testing, debugging, and future extensions.

