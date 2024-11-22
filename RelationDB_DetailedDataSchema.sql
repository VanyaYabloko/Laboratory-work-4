-- Видалення таблиць із каскадним видаленням залежностей
DROP TABLE IF EXISTS Feedback CASCADE;
DROP TABLE IF EXISTS CreativeWork CASCADE;
DROP TABLE IF EXISTS OtherUser CASCADE;
DROP TABLE IF EXISTS LightingParameters CASCADE;
DROP TABLE IF EXISTS Lighting CASCADE;
DROP TABLE IF EXISTS User CASCADE;
DROP TABLE IF EXISTS Workspace CASCADE;

-- Створення таблиці Workspace
CREATE TABLE Workspace (
    workspace_id SERIAL PRIMARY KEY,
    location VARCHAR(255) NOT NULL
);

-- Створення таблиці Lighting
CREATE TABLE Lighting (
    lighting_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    power INTEGER CHECK (power > 0),
    workspace_id INTEGER NOT NULL REFERENCES Workspace(workspace_id) ON DELETE CASCADE
);

-- Створення таблиці LightingParameters
CREATE TABLE LightingParameters (
    lighting_params_id SERIAL PRIMARY KEY,
    brightness INTEGER CHECK (brightness BETWEEN 0 AND 100),
    color VARCHAR(50) NOT NULL,
    lighting_id INTEGER NOT NULL REFERENCES Lighting(lighting_id) ON DELETE CASCADE,
    CONSTRAINT color_format CHECK (color ~* '^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$')
);

-- Створення таблиці User
CREATE TABLE User (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    workspace_id INTEGER REFERENCES Workspace(workspace_id) ON DELETE SET NULL,
    CONSTRAINT email_format CHECK (email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
);

-- Створення таблиці CreativeWork
CREATE TABLE CreativeWork (
    creative_work_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    creation_date DATE NOT NULL,
    user_id INTEGER NOT NULL REFERENCES User(user_id) ON DELETE CASCADE
);

-- Створення таблиці OtherUser
CREATE TABLE OtherUser (
    other_user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- Створення таблиці Feedback
CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    text VARCHAR(1000) NOT NULL,
    date DATE NOT NULL,
    creative_work_id INTEGER NOT NULL REFERENCES CreativeWork(creative_work_id) ON DELETE CASCADE,
    other_user_id INTEGER NOT NULL REFERENCES OtherUser(other_user_id) ON DELETE CASCADE
);
