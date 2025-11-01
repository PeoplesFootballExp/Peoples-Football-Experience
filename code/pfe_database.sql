CREATE TABLE IF NOT EXISTS "Confederation" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL UNIQUE,
	"official_name" TEXT NOT NULL,
	"logo_path" TEXT,
	"parent_id" INTEGER,
	"code" TEXT NOT NULL UNIQUE,
	"level" INTEGER DEFAULT 1,
	PRIMARY KEY("id"),
	FOREIGN KEY ("parent_id") REFERENCES "Confederation"("id")
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Territory" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL UNIQUE,
	"logo_path" TEXT,
	"parent_id" INTEGER,
	"confed_id" INTEGER NOT NULL,
	"official_name" TEXT NOT NULL UNIQUE,
	"alt_name" TEXT,
	"code" TEXT NOT NULL UNIQUE CHECK(length(code) <= 4),
	"demonym" TEXT NOT NULL,
	"is_gfu_member" INTEGER NOT NULL,
	"league_elo" REAL,
	"global_elo" REAL,
	"national_elo" REAL NOT NULL,
	"population" INTEGER NOT NULL,
	"area_km" INTEGER NOT NULL,
	"gdp_dollar" INTEGER NOT NULL,
	"language" INTEGER NOT NULL,
	"climate_type" INTEGER NOT NULL,
	"hemisphere" INTEGER NOT NULL,
	"enthusiasm" INTEGER NOT NULL CHECK(enthusiasm <= 5),
	PRIMARY KEY("id"),
	FOREIGN KEY ("parent_id") REFERENCES "Territory"("id")
	ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY ("confed_id") REFERENCES "Confederation"("id")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("climate_type") REFERENCES "Climate"("id")
	ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY ("hemisphere") REFERENCES "Hemisphere"("id")
	ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "City" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"parent_id" INTEGER,
	"territory_id" INTEGER NOT NULL,
	"latitude" REAL NOT NULL,
	"longitude" REAL NOT NULL,
	"population" INTEGER NOT NULL,
	"is_capital" INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY ("territory_id") REFERENCES "Territory"("id")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("parent_id") REFERENCES "City"("id")
	ON UPDATE CASCADE ON DELETE CASCADE
);

/* CHECK (
        (territory_id IS NOT NULL AND confed_id IS NULL)
        OR
        (territory_id IS NULL AND confed_id IS NOT NULL)
    ) */
CREATE TABLE IF NOT EXISTS "Tournament" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"logo_path" TEXT,
	"territory_id" INTEGER,
	"confed_id" INTEGER,
	"code" TEXT NOT NULL UNIQUE,
	"gender" INTEGER NOT NULL,
	"type" TEXT NOT NULL CHECK(type IN ('League', 'Cup', 'Qualifier', 'Friendly', 'Other')),
	PRIMARY KEY("id"),
	FOREIGN KEY ("territory_id") REFERENCES "Territory"("id")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("confed_id") REFERENCES "Confederation"("id")
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Team" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"logo_path" TEXT,
	"official_name" TEXT NOT NULL UNIQUE,
	"alt_name" TEXT,
	"parent_id" INTEGER,
	"territory_id" INTEGER NOT NULL,
	"city_id" INTEGER NOT NULL,
	"code" TEXT NOT NULL UNIQUE CHECK(length(code) <= 4),
	"gender" INTEGER NOT NULL DEFAULT 0,
	"is_national" INTEGER NOT NULL,
	"youth_development" INTEGER NOT NULL,
	"financial_stability" INTEGER NOT NULL,
	"reputation_branding" INTEGER NOT NULL,
	"facility_maintenance" INTEGER NOT NULL,
	"domestic_success" INTEGER,
	"international_success" INTEGER,
	"continental_success" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("parent_id") REFERENCES "Team"("id")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("territory_id") REFERENCES "Territory"("id")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("city_id") REFERENCES "City"("id")
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Climate" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL UNIQUE,
	"summer_rain_chance" INTEGER NOT NULL,
	"summer_snow_chance" INTEGER NOT NULL,
	"summer_fog_chance" INTEGER NOT NULL,
	"summer_cloudy_chance" INTEGER NOT NULL,
	"summer_sunny_chance" INTEGER NOT NULL,
	"winter_rain_chance" INTEGER NOT NULL,
	"winter_snow_chance" INTEGER NOT NULL,
	"winter_fog_chance" INTEGER NOT NULL,
	"winter_cloudy_chance" INTEGER NOT NULL,
	"winter_sunny_chance" INTEGER,
	PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "Hemisphere" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL UNIQUE,
	"summer_start_month" INTEGER NOT NULL,
	"summer_start_day" INTEGER NOT NULL,
	"summer_end_month" INTEGER NOT NULL,
	"summer_end_day" INTEGER NOT NULL,
	"winter_start_month" INTEGER NOT NULL,
	"winter_start_day" INTEGER NOT NULL,
	"winter_end_month" INTEGER NOT NULL,
	"winter_end_day" INTEGER NOT NULL,
	PRIMARY KEY("id")
);