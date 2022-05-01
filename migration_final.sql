-- migration of usernames from bad_posts and bad_comments to table user
INSERT INTO "user" ("username")
SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(upvotes, ',' )
FROM "bad_posts"
UNION
SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(downvotes, ',' )
FROM "bad_posts"
UNION
SELECT DISTINCT "username"
FROM "bad_posts"
UNION
SELECT DISTINCT "username"
FROM "bad_comments";

-- migration of distinct topics from bad_posts into table topic
INSERT INTO "topic" ("topicname")
SELECT DISTINCT "topic"
FROM "bad_posts";

-- migrate information from bad_posts into table post
INSERT INTO "post" ("posttitle", "url", "text_content", "user_id",
"topic_id")
SELECT LEFT("bp"."title", 100) AS "posttitle",
"bp"."url",
"bp"."text_content",
"u"."id" AS"user_id",
"tp"."id" AS "topic_id"
FROM "user" AS "u"
JOIN "bad_posts" AS "bp"
ON "u"."username" = "bp"."username"
JOIN "topic" AS "tp"
ON "bp"."topic" = "tp"."topicname";

-- migrate information from bad_comments into table comment
INSERT INTO "comment" ("text", "user_id", "post_id")
SELECT "bc"."text_content" AS "text",
"u"."id" AS "user_id",
"p"."id" AS "post_id"
FROM "bad_comments" AS "bc"
JOIN "user" AS "u"
ON "u"."username" = "bc"."username"
JOIN "post" AS "p"
ON "p"."id" = "bc"."post_id";

-- migrate information from bad_posts into table vote
INSERT INTO "vote" ("user_id", "vote")
WITH "downvote" AS (
SELECT "id", REGEXP_SPLIT_TO_TABLE("downvotes", ',') AS "downvotes"
FROM "bad_posts" AS "bp"),
"upvote" AS (
SELECT "id", REGEXP_SPLIT_TO_TABLE("upvotes", ',') AS "upvotes"
FROM "bad_posts" AS "bp")
SELECT "u"."id", -1 AS "vote"
FROM "downvote" AS "dv"
JOIN "user" AS "u"
ON "dv"."downvotes" = "u"."username"
UNION ALL
SELECT "u"."id", 1 AS "vote"
FROM "upvote" AS "uv"
JOIN "user" AS "u"
ON "uv"."upvotes" = "u"."username";

-- drop initial tables after successful data migration
DROP TABLE "bad_posts";
DROP TABLE "bad_comments";
