= Programming with SQL

== SQL S01 L01
- LOWER, UPPER, INITCAP
- CONCAT, SUBSTR, LENGTH, INSTR, LPAD, RPAD, TRIM, REPLACE
- Use virtual table DUAL

```sql
-- LOWER, UPPER, INITCAP
SELECT
  LOWER('HeLLo WorlD') AS lower,
  UPPER('HeLLo WorlD') AS upper,
  INITCAP('heLLo worLD') AS initcap
FROM dual;

-- CONCAT, SUBSTR, LENGTH, INSTR
SELECT
  CONCAT('Hello', 'World') AS concatenated,
  SUBSTR('abcdef', 2, 3) AS substr_example, -- 'bcd'
  LENGTH('Oracle') AS len,
  INSTR('banana', 'a') AS first_a_position
FROM dual;

-- LPAD, RPAD
SELECT
  LPAD('42', 5, '0') AS lpad_example,  -- '00042'
  RPAD('ok', 5, '.') AS rpad_example   -- 'ok...'
FROM dual;

-- TRIM, REPLACE
SELECT
  TRIM(' x ') AS trimmed,                -- 'x'
  REPLACE('abracadabra', 'a', 'X') AS replaced
FROM dual;
```

== SQL S01 L02
- ROUND, TRUNC round for two decimal places, whole thousands MOD

```sql
-- ROUND and TRUNC to 2 decimal places
SELECT
  ROUND(123.4567, 2) AS round_2dec,     -- 123.46
  TRUNC(123.4567, 2) AS trunc_2dec      -- 123.45
FROM dual;

-- ROUND and TRUNC to whole thousands
SELECT
  ROUND(98765, -3) AS round_thousands,  -- 99000
  TRUNC(98765, -3) AS trunc_thousands   -- 98000
FROM dual;

-- MOD to get remainder
SELECT
  MOD(17, 5) AS remainder               -- 2
FROM dual;
```

== SQL S01 L03
- MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND, TRUNC
- System constant SYSDATE

```sql
-- MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND, TRUNC
SELECT
  MONTHS_BETWEEN(DATE '2025-05-01', DATE '2025-03-01') AS months_between,
  ADD_MONTHS(SYSDATE, 2) AS two_months_later,
  NEXT_DAY(SYSDATE, 'MONDAY') AS next_monday,
  LAST_DAY(SYSDATE) AS last_day_of_month,
  ROUND(SYSDATE, 'MONTH') AS rounded_to_month,
  TRUNC(SYSDATE, 'MONTH') AS trunc_to_month
FROM dual;
```

== SQL S02 L01
- TO_CHAR, TO_NUMBER, TO_DATE

```sql
-- TO_CHAR, TO_NUMBER, TO_DATE
SELECT
  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') AS formatted_date,
  TO_NUMBER('12345.67', '99999.99') AS to_number_example,
  TO_DATE('2025-12-01', 'YYYY-MM-DD') AS to_date_example
FROM dual;
```

== SQL S02 L02
- NVL, NVL2, NULLIF, COALESCE

```sql
-- NVL, NVL2, NULLIF, COALESCE
SELECT
  NVL(NULL, 'default') AS nvl_example,
  NVL2(NULL, 'a', 'b') AS nvl2_null,         -- 'b'
  NVL2('X', 'a', 'b') AS nvl2_notnull,       -- 'a'
  NULLIF(100, 100) AS nullif_equal,          -- NULL
  COALESCE(NULL, NULL, 'first non-null') AS coalesce_example
FROM dual;
```

== SQL S02 L03
- DECODE, CASE, IF-THEN-ELSE

```sql
-- DECODE, CASE, IF-THEN-ELSE equivalent (only CASE is SQL standard)
SELECT
  DECODE(2, 1, 'one', 2, 'two', 'other') AS decode_example,
  CASE 3 WHEN 1 THEN 'one'
         WHEN 2 THEN 'two'
         ELSE 'other' END AS case_example
FROM dual;
```

