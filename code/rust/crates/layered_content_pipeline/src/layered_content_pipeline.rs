pub enum StorageTier {
    Base,
    Mod { name: String, priority: u32 },
    Global,
    Save { save_id: String },
}
