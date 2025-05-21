= Database Design

#v(2em)

== DD S01 L02
_Explain the difference between the concept of data and information._

Data are raw facts or figures without context. For example, a number like 512,
a string like 'hello world', or a timestamp like '2025-05-10 19:32:51' are all
data. Information is data that has been processed or structured in a way that
adds meaning. For instance, interpreting 512 as the duration (in seconds) of a
video uploaded on '2025-05-10 19:32:51' transforms raw data into 
information.


== DD S02 L02
_Entities, instances, attributes and identifiers -- describe in examples on your project._

- *Entity:* z_user (represents a user)

- *Instance:* A specific record in the table. Example: A user with user_id = 1234, 
  username = 'jdoe', email = 'john.doe\@example.com', and status = 'active'.

- *Attributes:* Properties of an entity. For z_user, attributes include
  username, email, first_name, last_name, profile_picture_id, etc.

- *Identifiers:* Unique attributes or their combinations that distinguish one
  instance from another. Example: user_id is the primary key of z_user,
  uniquely identifying each user.

#pagebreak()

== DD S03 L01
- _Describe all relations in your database in English, including cardinality
  and membership obligation - each relation in two sentences._

#set text(size: 7.27pt)

#figure([

  // See the strokes section for details on this!
  #let frame(stroke) = (x, y) => (
    left: if x > 0 { 0.1pt } else { 0.5pt },
    right: 0.5pt,
    top: if y < 2 { 0.5pt } else { 0.1pt },
    bottom: 0.5pt,
  )

  #set table(
    fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },
    stroke: frame(rgb("21222C")),
  )

  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 4pt,
    align: left,
    table.header(
      [*Name*], [*Source*], [*Cardinality \ Optionality*], [*Target*], [*Description*]
    ),
    "Category_Has_SubCategories", "z_category", "1..1 : 0..*", "z_category",  "subcategory must refer to parent category, category can have many subcategories",
    "Channel_Has_BannerImage", "z_channel", "0..* : 0..1", "z_image_media",   "more channels can have the same banner image, channels can have a banner image",
    "Channel_Has_Playlists", "z_channel", "0..1 : 0..*", "z_playlist",  "playlist belongs to user, user can have many playlists",
    "Channel_Has_ProfileImage", "z_channel", "0..* : 0..1", "z_image_media",  "channel can have a profile image, image can be used as profile image by many channels",
    "Channel_Has_Subscriptions", "z_channel", "1..1 : 0..*", "z_subscription",  "subscriptions must refer to channel they target, channels can have many subscriptions",
    "Channel_Has_Videos", "z_channel", "1..1 : 0..*", "z_video",  "videos must refer to channel they belong to, channel can have many videos",
    "Comment_Has_Reaction", "z_comment", "1..1 : 0..*", "z_reaction", "reaction must refer to comment it reacted to, comment can have many reactions",
    "Comment_Has_SubComment", "z_comment", "1..1 : 0..*", "z_comment",  "subcomment must refer to parent comment, comment can have many subcomments",
    "Playlist_Has_Videos", "z_playlist", "1..1 : 0..*", "z_playlist_video",  "playlist_video must refer to playlist it's in, playlist can have many playlist_videos",
    "User_Has_Channels", "z_user", "1..1 : 0..*", "z_channel",  "channel must refer to user it belongs to, user can have many channels",
    "User_Has_Comments", "z_user", "1..1 : 0..*", "z_comment",  "comment must refer to user it was written by, user can write many comments",
    "User_Has_Playlists", "z_user", "1..1 : 0..*", "z_playlist",  "user can have many playlists, playlist must refer to user",
    "User_Has_ProfileImage", "z_user", "0..* : 0..1", "z_image_media",  "image can be used as profile image by many users, user can have a profile image",
    "User_Has_Reactions", "z_user", "1..1 : 0..*", "z_reaction",  "reaction must refer to user, user can make make reactions",
    "User_Has_Subscriptions", "z_user", "1..1 : 0..*", "z_subscription",  "subscriptions must refer to a user, user can have many subscriptions",
    "User_Has_VideoViews", "z_user", "1..1 : 0..*", "z_video_view",  "video view must refer to user, user can make many video views",
    "Video_Has_Comments", "z_video", "1..1 : 0..*", "z_comment",  "comment must refer to exactly one video, video can have many comments",
    "Video_Has_Reactions", "z_video", "1..1 : 0..*", "z_reaction",  "reaction must refer to exactly one video, video can have many reactions",
    "Video_Has_ThumbnailImage", "z_video", "0..* : 1..1", "z_image_media",  "video must have a thumbnail, images can be thumbnails of many videos",
    "Video_Has_VideoFile", "z_video", "0..1 : 1..1", "z_video_media",  "video must have exactly one video file, video file can be the content of many videos",
    "Video_Has_VideoViews", "z_video", "1..1 : 0..*", "z_video_view",  "video view must refer to video, videos can have many views",
    "Video_IsIn_Playlists", "z_video", "1..1 : 0..*", "z_playlist_video",  "playlist_video must refer to the video, video can be many playlist_videos",
    "z_video_category", "z_video", "0..* : 0..*", "z_category",  "video can have many categories, categories can refer to many videos",
    "User_OnChangeCreates_Audits", "z_user", "1..1 : 0..*", "z_user_audit",  "user audit must refer to a user, user can have many audits",
    "Comment_OnChangeCreates_Audits", "z_comment", "1..1 : 0..*", "z_comment_audit",  "comment audit must refer to a comment, comment can have many audits",
    "Video_OnChangeCreates_Audits", "z_video", "1..1 : 0..*", "z_video_audit",  "video audits must refer to a video, video can have many audits",
  )
], caption: [Relations with cardinality and optionality]
)