== SQL S03 L01
- NATURAL JOIN, CROSS JOIN

```sql
SELECT * FROM z_user NATURAL JOIN z_playlist;
SELECT * FROM z_user CROSS JOIN z_channel;
```


== SQL S03 L02
- JOIN … USING(atr)
- JOIN .. ON (joining condition)

```sql
SELECT * FROM z_video_view JOIN z_video USING(video_id);
SELECT * FROM z_video_view JOIN z_video ON (z_video_view.video_id = z_video.video_id);
```

== SQL S03 L03
- LEFT OUTER JOIN … ON ()
- RIGHT OUTER JOIN … ON ()
- FULL OUTER JOIN … ON ()

```sql
SELECT * FROM z_video v LEFT OUTER JOIN z_video_view vv ON v.video_id = vv.video_id;
SELECT * FROM z_video v RIGHT OUTER JOIN z_video_view vv ON v.video_id = vv.video_id;
SELECT * FROM z_video v FULL OUTER JOIN z_video_view vv ON v.video_id = vv.video_id;
```


== SQL S03 L04
- Joining 2x of the same table with renaming (link between superiors and subordinates
in -ne table)
- Hierarchical querying – tree structure of START WITH, CONNECT BY PRIOR, LEVEL
dive

```sql
-- Self-join to link parent/child comments
SELECT a.comment_id AS parent_id, b.comment_id AS child_id
FROM z_comment a
JOIN z_comment b ON a.comment_id = b.parent_comment_id;

-- Hierarchical query for comment tree
SELECT LEVEL, comment_id, parent_comment_id, content
FROM z_comment
START WITH parent_comment_id IS NULL
CONNECT BY PRIOR comment_id = parent_comment_id;
```


== SQL S04 L02
- AVG, COUNT, MIN, MAX, SUM, VARIANCE, STDDEV

```sql
SELECT
  AVG(view_count),
  COUNT(*),
  MIN(duration),
  MAX(duration),
  SUM(like_count),
  VARIANCE(dislike_count),
  STDDEV(dislike_count)
FROM z_video;
```


== SQL S04 L03
- COUNT, COUNT(DISTINCT ), NVL
- Difference between COUNT (\*) a COUNT (attribute)
- Why using NVL for aggregation functions

```sql
SELECT COUNT(*) FROM z_video;
SELECT COUNT(thumbnail_id) FROM z_video;
SELECT COUNT(DISTINCT visibility) FROM z_video;
SELECT SUM(NVL(view_count, 0)) FROM z_video;
```


== SQL S05 L01
- GROUP BY
- HAVING

```sql
SELECT channel_id, COUNT(*) AS total_videos FROM z_video GROUP BY channel_id;
SELECT channel_id, COUNT(*) AS total_videos FROM z_video GROUP BY channel_id HAVING COUNT(*) > 5;
```


== SQL S05 L02
- ROLLUP, CUBE, ROUPING SETS

```sql
SELECT channel_id, visibility, COUNT(*) FROM z_video GROUP BY ROLLUP(channel_id, visibility);
SELECT channel_id, visibility, COUNT(*) FROM z_video GROUP BY CUBE(channel_id, visibility);
SELECT channel_id, visibility, COUNT(*) FROM z_video GROUP BY GROUPING SETS ((channel_id), (visibility));
```


== SQL S05 L03
- Multiple operations in SQL – UNION, UNION ALL, INTERSECT, MINUS
- ORDER BY for set operations

```sql
SELECT username FROM z_user WHERE is_deleted = 0
UNION
SELECT channel_name FROM z_channel WHERE is_deleted = 0;

SELECT username FROM z_user
INTERSECT
SELECT email FROM z_user;

SELECT username FROM z_user
MINUS
SELECT email FROM z_user;

SELECT username FROM z_user
UNION ALL
SELECT channel_name FROM z_channel
ORDER BY 1;
```


