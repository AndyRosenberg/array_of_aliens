-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  name VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR UNIQUE NOT NULL,
  gender VARCHAR,
  preference VARCHAR,
  neurostatus VARCHAR DEFAULT 'Undisclosed',
  description VARCHAR,
  city VARCHAR,
  state VARCHAR,
  country VARCHAR,
  distances TEXT,
  password VARCHAR NOT NULL,
  token VARCHAR DEFAULT '',
  sent_time TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS users;