#set text(size: 11pt)

#pagebreak()

== DD S03 L02
_Draw an ER diagram according to conventions._

#figure(
  image("../assets/Logical.svg"),
  caption: [ER Diagram]
)

#pagebreak()
#set page(flipped: true)

== DD S30 L04
_Matrix diagram with relationships, draw for your solution._

Should be read starting from the left.

#set text(size: 5pt)

#figure([
  // See the strokes section for details on this!
  #let frame(stroke) = (x, y) => (
    left: if x > 0 { 0.1pt } else { 0.5pt },
    right: 0.5pt,
    top: if y < 2 { 0.5pt } else { 0.1pt },
    bottom: 0.5pt,
  )

  #set table(
    fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },
    stroke: frame(rgb("21222C")),
  )


  #table(
    columns: (1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
    align: left,
    table.header(
      [],
      [*category*],
      [*channel*],
      [*comment*],
      [*image_media*],
      [*media*],
      [*playlist*],
      [*playlist_video*],
      [*reaction*],
      [*subscription*],
      [*user*],
      [*video*],
      [*video_media*],
      [*video_view*]
    ),

    [*category*],       [has subcategories],[],[],[],[],[],[],[],[],[],[categorizes videos],[],[],
    [*channel*],        [],[#align(center, [---])],[],[has banner],[references media],[creates playlists],[],[],[has subscribers],[created by user],[has videos],[],[],
    [*comment*],        [],[],[has replies],[],[],[],[],[receives reactions],[],[written by user],[on video],[],[],
    [*image_media*],    [],[used by channel as pfp and banner],[],[#align(center, [---])],[is subtype of],[],[],[],[],[used in user for pfp],[],[],[],
    [*media*],          [],[],[],[is supertype of],[#align(center, [---])], [],[],[],[],[], [],[is supertype of],[],
    [*playlist*],       [],[created by],[],[],[],[#align(center, [---])],[contains videos],[],[],[created by user],[],[],[],
    [*playlist_video*], [],[],[],[],[],[belongs in],[#align(center, [---])],[],[],[],[references video],[],[],
    [*reaction*],       [],[],[on comment],[],[],[],[],[#align(center, [---])],[],[by user],[on video],[],[],
    [*subscription*],   [],[to channel],[],[],[],[],[],[],[#align(center, [---])],[by user],[],[],[],
    [*user*],           [],[creates channels],[writes comments],[has profile picture],[],[creates playlists],[],[creates reactions],[makes subscriptions],[#align(center, [---])],[],[],[makes views],
    [*video*],          [is categorized],[belongs to channel],[has comments],[has thumbnail image],[],[],[is in playlists],[receives reactions],[],[viewed by users],[#align(center, [---])],[has video file],[has views],
    [*video_media*],    [],[],[],[],[is subtype of],[],[],[],[],[],[referenced by],[#align(center, [---])],[],
    [*video_view*],     [],[],[],[],[],[],[],[],[],[made by user],[on video], [],[#align(center, [---])]

  )], caption: [Relationship Matrix])

#set text(size: 11pt)
#set page(flipped: false)


== DD S04 L01
_Supertypes and subtypes – define at least one instance of a supertype and a subtype in your project._

 The entity z_media is a generalization for all media. z_image_media and
z_video_media are specializations that inherit media_id, data and created_at
attributes from z_media but introduce additional attributes: 
- z_image_media: width, height, format
- z_video_media: duration, resolution, codec 


== DD S04 L02
_Description of business rules for your project._

- *Channel Ownership* 
  - channel cannot be reassigned to another user post-creation 
  - enforced by a BEFORE UPDATE trigger

- *Reaction Targeting* 
  - reaction must target either a video or a comment, but never both 
  - CHECK constraint

- *Playlist Creator Arc* 
  - only one of user_id or channel_id can be set for a playlist 
  - enforced by CHECK constraint

- *Soft Deletion* 
  - deletions are logical via is_deleted, not physical

- *Non-Transferability* 
  - certain foreign keys are immutable to preserve referential integrity (enforced with triggers)

- *Data Checks* 
  - start time must start before end time, video cannot have negative views, etc.


== DD S05 L01
_Include at least one transferable and one non-transferable binding in your project._

- *Transferable Binding* 
  - z_video.thumbnail_media_id $->$ z_image_media.media_id is portable 
  - supports reuse of shared images

- *Non-Transferable Binding* 
  - z_comment.user_id is locked after creation via a BEFORE UPDATE trigger 
  - non-transferable, immutable relationship

#pagebreak()

== DD S05 L03
_Have at least one M:N relationship without information and one M:N relationship with information in your project._

- *Without Information* - z_video_category links videos to categories. No extra attributes.
- *With Information* - z_playlist_video includes added_date and order, which add context beyond the M:N relation.


== DD S06 L01
_Incorporate at least one 1:N identifying relationship into your project, with the fact
that the transferred foreign key will also be the key in the new table (identifying relationship)._

- z_video_media.media_id is also the PK and a FK to z_media.media_id. 
  This is a strong identifying relationship: each video media must be a media
- playlist_id and video_id of table z_playlist_video are identifying
  relationships, because the combination of them is the PK of z_playlist_video table


== DD S06 L02-04
_Have your schema in first normal form - no non-atomic attributes.
In second normal form – no subkey bindings.
In third normal form - no links between secondary attributes._

#text(style: "italic", weight: "thin")[
  - Normal Form Recap
    - 1NF - no repeating groups or arrays; each attribute holds atomic (indivisible) values
    - 2NF - must be in 1NF + no partial dependency on part of a composite key (i.e., every non-key attribute must depend on the whole primary key)
    - 3NF - must be in 2NF + no transitive dependencies (i.e., non-key attributes must not depend on other non-key attributes)
]

All the tables are in 3NF, because
- all non-key attributes functionally depend only on the primary key and
- there are no transitive dependecies.

== DD S07 L01
_Try to define ARC in your project (can be defined in ORACLE SQL Developer Data
Modeler)._

The table z_playlist uses an exclusive arc between user_id and channel_id. 
Only one of them may be non-null to indicate ownership. 
This is enforced via a CHECK constraint in DDL and supported in the modeler using arcs.

#pagebreak() 

== DD S07 L02
_Try to define hierarchical and recursive relations in your project._

- z_category is hierarchical via parent_category_id (categories can nest). 
- z_comment is recursive: replies point to another comment_id (enabling threaded discussions). 
Both are actually hierarchical as well as recursive.

== DD S07 L03
_Describe how you record historical data in your system._

The system uses shadow/audit tables to preserve historical data. For example, every update to the z_comment.content or z_user is tracked in separate audit tables that store the previous and new value along with a timestamp and a reference to the original entity.

```sql
CREATE TABLE z_comment_audit (
  audit_id INTEGER PRIMARY KEY,
  comment_id INTEGER NOT NULL,
  old_content VARCHAR2(500),
  new_content VARCHAR2(500),
  change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comment_audit FOREIGN KEY (comment_id) REFERENCES z_comment(comment_id)
);

CREATE TABLE z_user_audit (
  audit_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  field_changed VARCHAR2(50),
  old_value VARCHAR2(255),
  new_value VARCHAR2(255),
  change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_audit FOREIGN KEY (user_id) REFERENCES z_user(user_id)
);
```


== DD S09 L01
_Demonstrate saving changes over time on your project._

When a tracked column such as z_user.email or z_comment.content is modified, the system logs the previous and new values (via triggers). This allows administrators or analysts to review the evolution of content or user states over time.

#pagebreak()

== DD S09 L02
_Try journaling in your project, i.e. saving past historical data (for example salary
changes, workplace changes, etc.)._

For user changes:

```sql
CREATE OR REPLACE TRIGGER trg_user_change
  BEFORE UPDATE OF status ON z_user
  FOR EACH ROW
BEGIN
  IF :OLD.email != :NEW.email THEN
    INSERT INTO z_user_audit(user_id, field_changed, old_value, new_value, change_date)
    VALUES (:OLD.user_id, 'email', :OLD.email, :NEW.email);
  END IF;

  IF :OLD.first_name != :NEW.first_name THEN
    INSERT INTO z_user_audit(user_id, field_changed, old_value, new_value, change_date)
    VALUES (:OLD.user_id, 'first_name', :OLD.first_name, :NEW.first_name);
  END IF;

  ... -- other attributes
END;
```

For comment content edits:

```sql
CREATE OR REPLACE TRIGGER trg_comment_content_change
  BEFORE UPDATE OF content ON z_comment
  FOR EACH ROW
BEGIN
  IF :OLD.content != :NEW.content THEN
    INSERT INTO z_comment_audit(comment_id, old_content, new_content, change_date)
    VALUES (:OLD.comment_id, :OLD.content, :NEW.content, CURRENT_TIMESTAMP);
  END IF;
END;
```


== DD S10 L01
_Revise your design according to conventions for the readability of your schema._

ok.

#pagebreak()

== DD S10 L02
_Generic modeling – consider, possibly describe or use a generic model of data
structures in your solution, how this approach is more advantageous compared to
traditional data structure design methods._

Generic modeling refers to the design of data structures or database schemas in
a way that is flexible, reusable, and abstracted from specific business cases.
Rather than hardcoding entities or attributes for every use case (e.g.,
product_category, video_category, blog_category), a generic model creates
unified, abstract structures that can serve many domains.

Example of domain specific non-general tables:
```sql
CREATE TABLE video_category (...);
CREATE TABLE blog_category (...);
```
In this design each use case has its own separate table.

Generic model would use something like this:
```sql
CREATE TABLE category (
  category_id INTEGER PRIMARY KEY,
  parent_category_id INTEGER REFERENCES category(category_id),
  name VARCHAR2(100)
);

CREATE TABLE entity_category (
  entity_type VARCHAR2(50),  -- e.g., 'video', 'blog'
  entity_id INTEGER,
  category_id INTEGER,
  PRIMARY KEY (entity_type, entity_id, category_id)
);
```
where entity_type may hold the name of the target table and the entity_id holds
the id of the record it refers to.

This approach is advantageous when traditional design patterns like inheritance, 
polymorhphic arcs would nessecitate creations of large amounts of 'helper' tables.
Generic modeling mitigates this problem of bloating the database model with such 'helper' tables
by allowing storing field names and table names as field values of another table.

Although this pattern is somewhat of an anti-pattern it allows for scalable and simple models.

*In the project* there is z_user_audit table that holds historical data of the z_user table.
In this table there is field_changed attribute which values are field names of the z_user table.

#pagebreak()

== DD S11 L01
_Describe examples of integrity constraints on your project for entities, bindings,
attributes, and user-defined integrity._

- *Entity constraints*
  - z_user.user_id, z_video.video_id, etc. are primary keys $->$ unique and not null
  - z_video.visibility has a CHECK constraint: must be 'draft', 'public', 'unlisted', or 'private'

- *Binding (relationship) constraints*
  - z_comment.video_id must exist in z_video (FOREIGN KEY)
  - z_subscription has a composite PK on (user_id, channel_id) to prevent duplicates


- *Attribute constraints*
  - z_user.email must be UNIQUE 
  - z_video.duration must be a positive integer
  - z_reaction.reaction_kind must be 'like' or 'dislike'

- *User-defined constraints*
  - ARC logic:
    - in z_reaction: either video_id or comment_id must be present, but not both 
    - in z_playlist, only one of user_id or channel_id can be non-null 
    - enforced via CHECK and TRIGGER

#pagebreak()

== DD S11 L02-04
_Generate a relational schema from your conceptual model and note the changes that
have occurred in the schema and why._

#figure(
  image("../assets/Relational.svg"),
  caption: [ER Diagram]
)

*Key changes from conceptual model*
- Relations are modeled by adding foreign keys to tables.
- Many to many relations are modeled by adding an associative/junction table.
- Subtype implementation in SQL using shared key rather than classical inheritance
- ARC constraints require TRIGGERS due to SQL limitations on exclusive foreign key references

#pagebreak()

== DD S15 L01
_Write query for concatenate strings by pipes || , and CONCAT(). Write query with SELECT DISTINCT._

```sql
SELECT DISTINCT first_name || ' ' || last_name AS full_name 
FROM z_user;

SELECT DISTINCT CONCAT(first_name, CONCAT(' ', last_name)) AS full_name 
FROM z_user;
```


== DD S16 L02
_Write query with WHERE condition for selecting rows and use functions LOWER, UPPER, INITCAP._

```sql
SELECT * FROM z_user
WHERE LOWER(username) = 'phatt-23';

SELECT * FROM z_user
WHERE UPPER(status) = 'ACTIVE';

SELECT * FROM z_user
WHERE INITCAP(first_name) = 'John';
```


== DD S16 L03
_Write query with BETWEEN, AND, LIKE (%, \_), IN(), IS NULL and IS NOT NULL._

```sql
SELECT * FROM z_video
WHERE duration BETWEEN 60 AND 300;

SELECT * FROM z_user
WHERE email LIKE '%.cz';

SELECT * FROM z_user
WHERE username LIKE '_ohn';

SELECT * FROM z_user
WHERE status IN ('active', 'suspended');

SELECT * FROM z_user
WHERE profile_picture_id IS NULL;

SELECT * FROM z_user
WHERE profile_picture_id IS NOT NULL;
```

#pagebreak()


== DD S17 L01
_Write query with AND, OR, NOT and precendence._

```sql
SELECT * FROM z_user
WHERE (status = 'active' AND is_deleted = '0')
   OR (status = 'suspended' AND NOT is_deleted = '1');
```


== DD S17 L02
_Write query with ORDER BY atr [ASC/DESC] - Sorting by using one or more attributes._

```sql
SELECT * FROM z_video
ORDER BY upload_date DESC;

SELECT * FROM z_video
ORDER BY visibility ASC, like_count DESC;
```


== DD S17 L03
_Write query with single row functions and column functions MIN, MAX, AVG, SUM, COUNT._

```sql
SELECT COUNT(*) AS total_users FROM z_user;

SELECT MIN(duration) AS shortest_video, MAX(duration) AS longest_video FROM z_video;

SELECT AVG(duration) AS average_duration FROM z_video;

SELECT SUM(view_count) AS total_views FROM z_video;
```



