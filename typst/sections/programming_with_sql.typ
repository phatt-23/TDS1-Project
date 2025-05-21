= Programming with SQL

#v(2em)

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

#pagebreak()

== SQL S01 L02
_ROUND, TRUNC round for two decimal places, whole thousands MOD_

```sql
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
SELECT MOD(17, 5) AS remainder  -- 2
FROM dual;
```

== SQL S01 L03
- MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND, TRUNC
- System constant SYSDATE

```sql
-- MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND, TRUNC
SELECT
    SYSDATE AS now,
    MONTHS_BETWEEN(DATE '2025-05-01', DATE '2025-03-01') AS months_between,
    ADD_MONTHS(SYSDATE, 2) AS two_months_later,
    NEXT_DAY(SYSDATE, 'MONDAY') AS next_monday,
    LAST_DAY(SYSDATE) AS last_day_of_month,
    ROUND(SYSDATE, 'MONTH') AS rounded_to_month,
    TRUNC(SYSDATE, 'MONTH') AS trunc_to_month
FROM dual;
```

#pagebreak()

== SQL S02 L01
- TO_CHAR, TO_NUMBER, TO_DATE

```sql
-- TO_CHAR, TO_NUMBER, TO_DATE
SELECT
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') AS formatted_date_varchar2,
    TO_NUMBER('12345.67', '99999.99') AS to_number_example,
    TO_DATE('2025-12-01', 'YYYY-MM-DD') AS to_date_example
FROM dual;
```

== SQL S02 L02
- NVL, NVL2, NULLIF, COALESCE

```sql
-- NVL, NVL2, NULLIF, COALESCE
SELECT
    NVL(NULL, 'default') AS nvl_example,       -- 'default'
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
    DECODE(2,           -- expr switch:
        1, 'one',       --   expr1 => 'one'
        2, 'two',       --   expr2 => 'two'
           'other'      --   _ => 'other'
    ) AS decode_example,
    CASE 3
        WHEN 1 THEN 'one'
        WHEN 2 THEN 'two'
        WHEN 4 THEN 'four'
        ELSE 'other' END
    AS case_example
FROM dual;
```

== SQL S03 L01
- NATURAL JOIN, CROSS JOIN

```sql
SELECT * 
FROM z_user 
NATURAL JOIN z_playlist;   -- joins by common column names

SELECT * 
FROM z_user 
CROSS JOIN z_channel;  -- cartesian product, can't specify join clause
```

== SQL S03 L02
- JOIN ... USING(atr)
- JOIN ... ON (joining condition)

```sql
SELECT * 
FROM z_video_view 
JOIN z_video USING(video_id);    -- USING(column1, column2, ...)

SELECT * 
FROM z_video_view 
JOIN z_video ON (z_video_view.video_id = z_video.video_id);
```

== SQL S03 L03
- LEFT OUTER JOIN ... ON ()
- RIGHT OUTER JOIN ... ON ()
- FULL OUTER JOIN ... ON ()

```sql
SELECT * FROM z_video v LEFT OUTER JOIN z_video_view vv USING(video_id);
-- same as
SELECT * FROM z_video v LEFT JOIN z_video_view vv USING(video_id);

SELECT * FROM z_video v RIGHT OUTER JOIN z_video_view vv USING(video_id);

SELECT * FROM z_video v FULL OUTER JOIN z_video_view vv USING(video_id);
-- same as
SELECT * FROM z_video v LEFT OUTER JOIN z_video_view vv USING(video_id)
UNION
SELECT * FROM z_video v RIGHT OUTER JOIN z_video_view vv USING(video_id);
```

#pagebreak()

== SQL S03 L04
- Joining 2x of the same table with renaming (link between superiors and subordinates in one table)
- Hierarchical querying – tree structure of START WITH, CONNECT BY PRIOR, LEVEL


```sql
-- Self-join to link parent/child comments
SELECT 
    a.comment_id AS parent_id,
    b.comment_id AS child_id
FROM z_comment a
JOIN z_comment b ON a.comment_id = b.parent_comment_id;

-- Hierarchical query for comment tree
SELECT 
    LEVEL, 
    comment_id, 
    parent_comment_id, 
    content
FROM z_comment
START WITH parent_comment_id IS NULL
CONNECT BY PRIOR comment_id = parent_comment_id;
```

