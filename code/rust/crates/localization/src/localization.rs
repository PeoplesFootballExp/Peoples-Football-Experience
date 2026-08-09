use std::collections::HashMap;
use std::{default, fs};

use fluent::{FluentArgs, FluentBundle, FluentResource, FluentValue};

// Used to provide a locale for the bundle.
use unic_langid::LanguageIdentifier;
use unic_langid::subtags::{Language, Region, Script}, Region, Script};

pub struct LocalizationService {
    bundles: HashMap<LanguageIdentifier, FluentBundle<FluentResource>>,
    pub current_locale: LanguageIdentifier,
}

impl LocalizationService {
    pub fn new(default_locale: LanguageIdentifier, locales_dir: impl AsRef<Path>) -> Self {
        let mut service = Self {
            bundles: HashMap::new(),
            current_locale: default_locale,
        };

        service.load_resources();
        service
    }

    pub fn load_all_locales(&mut self, locales_dir: impl AsRef<Path>) {
        let locales_path = locales_dir.as_ref();
    }
}
