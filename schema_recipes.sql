-- Esquema de base de datos para recetas enriquecidas
-- Todas las tablas y relaciones principales

CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    summary TEXT,
    is_vegetarian BOOLEAN,
    meal_type TEXT,
    difficulty TEXT,
    is_allergenic BOOLEAN,
    digestion_time_minutes INTEGER,
    environmental_impact TEXT,
    glycemic_index INTEGER,
    satiety_level TEXT,
    processing_level INTEGER,
    is_valid_recipe BOOLEAN,
    error_message TEXT,
    cache_time BIGINT,
    time BIGINT
);

CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    amount TEXT
);

CREATE TABLE alternatives (
    id SERIAL PRIMARY KEY,
    ingredient_id INTEGER REFERENCES ingredients (id) ON DELETE CASCADE,
    original TEXT
);

CREATE TABLE alternative_items (
    id SERIAL PRIMARY KEY,
    alternative_id INTEGER REFERENCES alternatives (id) ON DELETE CASCADE,
    name TEXT
);

CREATE TABLE allergens (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    name TEXT
);

CREATE TABLE diets (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    name TEXT
);

CREATE TABLE instructions (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    step INTEGER,
    text TEXT
);

CREATE TABLE plating_instructions (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    step INTEGER,
    text TEXT
);

CREATE TABLE nutrition_info (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    calories INTEGER,
    protein INTEGER,
    carbs INTEGER,
    fat INTEGER
);

CREATE TABLE macros (
    id SERIAL PRIMARY KEY,
    nutrition_info_id INTEGER REFERENCES nutrition_info (id) ON DELETE CASCADE,
    type TEXT,
    value INTEGER
);

CREATE TABLE recommended_servings (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    adult INTEGER,
    child INTEGER,
    athlete INTEGER,
    senior INTEGER
);

CREATE TABLE medical_restrictions (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    name TEXT
);

CREATE TABLE health_warnings (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    text TEXT
);

CREATE TABLE extra_info (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    cooking_method TEXT,
    ideal_season TEXT,
    origin_country TEXT,
    spicy_level TEXT
);

CREATE TABLE similar_dishes (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    name TEXT
);

CREATE TABLE recommended_pairings (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes (id) ON DELETE CASCADE,
    drinks TEXT,
    sides TEXT,
    desserts TEXT
);

-- Función para crear una receta y retornar el id generado
CREATE OR REPLACE FUNCTION create_recipe(
    p_title TEXT,
    p_summary TEXT,
    p_is_vegetarian BOOLEAN,
    p_meal_type TEXT,
    p_difficulty TEXT,
    p_is_allergenic BOOLEAN,
    p_digestion_time_minutes INTEGER,
    p_environmental_impact TEXT,
    p_glycemic_index INTEGER,
    p_satiety_level TEXT,
    p_processing_level INTEGER,
    p_is_valid_recipe BOOLEAN,
    p_error_message TEXT,
    p_cache_time BIGINT,
    p_time BIGINT
) RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    INSERT INTO recipes (
        title, summary, is_vegetarian, meal_type, difficulty, is_allergenic,
        digestion_time_minutes, environmental_impact, glycemic_index, satiety_level,
        processing_level, is_valid_recipe, error_message, cache_time, time
    ) VALUES (
        p_title, p_summary, p_is_vegetarian, p_meal_type, p_difficulty, p_is_allergenic,
        p_digestion_time_minutes, p_environmental_impact, p_glycemic_index, p_satiety_level,
        p_processing_level, p_is_valid_recipe, p_error_message, p_cache_time, p_time
    ) RETURNING id INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Función para insertar una receta completa desde un JSONB
CREATE OR REPLACE FUNCTION insert_full_recipe(recipe_json jsonb) RETURNS INTEGER AS $$
DECLARE
    new_recipe_id INTEGER;
    nutrition_id INTEGER;
    macros_data jsonb;
    macro_key TEXT;
    macro_value TEXT;
    servings_data jsonb;
    pairings_data jsonb;
    i INT;
    ingr jsonb;
    alt jsonb;
    alt_item jsonb;
    instr jsonb;
    plate_instr jsonb;
    warn jsonb;
    med jsonb;
    sim jsonb;
    diet jsonb;
    allergen jsonb;