#pagebreak()

```sql
DECLARE
    v_parent_comment_id INT := 12;
    v_user_id INT := 12;
    v_video_id INT := 1;
BEGIN
    FOR i IN 0..10 LOOP
        INSERT INTO z_comment (parent_comment_id, video_id, user_id, content)
        VALUES (
            (SELECT comment_id FROM z_comment WHERE comment_id = v_parent_comment_id),
            (SELECT video_id FROM z_video WHERE video_id = v_video_id),
            (SELECT user_id FROM z_user WHERE user_id = v_user_id),
            'hello, world! reply to comment ' || i
        );
    END LOOP;
END;

DECLARE
    v_level INT := 0;
    v_comment_id Z_COMMENT.comment_id%TYPE := 0;
    v_parent_comment_id Z_COMMENT.comment_id%TYPE := 0;
    v_content Z_COMMENT.content%TYPE := '';
BEGIN
    FOR v_rec IN (
        SELECT 
            LEVEL, 
            comment_id, 
            parent_comment_id, 
            content
        FROM z_comment
        START WITH parent_comment_id IS NULL
        CONNECT BY PRIOR comment_id = parent_comment_id
    ) LOOP
        FOR v_tab IN 1..v_rec.LEVEL LOOP
            DBMS_OUTPUT.PUT('    ');
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(v_rec.comment_id || ' -> ' || v_rec.content);
    END LOOP;
END;
```



#pagebreak()

== SQL S04 L02
- AVG, COUNT, MIN, MAX, SUM, VARIANCE, STDDEV

```sql
BEGIN
    FOR rec IN (SELECT * FROM z_user CROSS JOIN z_video)
    LOOP
        INSERT INTO z_video_view(user_id, duration_watched, video_id)
        VALUES (rec.user_id, rec.duration / 2, rec.video_id);
    END LOOP;
END;

WITH t_video_view AS (
    SELECT
        video_id AS video_id,
        duration AS duration,
        COUNT(video_view_id) AS view_count
    FROM z_video JOIN z_video_view USING(video_id)
    GROUP BY video_id, duration
), t_reaction_count AS (
    SELECT
        (SELECT COUNT(*) FROM z_reaction r
         WHERE r.video_id = v.video_id AND reaction_kind = 'like') AS like_count,
        (SELECT COUNT(*) FROM z_reaction r
         WHERE r.video_id = v.video_id AND reaction_kind = 'dislike') AS dislike_count
    FROM z_video v
)
SELECT
    COUNT(*),
    AVG(view_count),
    MIN(duration),
    MAX(duration),
    SUM(like_count),
    AVG(dislike_count),
    VARIANCE(dislike_count),  -- Var(X) := E((X - mean) ** 2)
    SQRT(VARIANCE(dislike_count)) AS standard_deviation,  -- StdDev(X) := sqrt2(Var(X))
    STDDEV(dislike_count)
FROM t_video_view, t_reaction_count;
```

#pagebreak()

== SQL S04 L03
- COUNT, COUNT(DISTINCT), NVL
- Difference between COUNT (\*) a COUNT (attribute)
- Why using NVL for aggregation functions

```sql
SELECT 
    COUNT(*),
    COUNT(thumbnail_media_id),
    COUNT(DISTINCT visibility) 
FROM z_video;


WITH t AS (
    SELECT 
        v.video_id AS video_id, 
        NULLIF(COUNT(VIDEO_VIEW_ID), 0) AS view_count
    FROM z_video v 
    LEFT JOIN z_video_view vv ON v.video_id = vv.video_id
    GROUP BY v.video_id
)
SELECT
    AVG(NVL(view_count, 0)),
    -- not the same AVG, null is disregarded by default
    AVG(view_count)
FROM t;
```

== SQL S05 L01
- GROUP BY
- HAVING

