= Database Design

== DD S01 L02
_Explain the difference between the concept of data and information._

Data are raw facts or figures without context. For example, a number like 512,
a string like 'hello world', or a timestamp like '2025-05-10 19:32:51' are all
data. Information is data that has been processed or structured in a way that
adds meaning. For instance, interpreting 512 as the duration (in seconds) of a
video uploaded on '2025-05-10 19:32:51' transforms raw data into actionable
information.


== DD S02 L02
_Entities, instances, attributes and identifiers - describe in examples on your project._

- Entity: z_user (represents a user)

- Instance: A specific record in the table. Example: A user with user_id = 1234, username = 'jdoe', email = 'john.doe\@example.com', and status = 'active'.

- Attributes: Properties of an entity. For z_user, attributes include username, email, first_name, last_name, profile_picture_id, etc.

- Identifiers: Unique attributes or combinations that distinguish one instance from another. Example: user_id is the primary key of z_user, uniquely identifying each user.


== DD S03 L01
- _Describe all relations in your database in English, including cardinality and membership obligation - each relation in two sentences._

#figure([
  #table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    align: left,
    table.header(
      [*Name*], [*Source*], [*Cardinality \ Optionality*], [*Target*]
    ),
    "Category_Has_SubCategories", "z_category", "0..* : 0..1", "z_category",
    "Channel_Has_BannerImage", "z_media_image", "0..* : 0..1", "z_channel",
    "Channel_Has_Playlists", "z_channel", "0..* : 0..1", "z_playlist",
    "Channel_Has_ProfileImage", "z_image_media", "0..* : 0..1", "z_channel",
    "Channel_Has_Subscriptions", "z_channel", "0..* : 1..1", "z_subscription",
    "Channel_Has_Videos", "z_channel", "0..* : 1..1", "z_video",
    "Comment_Has_Reaction", "z_comment", "0..* : 1..1", "z_reaction",
    "Comment_Has_SubComment", "z_comment", "0..* : 0..1", "z_comment",
    "Playlist_Has_Videos", "z_playlist", "0..* : 1..1", "z_playlist_video",
    "User_Has_Channels", "z_user", "0..* : 1..1", "z_channel",
    "User_Has_Comments", "z_user", "0..* : 1..1", "z_comment",
    "User_Has_Playlists", "z_user", "0..* : 0..1", "z_playlist",
    "User_Has_ProfileImage", "z_image_media", "0..* : 0..1", "z_user",
    "User_Has_Reactions", "z_user", "0..* : 1..1", "z_reaction",
    "User_Has_Subscriptions", "z_user", "0..* : 1..1", "z_subscription",
    "User_Has_VideoViews", "z_user", "0..* : 1..1", "z_video_view",
    "Video_Has_Comments", "z_video", "0..* : 1..1", "z_comment",
    "Video_Has_Reactions", "z_video", "0..* : 1..1", "z_reaction",
    "Video_Has_ThumbnailImage", "z_image_media", "0..1 : 1..1", "z_video",
    "Video_Has_VideoFile", "z_video_media", "0..1 : 1..1", "z_video",
    "Video_Has_VideoViews", "z_video", "0..* : 1..1", "z_video_view",
    "Video_IsIn_Playlists", "z_video", "0..* : 1..1", "z_playlist_video",
    "z_video_category", "z_video", "0..* : 0..*", "z_category"
  )
], caption: [Relations with cardinality and optionality]
)


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

#set text(size: 5pt)