== SQL S06 L01
- Nested queries
- Result as a single value
- Multi-column subquery
- EXISTS, NOT EXISTS

```sql
SELECT username FROM z_user
WHERE user_id = (SELECT user_id FROM z_channel WHERE channel_name = 'TechWorld');

SELECT channel_id, title FROM z_video
WHERE (channel_id, visibility) IN (SELECT channel_id, visibility FROM z_playlist);

SELECT * FROM z_user u
WHERE EXISTS (
  SELECT 1 FROM z_video v
  WHERE v.channel_id IN (
    SELECT c.channel_id FROM z_channel c WHERE c.user_id = u.user_id
  )
);

SELECT * FROM z_user u
WHERE NOT EXISTS (
  SELECT 1 FROM z_video v
  WHERE v.channel_id IN (
    SELECT c.channel_id FROM z_channel c WHERE c.user_id = u.user_id
  )
);
```

== SQL S06 L02
- One-line subqueries

```sql
SELECT username,
       (SELECT COUNT(*) FROM z_video v WHERE v.channel_id = c.channel_id) AS video_count
FROM z_channel c;
```


== SQL S06 L03
- Multi-line subqueries IN, ANY, ALL
- NULL values in subqueries

```sql
SELECT username FROM z_user
WHERE user_id IN (
  SELECT user_id FROM z_playlist WHERE visibility = 'private'
);

SELECT user_id FROM z_playlist
WHERE channel_id = ANY (
  SELECT channel_id FROM z_channel WHERE is_deleted = 0
);

SELECT user_id FROM z_playlist
WHERE channel_id = ALL (
  SELECT channel_id FROM z_channel WHERE user_id IS NOT NULL
);
```


== SQL S06 L04
- WITH .. AS() subquery construction

```sql
WITH recent_videos AS (
  SELECT * FROM z_video WHERE upload_date > SYSDATE - 30
)
SELECT channel_id, COUNT(*) FROM recent_videos GROUP BY channel_id;
```


== SQL S07 L01
- INSERT INTO Tab VALUES()
- INSERT INTO Tab (atr, atr) VALUES()
- INSERT INTO Tab AS SELECT …

```sql
-- Simple INSERT
INSERT INTO z_category (category_id, category_name) VALUES (1, 'Technology');

-- Column-specified INSERT
INSERT INTO z_user (username, first_name, last_name, email, status, last_login)
VALUES ('newuser', 'New', 'User', 'new@user.com', 'active', SYSDATE);

-- INSERT INTO ... SELECT
INSERT INTO z_playlist (user_id, title, visibility, creation_date)
SELECT user_id, 'Auto Playlist', 'public', SYSDATE FROM z_user WHERE username = 'newuser';
```


== SQL S07 L02
- UPDATE Tab SET atr= …. WHERE condition
- DELETE FROM Tab WHERE atr=…

```sql
-- UPDATE
UPDATE z_video SET title = 'Updated Title' WHERE video_id = 1;

-- DELETE
DELETE FROM z_comment WHERE comment_id = 1;
```

== SQL S07 L03
- DEFAULT, MERGE, Multi-Table Inserts

```sql
-- DEFAULT usage
INSERT INTO z_user (username, first_name, last_name, email, status, last_login, is_deleted)
VALUES ('defaultuser', 'Def', 'User', 'def@user.com', 'active', SYSDATE, DEFAULT);

-- MERGE example
MERGE INTO z_user u
USING (SELECT 1 AS user_id, 'mergeuser' AS username FROM DUAL) src
ON (u.user_id = src.user_id)
WHEN MATCHED THEN UPDATE SET u.username = src.username
WHEN NOT MATCHED THEN INSERT (user_id, username, first_name, last_name, email, status, last_login)
VALUES (src.user_id, src.username, 'M', 'U', 'mu@example.com', 'active', SYSDATE);
```