```sql
SELECT 
    channel_id, 
    COUNT(*) AS total_videos
FROM z_video
GROUP BY channel_id;

SELECT 
    channel_id, 
    COUNT(*) AS total_videos
FROM z_video
GROUP BY channel_id 
HAVING COUNT(*) > 1;
```

#pagebreak()

== SQL S05 L02
- ROLLUP, CUBE, GROUPING SETS

```sql
-- GROUPING SETS
SELECT
    channel_id,
    visibility AS video_visibility,
    COUNT(*) AS video_count
FROM z_video
GROUP BY GROUPING SETS (
    (channel_id),
    (visibility)
);

-- equivalent to: (using UNION is much more inefficient)
SELECT
    channel_id,
    NULL AS video_visibility,
    COUNT(*) AS video_count
FROM z_video
GROUP BY channel_id

UNION ALL

SELECT
    NULL AS channel_id,
    visibility AS video_visibility,
    COUNT(*) AS video_count
FROM z_video
GROUP BY visibility;
```

#pagebreak()

```sql
-- GROUP BY CUBE
-- every combination, resulting in 2 ** n grouping sets
-- where n is number of columns in the cube list
SELECT channel_id,
       visibility AS video_visibility,
       COUNT(*) AS video_count
FROM z_video
GROUP BY CUBE(channel_id, visibility)
ORDER BY channel_id, video_visibility, video_count NULLS LAST;

-- is equivalent to this:
SELECT *
FROM (
    SELECT NULL AS channel_id,
           NULL AS video_visibility,
           COUNT(*) AS video_count
    FROM z_video

    UNION ALL

    SELECT channel_id AS channel_id,
           NULL AS video_visibility,
           COUNT(*) AS video_count
    FROM z_video
    GROUP BY channel_id

    UNION ALL

    SELECT NULL AS channel_id,
           visibility AS video_visibility,
           COUNT(*) AS video_count
    FROM z_video
    GROUP BY visibility

    UNION ALL

    SELECT channel_id AS channel_id,
           visibility AS video_visibility,
           COUNT(*) AS video_count
    FROM z_video
    GROUP BY channel_id, visibility
)
ORDER BY channel_id, video_visibility, video_count NULLS FIRST;
```

#pagebreak()

```sql
-- GROUP BY ROLLUP
SELECT
    channel_id,
    visibility AS video_visibility,
    COUNT(*) AS video_count
FROM z_video
GROUP BY ROLLUP(channel_id, visibility)
ORDER BY channel_id, video_visibility, video_count NULLS FIRST;
-- group by channel_id, visibility
-- with hierarchical subtotals per group and grand total being the sum of all subtotals

-- equivalent to this:
SELECT * FROM (
    SELECT
        channel_id AS channel_id,
        visibility AS video_visibility,
        COUNT(*) AS video_count
    FROM z_video
    GROUP BY channel_id, visibility

    UNION ALL

    SELECT
        channel_id AS channel_id,
        NULL AS video_visibility,
        COUNT(*) AS video_count
    FROM z_video
    GROUP BY channel_id

    UNION ALL

    SELECT
        NULL AS channel_id,
        NULL AS video_visibility,
        COUNT(*) AS video_count
    FROM z_video
)
ORDER BY channel_id, video_visibility, video_count NULLS FIRST;
```

#pagebreak()

== SQL S05 L03
- Multiple operations in SQL – UNION, UNION ALL, INTERSECT, MINUS
- ORDER BY for set operations

```sql
SELECT * FROM z_user;
SELECT * FROM z_user WHERE email LIKE '%yahoo.com';

SELECT username FROM z_user WHERE is_deleted = 0
UNION
SELECT channel_name FROM z_channel WHERE is_deleted = 0;

SELECT * FROM z_user WHERE email LIKE '%gmail.com'; -- 3
SELECT * FROM z_user WHERE first_name = 'Shelly'; -- 1

SELECT username FROM z_user WHERE first_name = 'Shelly'
INTERSECT -- 1
SELECT username FROM z_user WHERE email LIKE '%gmail.com';

SELECT username FROM z_user WHERE email LIKE '%gmail.com'
MINUS -- 2
SELECT username FROM z_user WHERE first_name = 'Shelly';

SELECT username FROM z_user
UNION ALL
SELECT channel_name FROM z_channel
ORDER BY 1; -- first item in the select list
-- ORDER BY username; -- could also be this though
```

