-- +micrate Up
CREATE TABLE messages (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users,
  conversation_id BIGINT REFERENCES conversations,
  body VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS messages;