== SQL S08 L01
- Objects in databases – Tables, Indexes, Constraint, View, Sequence, Synonym
- CREATE, ALTER, DROP, RENAME, TRUNCATE
- CREATE TABLE (atr DAT TYPE, DEFAULT NOT NULL )
- ORGANIZATION EXTERNAL, TYPE ORACLE_LOADER, DEFAULT DICTIONARY, ACCESS
PARAMETERS, REC-RDS DELIMITED BY NEWLINE, FIELDS, LOCATION

```sql
-- CREATE with constraints
CREATE TABLE z_test_object (
  id NUMBER PRIMARY KEY,
  name NVARCHAR2(100) DEFAULT 'N/A' NOT NULL
);

-- ALTER, RENAME, DROP
ALTER TABLE z_test_object ADD description NVARCHAR2(200);
RENAME z_test_object TO z_test_renamed;
DROP TABLE z_test_renamed;

-- TRUNCATE
TRUNCATE TABLE z_playlist;
```


== SQL S08 L02
- TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIMEZONE
- INTERVAL YEAT TO MONTH, INTERVAL DAY TO SECOND
- CHAR, VARCHAR2, CLOB
- about NUMBER
- about BLOB

```sql
-- Advanced data types
CREATE TABLE z_types_demo (
  ts TIMESTAMP,
  ts_tz TIMESTAMP WITH TIME ZONE,
  ts_ltz TIMESTAMP WITH LOCAL TIME ZONE,
  iv1 INTERVAL YEAR TO MONTH,
  iv2 INTERVAL DAY TO SECOND,
  c CHAR(10),
  vc VARCHAR2(100),
  txt CLOB,
  n NUMBER,
  bin BLOB
);
```


== SQL S08 L03
- ALTER TABLE (ADD, MODIFY, DROP), DROP, RENAME
- FLASHBACK TABLE Tab TO BEFORE DROP (view USER_RECYCLEBIN)
- DELETE, TRUNCATE
- COMMENT ON TABLE
- SET UNUSED

```sql
-- ALTER operations
ALTER TABLE z_user ADD bio NVARCHAR2(100);
ALTER TABLE z_user MODIFY email NVARCHAR2(300);
ALTER TABLE z_user DROP COLUMN bio;

-- FLASHBACK (assumes privilege enabled)
FLASHBACK TABLE z_user TO BEFORE DROP;

-- COMMENT
COMMENT ON TABLE z_user IS 'Holds user accounts';

-- SET UNUSED
ALTER TABLE z_user SET UNUSED (about_me);
```


== SQL S10 L01
- CREATE TABLE (NOT NULL AND UNIQUE constraint)
- CREATE TABLE Tab AS SELECT …
- Own vs. system naming CONSTRAINT conditions

```sql
-- Table with named constraints
CREATE TABLE z_example_constraints (
  id NUMBER CONSTRAINT pk_example PRIMARY KEY,
  name NVARCHAR2(100) CONSTRAINT nn_example_name NOT NULL,
  code NVARCHAR2(10) CONSTRAINT uq_example_code UNIQUE
);

-- CREATE TABLE AS SELECT
CREATE TABLE z_user_copy AS SELECT * FROM z_user;
```


== SQL S10 L02
- CONSTRAINT – NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY (atr REFERENCES
Tab(atr) ), CHECK
- Foreign keys, ON DELETE, ON UPDATE, RESTRICT, CASCADE, etc.

```sql
-- Foreign key with ON DELETE CASCADE
CREATE TABLE z_fk_demo (
  id NUMBER PRIMARY KEY,
  user_id NUMBER,
  CONSTRAINT fk_demo_user FOREIGN KEY (user_id) REFERENCES z_user(user_id) ON DELETE CASCADE
);

-- CHECK constraint
ALTER TABLE z_fk_demo ADD CONSTRAINT ck_demo_id CHECK (id > 0);
```


== SQL S10 L03
- about USER_CONSTRAINTS

```sql
-- Inspect user constraints
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name = 'Z_USER';
```