#pagebreak()

== SQL S06 L01
- Nested queries
    - Result as a single value
    - Multi-column subquery
    - EXISTS, NOT EXISTS

```sql
SELECT username 
FROM z_user
WHERE user_id = (SELECT user_id FROM z_channel WHERE channel_name = 'Hicks Ltd');

SELECT 
    v.channel_id, 
    v.title 
FROM z_video v
WHERE (v.channel_id, v.visibility) IN (
    SELECT p.channel_id, p.visibility FROM z_playlist p
);

-- users with at least one video
SELECT * 
FROM z_user u
WHERE EXISTS (
    SELECT 1 FROM z_video v
    WHERE v.channel_id IN (
        SELECT c.channel_id 
        FROM z_channel c 
        WHERE c.user_id = u.user_id
    )
);
```

== SQL S06 L02
- One-line subqueries

```sql
SELECT 
    channel_name,
    (
        SELECT COUNT(*) 
        FROM z_video v 
        WHERE v.channel_id = c.channel_id
    ) AS video_count
FROM z_channel c;
```

#pagebreak()

== SQL S06 L03
- Multi-line subqueries IN, ANY, ALL
- NULL values in subqueries

```sql
-- users with private playlists
SELECT username 
FROM z_user
WHERE user_id IN (SELECT user_id FROM z_playlist WHERE visibility = 'private');

-- playlists that belong to deleted channels
SELECT playlist_id, channel_id 
FROM z_playlist
WHERE channel_id = ANY (
    SELECT channel_id
    FROM z_channel
    WHERE is_deleted = 1
);

-- playlist with the highest "order"
SELECT pv1.playlist_id, "order" 
FROM z_playlist_video pv1
WHERE "order" >= ALL (
    SELECT "order" FROM z_playlist_video
);
```

== SQL S06 L04
- WITH ... AS() subquery construction

```sql
SELECT 
    SYSDATE - 30 AS back_x_days, 
    ADD_MONTHS(SYSDATE, 2) AS back_x_months 
FROM dual;

-- channels that uploaded videos last x years
WITH recent_videos AS (
    SELECT * FROM z_video
    WHERE upload_date > ADD_MONTHS(SYSDATE, -2 * 12)
)
SELECT 
    channel_id, 
    COUNT(*) AS video_count
FROM recent_videos
GROUP BY channel_id;
```

#pagebreak()

== SQL S07 L01
- INSERT INTO Tab VALUES()
- INSERT INTO Tab (atr, atr) VALUES()
- INSERT INTO Tab AS SELECT ...

```sql
-- Simple INSERT
INSERT INTO z_category 
VALUES (1, 11, 'Technology');

-- Column-specified INSERT
INSERT INTO z_category(parent_category_id, category_name)
VALUES (11,'Technology');

INSERT INTO z_user (username, first_name, last_name, email)
VALUES ('newuser', 'New', 'User', 'new@user.com');

-- INSERT INTO ... SELECT
INSERT INTO z_playlist (user_id, title, visibility, creation_date)
SELECT user_id, 'Auto Playlist', 'public', SYSDATE 
FROM z_user WHERE username = 'newuser';
```

== SQL S07 L02
- UPDATE Tab SET atr = ... WHERE condition
- DELETE FROM Tab WHERE atr = ...

```sql
-- UPDATE
UPDATE z_video 
SET title = 'Updated Title' 
WHERE video_id = 1;

-- DELETE
DELETE FROM z_comment 
WHERE comment_id = 1;
```

#pagebreak()

== SQL S07 L03
- DEFAULT, MERGE, Multi-Table Inserts

