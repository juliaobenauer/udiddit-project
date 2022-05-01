# Udiddit, a social news aggregator

## Introduction

Udiddit, a social news aggregation, web content rating, and discussion website, is currently
using a risky and unreliable Postgres database schema to store the forum posts,
discussions, and votes made by their users about different topics.
The schema allows posts to be created by registered users on certain topics, and can
include a URL or a text content. It also allows registered users to cast an upvote (like) or
downvote (dislike) for any forum post that has been created. In addition to this, the schema
also allows registered users to add comments on posts.

## Part I: Investigate the existing schema

As a first step, investigate this schema and some of the sample data in the project's SQL
workspace. Then, in your own words, outline three (3) specific things that could be
improved about this schema. Don't hesitate to outline more if you want to stand out!

## Part II: Create DDL for your new schema

Having done this initial investigation and assessment, your next goal is to dive deep into
the heart of the problem and create a new schema for Udiddit. Your new schema should at
least reflect fixes to the shortcomings you pointed to in the previous exercise.

## Part III: Migrate the provided data

Now that your new schema is created, it's time to migrate the data from the provided
schema in the project's SQL Workspace to your own schema. This will allow you to review
some DML and DQL concepts, as you'll be using INSERT...SELECT queries to do so.


## Disclaimer

Data and project information were kindly provided by [Udacity](https://www.udacity.com/).