BEGIN
    -- Insertar en recipes
    INSERT INTO recipes (
        title, summary, is_vegetarian, meal_type, difficulty, is_allergenic,
        digestion_time_minutes, environmental_impact, glycemic_index, satiety_level,
        processing_level, is_valid_recipe, error_message, cache_time, time
    ) VALUES (
        recipe_json->'result'->>'title',
        recipe_json->'result'->>'summary',
        (recipe_json->'result'->>'isVegetarian')::boolean,
        recipe_json->'result'->>'mealType',
        recipe_json->'result'->>'difficulty',
        (recipe_json->'result'->>'isAllergenic')::boolean,
        (recipe_json->'result'->>'digestion_time_minutes')::integer,
        recipe_json->'result'->>'environmental_impact',
        (recipe_json->'result'->>'glycemic_index')::integer,
        recipe_json->'result'->>'satiety_level',
        (recipe_json->'result'->>'processing_level')::integer,
        (recipe_json->>'isValidRecipe')::boolean,
        recipe_json->>'errorMessage',
        (recipe_json->>'cacheTime')::bigint,
        (recipe_json->>'time')::bigint
    ) RETURNING id INTO new_recipe_id;

    -- Ingredientes
    FOR i IN 0 .. jsonb_array_length(recipe_json->'result'->'ingredients') - 1 LOOP
        ingr := recipe_json->'result'->'ingredients'->i;
        INSERT INTO ingredients (recipe_id, name, amount)
        VALUES (new_recipe_id, ingr->>'name', ingr->>'amount');
    END LOOP;

    -- Alternativas de ingredientes
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'AlternativasIngredientes'),0) - 1 LOOP
        alt := recipe_json->'result'->'AlternativasIngredientes'->i;
        INSERT INTO alternatives (ingredient_id, original)
        VALUES (
            (SELECT id FROM ingredients WHERE recipe_id = new_recipe_id AND name = alt->>'original' LIMIT 1),
            alt->>'original'
        ) RETURNING id INTO nutrition_id;
        -- Alternativas
        FOR alt_item IN SELECT * FROM jsonb_array_elements(alt->'alternativas') LOOP
            INSERT INTO alternative_items (alternative_id, name)
            VALUES (nutrition_id, alt_item->>'name');
        END LOOP;
    END LOOP;

    -- Instrucciones
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'instructions'),0) - 1 LOOP
        instr := recipe_json->'result'->'instructions'->i;
        INSERT INTO instructions (recipe_id, step, text)
        VALUES (new_recipe_id, (instr->>'step')::integer, instr->>'text');
    END LOOP;

    -- Plating instructions
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'plating_instructions'),0) - 1 LOOP
        plate_instr := recipe_json->'result'->'plating_instructions'->i;
        INSERT INTO plating_instructions (recipe_id, step, text)
        VALUES (new_recipe_id, (plate_instr->>'step')::integer, COALESCE(plate_instr->>'text', plate_instr->>'description'));
    END LOOP;

    -- Nutrition info
    IF recipe_json->'result' ? 'nutrition_info' THEN
        INSERT INTO nutrition_info (recipe_id, calories, protein, carbs, fat)
        VALUES (
            new_recipe_id,
            (recipe_json->'result'->'nutrition_info'->>'calories')::integer,
            (recipe_json->'result'->'nutrition_info'->>'protein')::integer,
            (recipe_json->'result'->'nutrition_info'->>'carbs')::integer,
            (recipe_json->'result'->'nutrition_info'->>'fats')::integer
        ) RETURNING id INTO nutrition_id;
        -- Macros
        IF recipe_json->'result' ? 'macros' THEN
            macros_data := recipe_json->'result'->'macros';
            FOR macro_key, macro_value IN SELECT * FROM jsonb_each_text(macros_data) LOOP
                INSERT INTO macros (nutrition_info_id, type, value)
                VALUES (nutrition_id, macro_key, macro_value::integer);
            END LOOP;
        END IF;
    END IF;

    -- Recommended servings
    IF recipe_json->'result' ? 'recommended_servings' THEN
        servings_data := recipe_json->'result'->'recommended_servings';
        INSERT INTO recommended_servings (recipe_id, adult, child, athlete, senior)
        VALUES (
            new_recipe_id,
            NULLIF(servings_data->>'adult','')::integer,
            NULLIF(servings_data->>'child','')::integer,
            NULLIF(servings_data->>'athlete','')::integer,
            NULLIF(servings_data->>'senior','')::integer
        );
    END IF;

    -- Medical restrictions
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'medical_restrictions'),0) - 1 LOOP
        med := recipe_json->'result'->'medical_restrictions'->i;
        INSERT INTO medical_restrictions (recipe_id, name)
        VALUES (new_recipe_id, med->>'name');
    END LOOP;

    -- Health warnings
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'health_warnings'),0) - 1 LOOP
        warn := recipe_json->'result'->'health_warnings'->i;
        INSERT INTO health_warnings (recipe_id, text)
        VALUES (new_recipe_id, warn->>'text');
    END LOOP;

    -- Extra info
    IF recipe_json->'result' ? 'extra_info' THEN
        INSERT INTO extra_info (recipe_id, cooking_method, ideal_season, origin_country, spicy_level)
        VALUES (
            new_recipe_id,
            recipe_json->'result'->'extra_info'->>'cooking_method',
            recipe_json->'result'->'extra_info'->>'ideal_season',
            recipe_json->'result'->'extra_info'->>'origin_country',
            recipe_json->'result'->'extra_info'->>'spicy_level'
        );
    END IF;

    -- Similar dishes
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'similar_dishes'),0) - 1 LOOP
        sim := recipe_json->'result'->'similar_dishes'->i;
        INSERT INTO similar_dishes (recipe_id, name)
        VALUES (new_recipe_id, sim->>'name');
    END LOOP;

    -- Recommended pairings
    IF recipe_json->'result' ? 'recommended_pairings' THEN
        pairings_data := recipe_json->'result'->'recommended_pairings';
        INSERT INTO recommended_pairings (recipe_id, drinks, sides, desserts)
        VALUES (
            new_recipe_id,
            (SELECT string_agg(x->>'name', ', ') FROM jsonb_array_elements(pairings_data->'drinks') x),
            (SELECT string_agg(x->>'name', ', ') FROM jsonb_array_elements(pairings_data->'sides') x),
            (SELECT string_agg(x->>'name', ', ') FROM jsonb_array_elements(pairings_data->'desserts') x)
        );
    END IF;

    -- Diets
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'diets'),0) - 1 LOOP
        diet := recipe_json->'result'->'diets'->i;
        INSERT INTO diets (recipe_id, name)
        VALUES (new_recipe_id, diet->>'name');
    END LOOP;

    -- Allergens
    FOR i IN 0 .. COALESCE(jsonb_array_length(recipe_json->'result'->'allergens'),0) - 1 LOOP
        allergen := recipe_json->'result'->'allergens'->i;
        INSERT INTO allergens (recipe_id, name)
        VALUES (new_recipe_id, allergen->>'name');
    END LOOP;

    RETURN new_recipe_id;
END;
$$ LANGUAGE plpgsql;