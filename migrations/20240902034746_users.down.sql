-- How to undo the migration if needed
DROP TABLE IF EXISTS "users";

DROP TYPE IF EXISTS user_role;

DROP EXTENSION IF EXISTS "uuid-ossp";