#figure([
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

    [*category*],       [has subcategories],[],[],[],[], [],[],[],[],[], [categorizes videos], [],[],
    [*channel*],        [],[#align(center, [---])],[],[has banner],[references media], [creates playlists],[],[receives reactions],[has subscribers],[created by user], [has videos],[],[],
    [*comment*],        [],[],[#align(center, [---])],[],[], [],[],[receives reactions],[],[written by user], [on video], [],[],
    [*image_media*],    [],[],[],[#align(center, [---])],[references media], [],[],[],[],[used in user/channel/video], [],[],[],
    [*media*],          [],[],[],[],[#align(center, [---])], [],[],[],[],[], [],[],[],
    [*playlist*],       [],[],[],[],[], [#align(center, [---])],[contains videos],[],[],[created by user/channel], [],[],[],
    [*playlist_video*], [],[],[],[],[], [],[#align(center, [---])],[],[],[], [references video],[],[],
    [*reaction*],       [],[],[on comment],[],[], [],[],[#align(center, [---])],[],[by user], [on video],[],[],
    [*subscription*],   [],[],[],[],[], [],[],[],[#align(center, [---])],[by user],[to channel], [],[],
    [*user*],           [],[creates channels],[writes comments],[has profile picture],[], [creates playlists],[],[creates reactions],[makes subscriptions],[#align(center, [---])], [],[],[makes views],
    [*video*],          [is categorized], [belongs to channel],[has comments],[has thumbnail image],[], [],[is in playlists],[receives reactions],[],[uploaded by user], [#align(center, [---])],[has video file],[has views],
    [*video_media*],    [],[],[],[],[references media], [],[],[],[],[], [],[#align(center, [---])],[],
    [*video_view*],     [],[],[],[],[], [],[],[],[],[], [on video], [],[#align(center, [---])]

  )], caption: [Relationship Matrix])

#set text(size: 11pt)
#set page(flipped: false)


== DD S04 L01
_Supertypes and subtypes – define at least one instance of a supertype and a subtype in your project._

 The entity z_media is a generalization for all media. z_image_media and z_video_media are specializations that inherit media_id from z_media but introduce additional attributes: 
- z_image_media: width, height, format
- z_video_media: duration, resolution, codec This models shared vs. specific media characteristics.


== DD S04 L02
_Description of business rules for your project._

- *Channel Ownership:* A channel cannot be reassigned to another user post-creation (enforced by a BEFORE UPDATE trigger).
- *Reaction Targeting:* A reaction must target either a video or a comment, but never both (CHECK constraint).
- *Playlist Creator Arc:* Only one of user_id or channel_id can be set for a playlist (enforced by CHECK).
- *Soft Deletion:* Deletions are logical via is_deleted, not physical.
- *Non-Transferability:* Certain foreign keys are immutable to preserve referential integrity (enforced with triggers).
- *Data Checks* - Start time must start before end time. Video cannot have negative views.


== DD S05 L01
_Include at least one transferable and one non-transferable binding in your project._

- *Transferable Binding:* z_video.thumbnail_media_id $->$ z_image_media.media_id is portable and supports reuse of shared images.
- *Non-Transferable Binding:* z_comment.user_id is locked after creation via a BEFORE UPDATE trigger — representing a non-transferable, immutable relationship.


== DD S05 L03
_Have at least one M:N relationship without information and one M:N relationship with inf-rmation in your project._

- *Without Information:* z_video_category links videos to categories. No extra attributes.
- *With Information:* z_playlist_video includes added_date and order, which add context beyond the M:N relation.


== DD S06 L01
_Incorporate at least one 1:N identifying relationship into your project, with the fact
that the transferred foreign key will also be the key in the new table (identifying relationship)._

z_video_media.media_id is also the PK and a FK to z_media.media_id. This is a strong identifying relationship: each video media must be a media.


== DD S06 L02-04
_Have your schema in first normal form - no non-atomic attributes.
In second normal form – no subkey bindings.
In third normal form - no links between secondary attributes._

Yes. Schema is in 1NF, 2NF and 3NF.


== DD S07 L01
_Try to define ARC in your project (can be defined in ORACLE SQL Developer Data
M-deler)._

z_playlist uses an exclusive arc between user_id and channel_id. 
Only one of them may be non-null to indicate ownership. 
This is enforced via a CHECK constraint in DDL and supported in the modeler using arcs.


== DD S07 L02
_Try to define hierarchical and recursive relations in your project._

z_category is hierarchical via parent_category_id (categories can nest).
z_comment is recursive: replies point to another comment_id (enabling threaded discussions).


// Fields like edited_date (in z_comment) and reaction_date (in z_reaction) preserve the timeline of user actions.
// last_login in z_user shows temporal change per user session.
//
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

When a tracked column such as z_user.email or z_comment.content is modified, the system logs the previous and new values. This allows administrators or analysts to review the evolution of content or user states over time.


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
    VALUES (:OLD.user_id, 'email', :OLD.email, :NEW.email, CURRENT_TIMESTAMP);
  END IF;

  IF :OLD.first_name != :NEW.first_name THEN
    INSERT INTO z_user_audit(user_id, field_changed, old_value, new_value, change_date)
    VALUES (:OLD.user_id, 'first_name', :OLD.first_name, :NEW.first_name, CURRENT_TIMESTAMP);
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


== DD S10 L02
_Generic modeling – consider, possibly describe or use a generic model of data
structures in your solution, how this approach is more advantageous compared to
traditional data structure design methods._

Generic modeling introduces abstraction by designing reusable, flexible structures instead of tightly coupled entity-specific tables. This approach is particularly advantageous when dealing with heterogeneous media types and polymorphic associations.

*In the project:*
- z_media is a supertype representing a general media file. 
- Subtypes like z_image_media and z_video_media specialize it by adding specific attributes (e.g., resolution, codec, width, height). 
- This allows any table to reference z_media without needing to know whether it’s a video or image and thus avoiding duplication and simplifying integration.

*Advantages:*
- *Scalability:* New media types (e.g., audio or documents) can be added with minimal schema changes.
- *Consistency:* All media share a common identifier and storage structure.
- *Simplified Constraints:* Referential integrity and file management logic are centralized (in one table).


== DD S11 L01
_Describe examples of integrity constraints on your project for entities, bindings,
attributes, and user-defined integrity._

Integrity constraints in the project:

*Entity constraints:*
- z_user.user_id, z_video.video_id, etc. are primary keys → unique and not null.
- z_video.visibility has a CHECK constraint: must be 'draft', 'public', 'unlisted', or 'private'.

*Binding (relationship) constraints:*
- z_comment.video_id must exist in z_video (FOREIGN KEY).
- z_subscription has a composite PK on (user_id, channel_id) to prevent duplicates.

*Attribute constraints:*
- z_user.email must be UNIQUE (enforced via alternate key in practice).
- z_video.duration must be a positive integer.
- z_reaction.reaction_kind must be 'like' or 'dislike'.

*User-defined constraints:*
- ARC logic in z_reaction: either video_id or comment_id must be present, but not both (enforced via CHECK and TRIGGER).
- In z_playlist, only one of user_id or channel_id can be non-null (CHECK constraint PlaylistCreator).


== DD S11 L02-04
_Generate a relational schema from your conceptual model and note the changes that
have occurred in the schema and why._

#figure(
  image("../assets/Relational.svg"),
  caption: [ER Diagram]
)

*Key changes from conceptual model:*
- Relations are modeled by adding foreign keys to tables.
- Many to many relations are modeled by adding a associative/junction table.
- Subtype implementation in SQL using shared key rather than classical inheritance
- ARC constraints require TRIGGERS due to SQL limitations on exclusive foreign key references


== DD S15 L01
_Write query for concatenate strings by pipes || , and CONCAT(). Write query with SELECT DISTINCT._

```sql
SELECT DISTINCT first_name || ' ' || last_name AS full_name FROM z_user;

SELECT DISTINCT CONCAT(first_name, CONCAT(' ', last_name)) AS full_name FROM z_user;
```


== DD S16 L02
_Write query with WHERE condition for selecting rows and use functions LOWER, UPPER, INITCAP._

```sql
WHERE clause with string functions:

SELECT * FROM z_user
WHERE LOWER(username) = 'admin';

SELECT * FROM z_user
WHERE UPPER(status) = 'ACTIVE';

SELECT * FROM z_user
WHERE INITCAP(first_name) = 'John';
```


== DD S16 L03
_Write query with BETWEEN … AND, LIKE (%, \_), IN(), IS NULL and IS NOT NULL._

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



