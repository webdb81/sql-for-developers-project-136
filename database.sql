DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS modules;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS program_modules;
DROP TABLE IF EXISTS module_courses;
DROP TABLE IF EXISTS teaching_groups;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS program_completions;
DROP TABLE IF EXISTS certificates;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS exercises;
DROP TABLE IF EXISTS discussions;
DROP TABLE IF EXISTS blog;

-- Таблица Programs
CREATE TABLE programs (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  program_type VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Modules
CREATE TABLE modules (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at BOOLEAN DEFAULT FALSE
);

-- Таблица Courses
CREATE TABLE courses (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at BOOLEAN DEFAULT FALSE
);

-- Таблица Lessons
CREATE TABLE lessons (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  content TEXT,
  video_url VARCHAR(255),
  position INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  course_id INT REFERENCES courses(id) ON DELETE CASCADE,
  deleted_at BOOLEAN DEFAULT FALSE
);

-- Таблица для связи Programs и Modules (many-to-many)
CREATE TABLE program_modules (
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  module_id INT REFERENCES modules(id) ON DELETE CASCADE,
  PRIMARY KEY (program_id, module_id)
);

-- Таблица для связи Modules и Courses (many-to-many)
CREATE TABLE module_courses (
  module_id INT REFERENCES modules(id) ON DELETE CASCADE,
  course_id INT REFERENCES courses(id) ON DELETE CASCADE,
  PRIMARY KEY (module_id, course_id)
);

-- Таблица TeachingGroups
CREATE TABLE teaching_groups (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  slug VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Users (one-to-one по полю teaching_group_id)
CREATE TABLE users (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  role VARCHAR(50) NOT NULL CHECK (role IN ('student', 'teacher', 'admin')),
  name VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  teaching_group_id INT REFERENCES teaching_groups(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at BOOLEAN DEFAULT FALSE
);

-- Таблица enrollments
CREATE TABLE enrollments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'pending', 'cancelled', 'completed')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица payments
CREATE TABLE payments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  enrollment_id INT REFERENCES enrollments(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'paid', 'failed', 'refunded')),
  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица program_completions
CREATE TABLE program_completions (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'completed', 'pending', 'cancelled')),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица certificates
CREATE TABLE certificates (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  url VARCHAR(255) NOT NULL,
  issued_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица quizzes
CREATE TABLE quizzes (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  content JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица exercises
CREATE TABLE exercises (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица discussions
CREATE TABLE discussions (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  text JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица blogs
CREATE TABLE blogs (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('created', 'in moderation', 'published', 'archived')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