```sql
-- DEFAULT usage
INSERT INTO z_user (username, first_name, last_name, email, is_deleted)
VALUES ('defaultuser', 'Def', 'User', 'def@user.com', DEFAULT);

-- MERGE example
MERGE INTO z_user u               -- destination
    USING (
      SELECT 
        1 AS user_id, 
        'mergeuser' AS username 
      FROM DUAL  
    ) src                         -- data source
  ON (u.user_id = src.user_id)    -- condition (true -> matched, false -> not matched)
    WHEN MATCHED THEN                                               
      UPDATE SET u.username = src.username || '_updated'        -- udpate clause
    WHEN NOT MATCHED THEN                                           
      INSERT (user_id, username, first_name, last_name, email)  -- insert clause
      VALUES (src.user_id, src.username, 'M', 'U', 'mu@example.com');



DELETE FROM z_user WHERE username LIKE 'mergeuser%';
SELECT * FROM z_user;
SELECT * FROM z_user WHERE username LIKE 'mergeuser%';
```

#pagebreak()

== SQL S08 L01
- Objects in databases – Tables, Indexes, Constraint, View, Sequence, Synonym
- CREATE, ALTER, DROP, RENAME, TRUNCATE
- CREATE TABLE (atr DAT TYPE, DEFAULT NOT NULL )
- *ORGANIZATION EXTERNAL, TYPE ORACLE_LOADER, DEFAULT DICTIONARY, 
  ACCESS PARAMETERS, RECORDS DELIMITED BY NEWLINE, FIELDS, LOCATION*

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
INSERT INTO z_test_renamed(id, name)
  SELECT user_id, username 
  FROM z_user;

TRUNCATE TABLE z_test_renamed;
```

#pagebreak()

```sql
-- create a directory object pointing to the location of the files
CREATE OR REPLACE DIRECTORY ext_tab_dir AS './ext_data';

-- load data from external files
CREATE TABLE x_country_ext (
    country_code      VARCHAR2(5),
    country_name      VARCHAR2(50),
    country_language  VARCHAR2(50)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_tab_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
        RECORDS FIXED 20 FIELDS
        (
            country_code      CHAR(5),
            country_name      CHAR(50),
            country_language  CHAR(50)
        )
    )
    LOCATION (
        'Countries1.txt',
        'Countries2.txt'
    )
);

-- Countries1.txt 
/*
ENG,England,English
SCO,Scotland,English
IRE,Ireland,English
WAL,Wales,Welsh
*/

-- Countries2.txt
/*
FRA,France,French
GER,Germany,German
USA,Unites States of America,English
*/

```



#pagebreak()

== SQL S08 L02
- TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIMEZONE
- INTERVAL YEAR TO MONTH, INTERVAL DAY TO SECOND
- CHAR, VARCHAR2, CLOB
- about NUMBER
- about BLOB

```sql
-- Advanced data types
CREATE TABLE z_types_demo (
    n       NUMBER, 
    c       CHAR(10),
    vc      VARCHAR2(100),
    ts      TIMESTAMP,
    ts_tz   TIMESTAMP WITH TIME ZONE,
    ts_ltz  TIMESTAMP WITH LOCAL TIME ZONE,
    iv1     INTERVAL YEAR TO MONTH,   -- stores intervals using year and month
    iv2     INTERVAL DAY TO SECOND,   -- stores intervals using days, hours, minutes, 
                                      -- and seconds including fractional seconds
    txt     CLOB, -- character large object
    bin     BLOB --  binary large object
);

SELECT * FROM z_types_demo;

DROP TABLE z_types_demo;

CREATE TABLE z_demo_student (
    years_of_undergrad INTERVAL YEAR TO MONTH
);

INSERT INTO z_demo_student VALUES (INTERVAL '10-2' YEAR TO MONTH);
INSERT INTO z_demo_student VALUES (INTERVAL '2-3' YEAR TO MONTH);
INSERT INTO z_demo_student VALUES (INTERVAL '9' MONTH);

SELECT * FROM z_demo_student;

