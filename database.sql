DROP TABLE IF EXISTS
  programs,
  modules,
  courses,
  lessons,
  program_modules,
  course_modules,
  teaching_groups,
  users,
  enrollments,
  payments,
  program_completions,
  certificates,
  quizzes,
  exercises,
  discussions,
  blogs
CASCADE;


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
  deleted_at TIMESTAMP
);

-- Таблица Courses
CREATE TABLE courses (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

-- Таблица Lessons
CREATE TABLE lessons (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  content TEXT,
  video_url VARCHAR(255),
  position INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  course_id INT REFERENCES courses(id) ON DELETE SET NULL,
  deleted_at TIMESTAMP
);

-- Таблица для связи Programs и Modules (many-to-many)
CREATE TABLE program_modules (
  program_id INT REFERENCES programs(id) ON DELETE CASCADE,
  module_id INT REFERENCES modules(id) ON DELETE CASCADE,
  PRIMARY KEY (program_id, module_id)
);

-- Таблица для связи Courses и Modules (many-to-many)
CREATE TABLE course_modules (
  course_id INT REFERENCES courses(id) ON DELETE CASCADE,
  module_id INT REFERENCES modules(id) ON DELETE CASCADE,
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
  role VARCHAR(50) NOT NULL CHECK (role IN ('Student', 'Teacher', 'Admin')),
  name VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255),
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
  amount DECIMAL(10, 2),
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
  url VARCHAR(255),
  issued_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица quizzes
CREATE TABLE quizzes (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  name VARCHAR(255),
  content JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица exercises
CREATE TABLE exercises (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  name VARCHAR(255),
  url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица discussions
CREATE TABLE discussions (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  text JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица blogs
CREATE TABLE blogs (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  content TEXT,
  status VARCHAR(50) NOT NULL CHECK (status IN ('created', 'in moderation', 'published', 'archived')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
