-- create user table based on guidelines and review #2 feedback
CREATE TABLE "user" (
"id" SERIAL PRIMARY KEY,
"username" TEXT NOT NULL CHECK (LENGTH (TRIM ("username")) > 0),
CONSTRAINT "username_length" CHECK (LENGTH("username") <= 25),
CONSTRAINT "username_unique" UNIQUE ("username"),
"last_login" TIMESTAMP
);

-- create topic table based on guidelines and review #2 feedback
CREATE TABLE "topic" (
"id" SERIAL PRIMARY KEY,
"topicname" TEXT UNIQUE NOT NULL CHECK (LENGTH (TRIM ("topicname")) > 0),
CONSTRAINT "topicname_length" CHECK (LENGTH("topicname") <= 30),
"topicdesc" TEXT,
CONSTRAINT "topicdesc_length" CHECK (LENGTH("topicdesc") <= 500),
"topicdate" TIMESTAMP
);

-- create post table based on guidelines and review #2 feedback
CREATE TABLE "post" (
"id" SERIAL PRIMARY KEY,
"posttitle" TEXT NOT NULL CHECK (LENGTH (TRIM ("posttitle")) > 0),
CONSTRAINT "posttitle_length" CHECK (LENGTH("posttitle") <= 100),
"url" TEXT,
CONSTRAINT "url_length" CHECK (LENGTH("url") <= 2000),
"text_content" TEXT,
"user_id" INT REFERENCES "user" ("id") ON DELETE SET NULL,
"topic_id" INT NOT NULL REFERENCES "topic" ("id") ON DELETE CASCADE,
"last_post" TIMESTAMP
);

ALTER TABLE "post"
ADD CONSTRAINT "urlcontent" CHECK(
("url" IS NULL AND "text_content" IS NOT NULL)
OR
("url" IS NOT NULL AND "text_content" IS NULL)
);

-- create comment table based on guidelines and review #2 feedback
CREATE TABLE "comment" (
"id" SERIAL PRIMARY KEY,
"text" TEXT NOT NULL CHECK (LENGTH (TRIM ( "text" )) > 0),
"parent_comment_id" INT REFERENCES "comment" ("id") ON DELETE CASCADE,
"user_id" INT REFERENCES "user" ("id") ON DELETE SET NULL,
"post_id" INT NOT NULL REFERENCES "post" ("id") ON DELETE CASCADE,
"date_commented" TIMESTAMP
);

-- create vote table based on guidelines and review #2 feedback
CREATE TABLE "vote" (
"id" SERIAL PRIMARY KEY,
"user_id" INT REFERENCES "user" ("id") ON DELETE SET NULL,
"post_id" INT REFERENCES "post" ("id") ON DELETE CASCADE,
"vote" SMALLINT CHECK ("vote" = 1 OR "vote" = -1),
CONSTRAINT "no_repeat_votes" UNIQUE ("user_id","post_id")
);

-- create indices for new schema
CREATE INDEX "finding_user_last_login_date" ON "user" ("username", "last_login");
CREATE INDEX "finding_latest_posts_for_topic" ON "post" ("url", "text_content",
"last_post", "topic_id");
CREATE INDEX "finding_latest_posts_for_user" ON "post" ("url", "text_content",
"last_post", "user_id");
CREATE INDEX "finding_all_posts_with_url" ON "post" ("url");
CREATE INDEX "finding_latest_comments_for_user" ON "comment" ("date_commented",
"user_id");
CREATE INDEX "finding_top_level_comment" ON "comment" ("text", "post_id",
"parent_comment_id") WHERE "parent_comment_id" = NULL;
CREATE INDEX "finding_post_score" ON "vote" ("post_id", "vote");
