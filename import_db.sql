DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  parent INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(parent) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Bob', 'Smith'),
  ('Todd', 'Nestor'),
  ('David', 'Yun');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('What is the meaning of life?', 'Blah blah blah', (SELECT id FROM users WHERE fname = 'Bob' AND lname = 'Smith')),
  ('What is the meaning of App Academy?', 'Blah blah blah', (SELECT id FROM users WHERE fname = 'David' AND lname = 'Yun'));

INSERT INTO
  replies (body, parent, user_id, question_id)
VALUES
  ('It has no meaning!!!', NULL, 2, 1),
  ('It does too!', 1, 3, 1);

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1,1),
  (1,2),
  (1,3);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (2,1),
  (2,2),
  (2,3);