DROP TABLE z_demo_student;
```

#pagebreak()

== SQL S08 L03
- ALTER TABLE (ADD, MODIFY, DROP), DROP, RENAME
- FLASHBACK TABLE Tab TO BEFORE DROP (view USER_RECYCLEBIN)
- DELETE, TRUNCATE
- COMMENT ON TABLE
- SET UNUSED

```sql
-- ALTER operations
ALTER TABLE z_demo_student ADD email NVARCHAR2(100);
ALTER TABLE z_demo_student MODIFY email NVARCHAR2(300);
ALTER TABLE z_demo_student DROP COLUMN email;

CREATE TABLE z_demo_student (years_of_undergrad INTERVAL YEAR TO MONTH);

INSERT INTO z_demo_student VALUES (INTERVAL '10-2' YEAR TO MONTH);
INSERT INTO z_demo_student VALUES (INTERVAL '2-3' YEAR TO MONTH);
INSERT INTO z_demo_student VALUES (INTERVAL '9' MONTH);

DROP TABLE z_demo_student;

-- FLASHBACK
FLASHBACK TABLE z_demo_student TO BEFORE DROP;

-- COMMENT
COMMENT ON TABLE z_demo_student IS 'Holds student info and stuff';

-- SET UNUSED
-- source: https://forums.oracle.com/ords/apexds/post/set-unused-and-drop-column-4001
-- The SET UNUSED option marks one or more columns as unused so
-- that they can be dropped when the demand on system resources
-- is lower. Specifying this clause does not actually remove the
-- target columns from each row in the table (that is, it does not
-- restore the disk space used by these columns).Therefore, the
-- response time is faster than if you executed the DROP clause.
-- Unused columns are treated as if they were dropped, even though
-- their column data remains in the tables rows. After a column
-- has been marked as unused, you have no access to that column.
ALTER TABLE z_demo_student SET UNUSED (email);
```

#pagebreak()

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
CREATE TABLE z_user_copy AS 
    SELECT * 
    FROM z_user;

SELECT * 
FROM z_user_copy;

DROP TABLE z_user_copy;
```

== SQL S10 L02
- CONSTRAINT – NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY (atr REFERENCES Tab(atr) ), CHECK
- Foreign keys, ON DELETE, ON UPDATE, RESTRICT, CASCADE, etc.

```sql
-- Foreign key with ON DELETE CASCADE
CREATE TABLE z_fk_demo (
    id NUMBER PRIMARY KEY,
    user_id NUMBER,
    CONSTRAINT fk_demo_user 
        FOREIGN KEY (user_id) REFERENCES z_user(user_id) 
        ON DELETE CASCADE
);

-- CHECK constraint
ALTER TABLE z_fk_demo ADD CONSTRAINT ck_demo_id CHECK (id > 0);
```

#pagebreak()

== SQL S10 L03
- about USER_CONSTRAINTS

```sql
-- Inspect user constraints of table "z_user"
SELECT 
    constraint_name, 
    constraint_type, 
    table_name
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
    SELECT user_id, username, email
    FROM z_user
    WHERE is_deleted = 0;

-- View with CHECK OPTION
--    any INSERT or UPDATE done through the view must result
--    in rows that are still visible in the view
--    that is, they must satisfy the view's WHERE condition.
CREATE OR REPLACE VIEW v_public_playlists AS
    SELECT *
    FROM z_playlist
    WHERE visibility = 'public'
WITH CHECK OPTION;

-- Read-only view
CREATE OR REPLACE VIEW v_readonly AS
    SELECT video_id, title 
    FROM z_video
WITH READ ONLY;
```

#pagebreak()

== SQL S11 L03
- INLINE VIEW Subquery in the form of a table SELECT atr FROM (SELECT \* FROM Tab) alt_tab

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
CREATE SEQUENCE seq_demo_student_id
    INCREMENT BY 1
    START WITH 100
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

ALTER SEQUENCE seq_demo_student_id INCREMENT BY 5;

CREATE TABLE z_demo_student (
    id NUMBER DEFAULT seq_demo_student_id.nextval,
    name VARCHAR2(40 CHAR)
);

INSERT INTO z_demo_student(name) VALUES ('john');
INSERT INTO z_demo_student(name) VALUES ('doe');

SELECT * FROM z_demo_student;

DROP SEQUENCE seq_demo_student_id;