== SQL S11 L01
- CREATE VIEW
- about FORCE, NOFORCE
- WITCH CHECK OPTION
- WITH READ ONLY
- about Simple vs. Compex VIEW

```sql
-- Simple view
CREATE OR REPLACE VIEW v_active_users AS
SELECT user_id, username, email FROM z_user WHERE is_deleted = 0;

-- View with CHECK OPTION
CREATE OR REPLACE VIEW v_public_playlists AS
SELECT * FROM z_playlist WHERE visibility = 'public'
WITH CHECK OPTION;

-- Read-only view
CREATE OR REPLACE VIEW v_readonly AS
SELECT video_id, title FROM z_video
WITH READ ONLY;
```


== SQL S11 L03
- INLINE VIEW Subquery in the form of a table SELECT atr FROM (SELECT \* FROM Tab)
alt_tab

```sql
-- Inline view
SELECT alt.title FROM (
  SELECT title FROM z_video WHERE is_deleted = 0
) alt;
```

== SQL S12 L01
- CREATE SEQUENCE name INCREMENT BY n START WITH m, (NO)MAXVALUE,
(NO)MINVALUE, (NO)CYCLE, (NO)CACHE
- about ALTER SEQUENCE

```sql
-- Sequence creation and alteration
CREATE SEQUENCE seq_channel_id INCREMENT BY 1 START WITH 100
NOMAXVALUE NOCYCLE NOCACHE;

ALTER SEQUENCE seq_channel_id INCREMENT BY 5;
```

== SQL S12 L02
- CREATE INDEX, PRIMARY KEY, UNIQUE KEY, FOREIGN KEY

```
-- Index creation
CREATE INDEX idx_user_email ON z_user(email);
```

== SQL S13 L01
- GRANT … ON … TO … PUBLIC
- about REVOKE
- What rights can be assigned to which objects? (ALTER, DELETE, EXECUTE, INDEX,
INSERT, REFERENCES, SELECT, UPDATE) – (TABLE, VIEW, SEQUENCE, PROCEDURE)

```sql
-- Granting privileges
GRANT SELECT, INSERT, UPDATE ON z_user TO PUBLIC;
GRANT DELETE ON z_video TO some_user;

-- Revoking privileges
REVOKE INSERT, UPDATE ON z_user FROM PUBLIC;
```

== SQL S13 L03
- Regular expressions
- REGEXP_LIKE, REGEXP_REPLACE, REGEXP_INSTR, REGEXP_SUBSTR, REGEXP_COUNT

```sql
-- Regular expressions
SELECT * FROM z_user WHERE REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
SELECT REGEXP_REPLACE('123-456-7890', '[^0-9]', '') FROM DUAL;
SELECT REGEXP_INSTR('a1b2c3', '[0-9]') FROM DUAL;
SELECT REGEXP_SUBSTR('abc123def456', '[0-9]+', 1, 2) FROM DUAL;
SELECT REGEXP_COUNT('x1y2z3', '[0-9]') FROM DUAL;
```

== SQL S14 L01
- Transactions, COMMIT, ROLLBACK, SAVEPOINT

```sql
-- Transaction control
SAVEPOINT before_update;
UPDATE z_user SET email = 'new@email.com' WHERE user_id = 1;
ROLLBACK TO before_update;
COMMIT;
```

== SQL S15 L01
- Alternative join notation without JOIN with join condition in WHERE
- Left and right connection using atrA = atrB (+)

```sql
-- Join using WHERE (legacy style)
SELECT * FROM z_user u, z_channel c WHERE u.user_id = c.user_id;

-- LEFT and RIGHT JOIN using (+) operator
SELECT * FROM z_video v, z_video_view vv WHERE v.video_id = vv.video_id(+);
SELECT * FROM z_video_view vv, z_video v WHERE v.video_id(+) = vv.video_id;
```

== SQL S16 L03
- Recapitulation of commands and parameters - complete everything that was not mentioned in the previous points here

