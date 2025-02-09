-- Таблица Programs
CREATE TABLE programs (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  cost DECIMAL(10, 2) NOT NULL,
  type VARCHAR(100) NOT NULL,
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
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Таблица Courses
CREATE TABLE courses (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Таблица Lessons
CREATE TABLE lessons (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  content TEXT,
  video_link VARCHAR(255),
  position INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  course_id INT REFERENCES courses(id) ON DELETE CASCADE,
  is_deleted BOOLEAN DEFAULT FALSE
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
  username VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  teaching_group_id INT REFERENCES teaching_groups(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица enrollments
CREATE TABLE enrollments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  enrollment_status VARCHAR(50) NOT NULL CHECK (enrollment_status IN ('active', 'pending', 'cancelled', 'completed')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица payments
CREATE TABLE payments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  enrollment_id INT REFERENCES enrollments(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  payment_status VARCHAR(50) NOT NULL CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
  payment_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица program_completions
CREATE TABLE program_completions (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  program_status VARCHAR(50) NOT NULL CHECK (program_status IN ('active', 'completed', 'pending', 'cancelled')),
  program_start_date TIMESTAMP,
  program_end_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица certificates
CREATE TABLE certificates (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  certificate_url VARCHAR(255) NOT NULL,
  certificate_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица quizzes
CREATE TABLE quizzes (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  quiz_name VARCHAR(255) NOT NULL,
  quiz_content JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица exercises
CREATE TABLE exercises (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  exercise_name VARCHAR(255) NOT NULL,
  exercise_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
