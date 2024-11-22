-- Видалення таблиць із каскадним видаленням залежностей
DROP TABLE IF EXISTS feedback CASCADE;
DROP TABLE IF EXISTS creative_work CASCADE;
DROP TABLE IF EXISTS other_user CASCADE;
DROP TABLE IF EXISTS lighting_parameters CASCADE;
DROP TABLE IF EXISTS lighting CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS workspace CASCADE;

-- Створення таблиці workspace
CREATE TABLE workspace (
    workspace_id SERIAL PRIMARY KEY,
    location VARCHAR(255) NOT NULL
);

-- Створення таблиці lighting
CREATE TABLE lighting (
    lighting_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    power INTEGER CHECK (power > 0),
    workspace_id INTEGER NOT NULL
    REFERENCES workspace (workspace_id) ON DELETE CASCADE
);

-- Створення таблиці lighting_parameters
CREATE TABLE lighting_parameters (
    lighting_parameters_id SERIAL PRIMARY KEY,
    brightness INTEGER CHECK (brightness BETWEEN 0 AND 100),
    color VARCHAR(50) NOT NULL,
    lighting_id INTEGER NOT NULL
    REFERENCES lighting (lighting_id) ON DELETE CASCADE,
    CONSTRAINT color_format
    CHECK (color ~* '^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$')
);

-- Створення таблиці user
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    workspace_id INTEGER REFERENCES workspace (workspace_id) ON DELETE SET NULL,
    CONSTRAINT email_format
    CHECK (email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
);

-- Створення таблиці creative_work
CREATE TABLE creative_work (
    creative_work_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    creation_date DATE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES "user" (user_id) ON DELETE CASCADE
);

-- Створення таблиці other_user
CREATE TABLE other_user (
    other_user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- Створення таблиці feedback
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    text VARCHAR(1000) NOT NULL,
    date DATE NOT NULL,
    creative_work_id INTEGER NOT NULL
    REFERENCES creative_work (creative_work_id) ON DELETE CASCADE,
    other_user_id INTEGER NOT NULL
    REFERENCES other_user (other_user_id) ON DELETE CASCADE
);