DROP TABLE z_demo_student;
```

#pagebreak()

== SQL S12 L02
- CREATE INDEX, PRIMARY KEY, UNIQUE KEY, FOREIGN KEY

```sql
-- Index creation
CREATE INDEX idx_z_demo_student_name ON z_demo_student(name);
```

== SQL S13 L01
- GRANT ... ON ... TO ... PUBLIC
- about REVOKE
- What rights can be assigned to which objects? (ALTER, DELETE, EXECUTE, INDEX,
INSERT, REFERENCES, SELECT, UPDATE) – (TABLE, VIEW, SEQUENCE, PROCEDURE)

```sql
-- Granting privileges
GRANT SELECT, INSERT, UPDATE ON z_user TO PUBLIC;

GRANT DELETE ON z_video TO some_user;

-- Revoking privileges
REVOKE SELECT, INSERT, UPDATE ON z_user FROM PUBLIC;
```

#pagebreak()

== SQL S13 L03
- Regular expressions
- REGEXP_LIKE, REGEXP_REPLACE, REGEXP_INSTR, REGEXP_SUBSTR, REGEXP_COUNT

```sql
-- Regular expressions
SELECT email 
FROM z_user 
WHERE REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

SELECT REGEXP_REPLACE(
    '123-456-7890', 
    '[^0-9]', 
    'non_number'
) FROM DUAL;

-- returns index 3 because number '1' is at that position
SELECT REGEXP_INSTR(
    'aa1b2c3', 
    '[0-9]'
) FROM DUAL; 

SELECT REGEXP_SUBSTR(
    'abc123def456ghi789jkl012',
    '[0-9]+',
    10,                         -- starting pos in source string
    3                           -- occurrence
) FROM DUAL;

-- 8
SELECT REGEXP_COUNT(
    'a1b2c3d45e67f8g', 
    '[0-9]'
) FROM DUAL;

-- 6
SELECT REGEXP_COUNT(
    'a1b2c3d45e67f8g', 
    '[0-9]+'
) FROM DUAL;
```

#pagebreak()

== SQL S14 L01
- Transactions, COMMIT, ROLLBACK, SAVEPOINT

```sql
SELECT * FROM z_user WHERE user_id = 1;

-- Transaction control
DECLARE
    v_success INT := 0;
BEGIN
    SAVEPOINT before_update;

    -- do some transaction stuff
    UPDATE z_user 
    SET email = 'new@email.com' 
    WHERE user_id = 1;

    -- throw error if something goes wrong
    IF v_success = 0 THEN
        RAISE_APPLICATION_ERROR(50001, 'Transaction failed :(');
    END IF;
    
    -- if nothing went wrong, commit the changes
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transaction successful - changes commited');

EXCEPTION 
    WHEN OTHERS THEN
        -- if anything goes wrong, rollback
        ROLLBACK TO before_update;
        DBMS_OUTPUT.PUT_LINE('Transaction failed - rolling back changes');
END;
```

#pagebreak()

== SQL S15 L01
- Alternative join notation without JOIN with join condition in WHERE
- Left and right connection using atrA = atrB (+)

```sql
-- Join using WHERE (legacy style)

SELECT *
FROM 
    z_user u,
    z_channel c
WHERE u.user_id = c.user_id;

-- LEFT and RIGHT JOIN using (+) operator

SELECT *
FROM z_video v
LEFT JOIN z_video_view vv ON v.video_id = vv.video_id
WHERE vv.VIDEO_VIEW_ID IS NULL;
-- equivalent to
SELECT *
FROM 
    z_video v,
    z_video_view vv
WHERE v.video_id = vv.video_id(+) -- the side with (+) is 'added'
  AND vv.VIDEO_VIEW_ID IS NULL;


SELECT *
FROM z_video_view vv
RIGHT JOIN z_video v ON vv.video_id = v.video_id;
-- equivalent to
SELECT *
FROM 
    z_video_view vv,
    z_video v
WHERE v.video_id = vv.video_id(+);
```

/*
== SQL S16 L03
- Recapitulation of commands and parameters - complete everything that was not mentioned in the previous points here
*/


