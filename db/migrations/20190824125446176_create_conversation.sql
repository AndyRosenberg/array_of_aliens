-- +micrate Up
CREATE TABLE conversations (
  id BIGSERIAL PRIMARY KEY,
  starter_id BIGINT,
  recipient_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS conversations;
