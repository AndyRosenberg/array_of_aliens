-- +micrate Up
CREATE TABLE images (
  id BIGSERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users,
  profile BOOLEAN DEFAULT FALSE,
  object_key VARCHAR,
  object_url VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS images;
