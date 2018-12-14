SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `{#}con_pages`;
DROP TABLE IF EXISTS `{#}con_pages_cats`;
DROP TABLE IF EXISTS `{#}con_pages_cats_bind`;
DROP TABLE IF EXISTS `{#}con_pages_fields`;
DROP TABLE IF EXISTS `{#}con_pages_props`;
DROP TABLE IF EXISTS `{#}con_pages_props_bind`;
DROP TABLE IF EXISTS `{#}con_pages_props_values`;
DROP TABLE IF EXISTS `{#}content_datasets`;
DROP TABLE IF EXISTS `{#}content_folders`;
DROP TABLE IF EXISTS `{#}content_relations`;
DROP TABLE IF EXISTS `{#}content_relations_bind`;
DROP TABLE IF EXISTS `{#}content_types`;
DROP TABLE IF EXISTS `{#}controllers`;
DROP TABLE IF EXISTS `{#}events`;
DROP TABLE IF EXISTS `{#}images_presets`;
DROP TABLE IF EXISTS `{#}jobs`;
DROP TABLE IF EXISTS `{#}menu`;
DROP TABLE IF EXISTS `{#}menu_items`;
DROP TABLE IF EXISTS `{#}perms_rules`;
DROP TABLE IF EXISTS `{#}perms_users`;
DROP TABLE IF EXISTS `{#}scheduler_tasks`;
DROP TABLE IF EXISTS `{#}sessions_online`;
DROP TABLE IF EXISTS `{#}uploaded_files`;
DROP TABLE IF EXISTS `{#}users`;
DROP TABLE IF EXISTS `{#}users_auth_tokens`;
DROP TABLE IF EXISTS `{#}users_contacts`;
DROP TABLE IF EXISTS `{#}users_fields`;
DROP TABLE IF EXISTS `{#}users_groups`;
DROP TABLE IF EXISTS `{#}users_groups_members`;
DROP TABLE IF EXISTS `{#}users_groups_migration`;
DROP TABLE IF EXISTS `{#}users_ignors`;
DROP TABLE IF EXISTS `{#}users_personal_settings`;
DROP TABLE IF EXISTS `{#}users_tabs`;
DROP TABLE IF EXISTS `{#}widgets`;
DROP TABLE IF EXISTS `{#}widgets_bind`;
DROP TABLE IF EXISTS `{#}widgets_pages`;
CREATE TABLE `{#}con_pages`
(
  `id`                 int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`              varchar(100)              DEFAULT NULL,
  `content`            text                      DEFAULT NULL,
  `slug`               varchar(100)              DEFAULT NULL,
  `seo_keys`           varchar(256)              DEFAULT NULL,
  `seo_desc`           varchar(256)              DEFAULT NULL,
  `seo_title`          varchar(256)              DEFAULT NULL,
  `tags`               varchar(1000)             DEFAULT NULL,
  `template`           varchar(150)              DEFAULT NULL,
  `date_pub`           timestamp        NOT NULL DEFAULT current_timestamp(),
  `date_last_modified` timestamp        NULL     DEFAULT NULL,
  `date_pub_end`       timestamp        NULL     DEFAULT NULL,
  `is_pub`             tinyint(1)                DEFAULT 1,
  `hits_count`         int(11)                   DEFAULT 0,
  `user_id`            int(11) unsigned          DEFAULT NULL,
  `parent_id`          int(11) unsigned          DEFAULT NULL,
  `parent_type`        varchar(32)               DEFAULT NULL,
  `parent_title`       varchar(100)              DEFAULT NULL,
  `parent_url`         varchar(255)              DEFAULT NULL,
  `is_parent_hidden`   tinyint(1)                DEFAULT NULL,
  `category_id`        int(11) unsigned NOT NULL DEFAULT 1,
  `folder_id`          int(11) unsigned          DEFAULT NULL,
  `is_comments_on`     tinyint(1) unsigned       DEFAULT 1,
  `comments`           int(11)          NOT NULL DEFAULT 0,
  `rating`             int(11)          NOT NULL DEFAULT 0,
  `is_deleted`         tinyint(1) unsigned       DEFAULT NULL,
  `is_approved`        tinyint(1)                DEFAULT 1,
  `approved_by`        int(11)                   DEFAULT NULL,
  `date_approved`      timestamp        NULL     DEFAULT NULL,
  `is_private`         tinyint(1)       NOT NULL DEFAULT 0,
  `attach`             text                      DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `folder_id` (`folder_id`),
  KEY `slug` (`slug`),
  KEY `date_pub` (`is_pub`, `is_parent_hidden`, `is_deleted`, `is_approved`, `date_pub`),
  KEY `parent_id` (`parent_id`, `parent_type`, `date_pub`),
  KEY `user_id` (`user_id`, `date_pub`),
  KEY `date_pub_end` (`date_pub_end`),
  FULLTEXT KEY `title` (`title`)
) ENGINE = MyISAM
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_cats`
(
  `id`          int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id`   int(11) unsigned          DEFAULT NULL,
  `title`       varchar(200)              DEFAULT NULL,
  `description` text                      DEFAULT NULL,
  `slug`        varchar(255)              DEFAULT NULL,
  `slug_key`    varchar(255)              DEFAULT NULL,
  `seo_keys`    varchar(256)              DEFAULT NULL,
  `seo_desc`    varchar(256)              DEFAULT NULL,
  `seo_title`   varchar(256)              DEFAULT NULL,
  `ordering`    int(11)                   DEFAULT NULL,
  `ns_left`     int(11)                   DEFAULT NULL,
  `ns_right`    int(11)                   DEFAULT NULL,
  `ns_level`    int(11)                   DEFAULT NULL,
  `ns_differ`   varchar(32)      NOT NULL DEFAULT '',
  `ns_ignore`   tinyint(4)       NOT NULL DEFAULT 0,
  `allow_add`   text                      DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `slug` (`slug`),
  KEY `ns_left` (`ns_level`, `ns_right`, `ns_left`),
  KEY `parent_id` (`parent_id`, `ns_left`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_cats_bind`
(
  `item_id`     int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  KEY `item_id` (`item_id`),
  KEY `category_id` (`category_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_fields`
(
  `id`            int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id`      int(11)      DEFAULT NULL,
  `name`          varchar(40)  DEFAULT NULL,
  `title`         varchar(100) DEFAULT NULL,
  `hint`          varchar(200) DEFAULT NULL,
  `ordering`      int(11)      DEFAULT NULL,
  `fieldset`      varchar(32)  DEFAULT NULL,
  `type`          varchar(16)  DEFAULT NULL,
  `is_in_list`    tinyint(1)   DEFAULT NULL,
  `is_in_item`    tinyint(1)   DEFAULT NULL,
  `is_in_filter`  tinyint(1)   DEFAULT NULL,
  `is_private`    tinyint(1)   DEFAULT NULL,
  `is_fixed`      tinyint(1)   DEFAULT NULL,
  `is_fixed_type` tinyint(1)   DEFAULT NULL,
  `is_system`     tinyint(1)   DEFAULT NULL,
  `values`        text         DEFAULT NULL,
  `options`       text         DEFAULT NULL,
  `groups_read`   text         DEFAULT NULL,
  `groups_edit`   text         DEFAULT NULL,
  `filter_view`   text         DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `is_in_list` (`is_in_list`),
  KEY `is_in_item` (`is_in_item`),
  KEY `is_in_filter` (`is_in_filter`),
  KEY `is_private` (`is_private`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_system` (`is_system`),
  KEY `is_fixed_type` (`is_fixed_type`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 6
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_props`
(
  `id`           int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id`     int(11)      DEFAULT NULL,
  `title`        varchar(100) DEFAULT NULL,
  `fieldset`     varchar(32)  DEFAULT NULL,
  `type`         varchar(16)  DEFAULT NULL,
  `is_in_filter` tinyint(1)   DEFAULT NULL,
  `values`       text         DEFAULT NULL,
  `options`      text         DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_in_filter`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_props_bind`
(
  `id`       int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prop_id`  int(11) DEFAULT NULL,
  `cat_id`   int(11) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prop_id` (`prop_id`),
  KEY `ordering` (`cat_id`, `ordering`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}con_pages_props_values`
(
  `prop_id` int(11)      DEFAULT NULL,
  `item_id` int(11)      DEFAULT NULL,
  `value`   varchar(255) DEFAULT NULL,
  KEY `prop_id` (`prop_id`),
  KEY `item_id` (`item_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}content_datasets`
(
  `id`                int(11) unsigned     NOT NULL AUTO_INCREMENT,
  `ctype_id`          int(11) unsigned              DEFAULT NULL COMMENT 'Content typpe ID',
  `name`              varchar(32)          NOT NULL COMMENT 'Dataset title',
  `title`             varchar(100)         NOT NULL COMMENT 'Dataset heading',
  `description`       text                          DEFAULT NULL COMMENT 'Dataset description',
  `ordering`          int(11) unsigned              DEFAULT NULL COMMENT 'Order number',
  `is_visible`        tinyint(1) unsigned           DEFAULT NULL COMMENT 'Show dataset on site?',
  `filters`           text                          DEFAULT NULL COMMENT 'Dataset filters array',
  `sorting`           text                          DEFAULT NULL COMMENT 'Sorting rules array',
  `index`             varchar(40)                   DEFAULT NULL COMMENT 'Index title',
  `groups_view`       text                          DEFAULT NULL COMMENT 'Show to groups',
  `groups_hide`       text                          DEFAULT NULL COMMENT 'Hide from groups',
  `seo_keys`          varchar(256)                  DEFAULT NULL,
  `seo_desc`          varchar(256)                  DEFAULT NULL,
  `seo_title`         varchar(256)                  DEFAULT NULL,
  `cats_view`         text                          DEFAULT NULL COMMENT 'Show to cats',
  `cats_hide`         text                          DEFAULT NULL COMMENT 'Hide from cats',
  `max_count`         smallint(5) unsigned NOT NULL DEFAULT 0,
  `target_controller` varchar(32)                   DEFAULT NULL,
  `list`              text                          DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `ctype_id` (`ctype_id`, `ordering`),
  KEY `index` (`index`),
  KEY `target_controller` (`target_controller`, `ordering`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='Content type datasets';
CREATE TABLE `{#}content_folders`
(
  `id`       int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) unsigned DEFAULT NULL,
  `user_id`  int(11) unsigned DEFAULT NULL,
  `title`    varchar(128)     DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`, `ctype_id`, `title`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}content_relations`
(
  `id`                int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`             varchar(256)              DEFAULT NULL,
  `target_controller` varchar(32)      NOT NULL DEFAULT 'content',
  `ctype_id`          int(11) unsigned          DEFAULT NULL,
  `child_ctype_id`    int(11) unsigned          DEFAULT NULL,
  `layout`            varchar(32)               DEFAULT NULL,
  `options`           text                      DEFAULT NULL,
  `seo_keys`          varchar(256)              DEFAULT NULL,
  `seo_desc`          varchar(256)              DEFAULT NULL,
  `seo_title`         varchar(256)              DEFAULT NULL,
  `ordering`          int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ctype_id` (`ctype_id`, `ordering`),
  KEY `child_ctype_id` (`child_ctype_id`, `target_controller`, `ordering`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}content_relations_bind`
(
  `id`                int(11)     NOT NULL AUTO_INCREMENT,
  `parent_ctype_id`   int(11) unsigned     DEFAULT NULL,
  `parent_item_id`    int(11) unsigned     DEFAULT NULL,
  `child_ctype_id`    int(11) unsigned     DEFAULT NULL,
  `child_item_id`     int(11) unsigned     DEFAULT NULL,
  `target_controller` varchar(32) NOT NULL DEFAULT 'content',
  PRIMARY KEY (`id`),
  KEY `parent_ctype_id` (`parent_ctype_id`),
  KEY `child_ctype_id` (`child_ctype_id`),
  KEY `parent_item_id` (`parent_item_id`, `target_controller`),
  KEY `child_item_id` (`child_item_id`, `target_controller`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}content_types`
(
  `id`                int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`             varchar(100)     NOT NULL,
  `name`              varchar(32)      NOT NULL COMMENT 'System name',
  `description`       text                DEFAULT NULL COMMENT 'Description',
  `ordering`          int(11)             DEFAULT NULL,
  `is_date_range`     tinyint(1) unsigned DEFAULT NULL,
  `is_premod_add`     tinyint(1) unsigned DEFAULT NULL COMMENT 'Pre-moderate new content?',
  `is_premod_edit`    tinyint(1) unsigned DEFAULT NULL COMMENT 'Pre-moderate edited content',
  `is_cats`           tinyint(1) unsigned DEFAULT NULL COMMENT 'Enable categories?',
  `is_cats_recursive` tinyint(1) unsigned DEFAULT NULL COMMENT 'End-to-end view of categories?',
  `is_folders`        tinyint(1) unsigned DEFAULT NULL,
  `is_in_groups`      tinyint(1) unsigned DEFAULT NULL COMMENT 'Create in groups',
  `is_in_groups_only` tinyint(1) unsigned DEFAULT NULL COMMENT 'Create only in groups',
  `is_comments`       tinyint(1) unsigned DEFAULT NULL COMMENT 'Comments enabled?',
  `is_comments_tree`  tinyint(1) unsigned DEFAULT NULL,
  `is_rating`         tinyint(1) unsigned DEFAULT NULL COMMENT 'Allow rating?',
  `is_rating_pos`     tinyint(1) unsigned DEFAULT NULL,
  `is_tags`           tinyint(1) unsigned DEFAULT NULL,
  `is_auto_keys`      tinyint(1) unsigned DEFAULT NULL COMMENT 'Autogeneration of keywords?',
  `is_auto_desc`      tinyint(1) unsigned DEFAULT NULL COMMENT 'Autogeneration of description?',
  `is_auto_url`       tinyint(1) unsigned DEFAULT NULL COMMENT 'Generate URL from title?',
  `is_fixed_url`      tinyint(1) unsigned DEFAULT NULL COMMENT 'Do not change URL when editing an item?',
  `url_pattern`       varchar(255)        DEFAULT '{id}-{title}',
  `options`           text                DEFAULT NULL COMMENT 'Options array',
  `labels`            text                DEFAULT NULL COMMENT 'Labels array',
  `seo_keys`          varchar(256)        DEFAULT NULL COMMENT 'Keywords',
  `seo_desc`          varchar(256)        DEFAULT NULL COMMENT 'Description',
  `seo_title`         varchar(256)        DEFAULT NULL,
  `item_append_html`  text                DEFAULT NULL,
  `is_fixed`          tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ordering` (`ordering`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 8
  DEFAULT CHARSET = utf8 COMMENT ='Content types';
CREATE TABLE `{#}controllers`
(
  `id`          int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`       varchar(64)      NOT NULL,
  `name`        varchar(32)      NOT NULL COMMENT 'System name',
  `slug`        varchar(64)         DEFAULT NULL,
  `is_enabled`  tinyint(1) unsigned DEFAULT 1 COMMENT 'Enabled?',
  `options`     text                DEFAULT NULL COMMENT 'Settings array',
  `author`      varchar(128)     NOT NULL COMMENT 'Author name',
  `url`         varchar(250)        DEFAULT NULL COMMENT 'Author site',
  `version`     varchar(8)       NOT NULL COMMENT 'Version',
  `is_backend`  tinyint(1) unsigned DEFAULT NULL COMMENT 'Admin panel?',
  `is_external` tinyint(1) unsigned DEFAULT NULL COMMENT 'Third-party component',
  `files`       text                DEFAULT NULL COMMENT 'Controller files list (for third-party components)',
  `addon_id`    int(11) unsigned    DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 23
  DEFAULT CHARSET = utf8 COMMENT ='Components';
CREATE TABLE `{#}events`
(
  `id`         int(11) unsigned NOT NULL AUTO_INCREMENT,
  `event`      varchar(64)         DEFAULT NULL COMMENT 'Event',
  `listener`   varchar(32)         DEFAULT NULL COMMENT 'Listener (component)',
  `ordering`   int(5) unsigned     DEFAULT NULL COMMENT 'Order number',
  `is_enabled` tinyint(1) unsigned DEFAULT 1 COMMENT 'Activity`',
  PRIMARY KEY (`id`),
  KEY `hook` (`event`),
  KEY `listener` (`listener`),
  KEY `is_enabled` (`is_enabled`, `ordering`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 153
  DEFAULT CHARSET = utf8 COMMENT ='Binding hooks to events';
CREATE TABLE `{#}images_presets`
(
  `id`           int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name`         varchar(32)               DEFAULT NULL,
  `title`        varchar(128)              DEFAULT NULL,
  `width`        int(11) unsigned          DEFAULT NULL,
  `height`       int(11) unsigned          DEFAULT NULL,
  `is_square`    tinyint(1) unsigned       DEFAULT NULL,
  `is_watermark` tinyint(1) unsigned       DEFAULT NULL,
  `wm_image`     text                      DEFAULT NULL,
  `wm_origin`    varchar(16)               DEFAULT NULL,
  `wm_margin`    int(11) unsigned          DEFAULT NULL,
  `is_internal`  tinyint(1) unsigned       DEFAULT NULL,
  `quality`      tinyint(1)       NOT NULL DEFAULT 90,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_square` (`is_square`),
  KEY `is_watermark` (`is_watermark`),
  KEY `is_internal` (`is_internal`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 8
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}jobs`
(
  `id`           bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue`        varchar(100)                 DEFAULT NULL COMMENT 'Queue Name',
  `payload`      text                         DEFAULT NULL COMMENT 'Job data',
  `last_error`   varchar(200)                 DEFAULT NULL COMMENT 'Last Error',
  `priority`     tinyint(1) unsigned          DEFAULT 1 COMMENT 'A priority',
  `attempts`     tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Attempts',
  `is_locked`    tinyint(1) unsigned          DEFAULT NULL COMMENT 'Lock simultaneous run',
  `date_created` timestamp           NOT NULL DEFAULT current_timestamp() COMMENT 'Queued date',
  `date_started` timestamp           NULL     DEFAULT NULL COMMENT 'Date of the last attempt to complete the task',
  PRIMARY KEY (`id`),
  KEY `queue` (`queue`),
  KEY `attempts` (`attempts`, `is_locked`, `date_started`, `priority`, `date_created`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='Queue';
CREATE TABLE `{#}menu`
(
  `id`       int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name`     varchar(32)      NOT NULL COMMENT 'System name',
  `title`    varchar(64)         DEFAULT NULL COMMENT 'Menu title',
  `is_fixed` tinyint(1) unsigned DEFAULT NULL COMMENT 'Forbidden to delete?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 7
  DEFAULT CHARSET = utf8 COMMENT ='Site menu';
CREATE TABLE `{#}menu_items`
(
  `id`          int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_id`     int(11) unsigned    DEFAULT NULL COMMENT 'Menu ID',
  `parent_id`   int(11) unsigned    DEFAULT 0 COMMENT 'Parent item ID',
  `is_enabled`  tinyint(1) unsigned DEFAULT 1 COMMENT 'Is enabled?',
  `title`       varchar(64)         DEFAULT NULL COMMENT 'Item title',
  `url`         varchar(255)        DEFAULT NULL COMMENT 'URL',
  `ordering`    int(11) unsigned    DEFAULT NULL COMMENT 'Order number',
  `options`     text                DEFAULT NULL COMMENT 'Options array',
  `groups_view` text                DEFAULT NULL COMMENT 'Allowed user groups array',
  `groups_hide` text                DEFAULT NULL COMMENT 'Disallowed user groups array',
  PRIMARY KEY (`id`),
  KEY `menu_id` (`menu_id`),
  KEY `parent_id` (`parent_id`),
  KEY `ordering` (`ordering`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 44
  DEFAULT CHARSET = utf8 COMMENT ='Menu items';
CREATE TABLE `{#}perms_rules`
(
  `id`                   int(11) unsigned              NOT NULL AUTO_INCREMENT,
  `controller`           varchar(32)                            DEFAULT NULL COMMENT 'Component (owner)',
  `name`                 varchar(32)                   NOT NULL COMMENT 'Rule title',
  `type`                 enum ('flag','list','number') NOT NULL DEFAULT 'flag' COMMENT 'Selection type (flag,list...)',
  `options`              varchar(128)                           DEFAULT NULL COMMENT 'An array of possible values',
  `show_for_guest_group` tinyint(1)                             DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `controller` (`controller`),
  KEY `name` (`name`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 47
  DEFAULT CHARSET = utf8 COMMENT ='A list of all available permission rules';
CREATE TABLE `{#}perms_users`
(
  `rule_id`  int(11) unsigned DEFAULT NULL COMMENT 'Rule ID',
  `group_id` int(11) unsigned DEFAULT NULL COMMENT 'Group ID',
  `subject`  varchar(32)      DEFAULT NULL COMMENT 'Rule subject',
  `value`    varchar(16) NOT NULL COMMENT 'Rule value',
  KEY `rule_id` (`rule_id`),
  KEY `group_id` (`group_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='Binding permission rules to user groups';
CREATE TABLE `{#}scheduler_tasks`
(
  `id`               int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`            varchar(250)          DEFAULT NULL,
  `controller`       varchar(32)           DEFAULT NULL,
  `hook`             varchar(32)           DEFAULT NULL,
  `period`           int(11) unsigned      DEFAULT NULL,
  `is_strict_period` tinyint(1) unsigned   DEFAULT NULL,
  `date_last_run`    timestamp        NULL DEFAULT NULL,
  `is_active`        tinyint(1) unsigned   DEFAULT NULL,
  `is_new`           tinyint(1) unsigned   DEFAULT 1,
  `consistent_run`   tinyint(1) unsigned   DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `period` (`period`),
  KEY `date_last_run` (`date_last_run`),
  KEY `is_active` (`is_active`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 10
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}sessions_online`
(
  `user_id`      int(11) unsigned   DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `date_created` (`date_created`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}uploaded_files`
(
  `id`                int(11) unsigned                      NOT NULL AUTO_INCREMENT,
  `path`              varchar(255)                                   DEFAULT NULL COMMENT 'File path',
  `name`              varchar(255)                                   DEFAULT NULL COMMENT 'File name',
  `size`              int(11) unsigned                               DEFAULT NULL COMMENT 'File size',
  `counter`           int(11) unsigned                      NOT NULL DEFAULT 0 COMMENT 'Download counter',
  `type`              enum ('file','image','audio','video') NOT NULL DEFAULT 'file' COMMENT 'File type',
  `target_controller` varchar(32)                                    DEFAULT NULL COMMENT 'Controller',
  `target_subject`    varchar(32)                                    DEFAULT NULL COMMENT 'Subject',
  `target_id`         int(11) unsigned                               DEFAULT NULL COMMENT 'Subject ID',
  `user_id`           int(11) unsigned                               DEFAULT NULL COMMENT 'Owner ID',
  `date_add`          timestamp                             NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `path` (`path`),
  KEY `user_id` (`user_id`),
  KEY `target_controller` (`target_controller`, `target_subject`, `target_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}users`
(
  `id`                int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groups`            text                      DEFAULT NULL COMMENT 'User groups array',
  `email`             varchar(100)     NOT NULL,
  `password`          varchar(100)     NOT NULL COMMENT 'Password hash',
  `password_salt`     varchar(16)               DEFAULT NULL COMMENT 'Password salt',
  `is_admin`          tinyint(1) unsigned       DEFAULT NULL COMMENT 'Administrator?',
  `nickname`          varchar(100)     NOT NULL COMMENT 'Name',
  `date_reg`          timestamp        NULL     DEFAULT NULL COMMENT 'Sign up date',
  `date_log`          timestamp        NULL     DEFAULT NULL COMMENT 'Last log in',
  `date_group`        timestamp        NOT NULL DEFAULT current_timestamp() COMMENT 'Last group change date',
  `ip`                varchar(45)               DEFAULT NULL,
  `is_deleted`        tinyint(1) unsigned       DEFAULT NULL COMMENT 'Deleted',
  `is_locked`         tinyint(1) unsigned       DEFAULT NULL COMMENT 'Blocked',
  `lock_until`        timestamp        NULL     DEFAULT NULL COMMENT 'Blocked till',
  `lock_reason`       varchar(250)              DEFAULT NULL COMMENT 'Blocking reason',
  `pass_token`        varchar(32)               DEFAULT NULL COMMENT 'Password recovery key',
  `date_token`        timestamp        NULL     DEFAULT NULL COMMENT 'Password recovery key creation date',
  `friends_count`     int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Number of friends',
  `subscribers_count` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Subscribers count',
  `time_zone`         varchar(32)               DEFAULT NULL COMMENT 'Time zone',
  `karma`             int(11)          NOT NULL DEFAULT 0 COMMENT 'Reputation',
  `rating`            int(11)          NOT NULL DEFAULT 0 COMMENT 'Rating',
  `theme`             text                      DEFAULT NULL COMMENT 'Profile theme settings',
  `notify_options`    text                      DEFAULT NULL COMMENT 'Notification settings',
  `privacy_options`   text                      DEFAULT NULL COMMENT 'Privacy settings',
  `status_id`         int(11) unsigned          DEFAULT NULL COMMENT 'Text status',
  `status_text`       varchar(140)              DEFAULT NULL COMMENT 'Status text',
  `inviter_id`        int(11) unsigned          DEFAULT NULL,
  `invites_count`     int(11) unsigned NOT NULL DEFAULT 0,
  `date_invites`      timestamp        NULL     DEFAULT NULL,
  `birth_date`        datetime                  DEFAULT NULL,
  `city`              int(11) unsigned          DEFAULT NULL,
  `city_cache`        varchar(128)              DEFAULT NULL,
  `hobby`             text                      DEFAULT NULL,
  `avatar`            text                      DEFAULT NULL,
  `icq`               varchar(255)              DEFAULT NULL,
  `skype`             varchar(255)              DEFAULT NULL,
  `phone`             varchar(255)              DEFAULT NULL,
  `music`             varchar(255)              DEFAULT NULL,
  `movies`            varchar(255)              DEFAULT NULL,
  `site`              text                      DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `pass_token` (`pass_token`),
  KEY `birth_date` (`birth_date`),
  KEY `city` (`city`),
  KEY `is_admin` (`is_admin`),
  KEY `friends_count` (`friends_count`),
  KEY `karma` (`karma`),
  KEY `rating` (`rating`),
  KEY `is_locked` (`is_locked`),
  KEY `date_reg` (`date_reg`),
  KEY `date_log` (`date_log`),
  KEY `date_group` (`date_group`),
  KEY `inviter_id` (`inviter_id`),
  KEY `date_invites` (`date_invites`),
  KEY `ip` (`ip`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='Users';
CREATE TABLE `{#}users_auth_tokens`
(
  `id`          int(11) unsigned NOT NULL AUTO_INCREMENT,
  `auth_token`  varchar(32)           DEFAULT NULL,
  `date_auth`   timestamp        NULL DEFAULT current_timestamp(),
  `date_log`    timestamp        NULL DEFAULT NULL,
  `user_id`     int(11) unsigned      DEFAULT NULL,
  `access_type` varchar(100)          DEFAULT NULL,
  `ip`          int(10) unsigned      DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_token` (`auth_token`),
  KEY `user_id` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}users_contacts`
(
  `id`            int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id`       int(11) unsigned          DEFAULT NULL COMMENT 'User ID',
  `contact_id`    int(11) unsigned          DEFAULT NULL COMMENT 'Contact (other user) ID',
  `date_last_msg` timestamp        NULL     DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Last message date',
  `messages`      int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Messages count',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`, `contact_id`),
  KEY `contact_id` (`contact_id`, `user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='User contacts';
CREATE TABLE `{#}users_fields`
(
  `id`            int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id`      int(11) unsigned    DEFAULT NULL,
  `name`          varchar(20)         DEFAULT NULL,
  `title`         varchar(100)        DEFAULT NULL,
  `hint`          varchar(200)        DEFAULT NULL,
  `ordering`      int(11) unsigned    DEFAULT NULL,
  `fieldset`      varchar(32)         DEFAULT NULL,
  `type`          varchar(16)         DEFAULT NULL,
  `is_in_list`    tinyint(1) unsigned DEFAULT NULL,
  `is_in_item`    tinyint(1) unsigned DEFAULT NULL,
  `is_in_filter`  tinyint(1) unsigned DEFAULT NULL,
  `is_private`    tinyint(1) unsigned DEFAULT NULL,
  `is_fixed`      tinyint(1) unsigned DEFAULT NULL,
  `is_fixed_type` tinyint(1) unsigned DEFAULT NULL,
  `is_system`     tinyint(1) unsigned DEFAULT NULL,
  `values`        text                DEFAULT NULL,
  `options`       text                DEFAULT NULL,
  `groups_read`   text                DEFAULT NULL,
  `groups_edit`   text                DEFAULT NULL,
  `filter_view`   text                DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `is_in_list` (`is_in_list`),
  KEY `is_in_item` (`is_in_item`),
  KEY `is_in_filter` (`is_in_filter`),
  KEY `is_private` (`is_private`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_system` (`is_system`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 13
  DEFAULT CHARSET = utf8 COMMENT ='User profile fields';
CREATE TABLE `{#}users_groups`
(
  `id`        int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name`      varchar(32)      NOT NULL COMMENT 'System name',
  `title`     varchar(32)      NOT NULL COMMENT 'Group title',
  `is_fixed`  tinyint(1) unsigned DEFAULT NULL COMMENT 'System?',
  `is_public` tinyint(1) unsigned DEFAULT NULL COMMENT 'Choose group upon registration?',
  `is_filter` tinyint(1) unsigned DEFAULT NULL COMMENT 'Show group in the user filter?',
  PRIMARY KEY (`id`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_public` (`is_public`),
  KEY `is_filter` (`is_filter`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 7
  DEFAULT CHARSET = utf8 COMMENT ='User groups';
CREATE TABLE `{#}users_groups_members`
(
  `user_id`  int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT ='Binding users to groups';
CREATE TABLE `{#}users_groups_migration`
(
  `id`            int(11) unsigned NOT NULL AUTO_INCREMENT,
  `is_active`     tinyint(1) unsigned DEFAULT NULL,
  `title`         varchar(256)        DEFAULT NULL,
  `group_from_id` int(11) unsigned    DEFAULT NULL,
  `group_to_id`   int(11) unsigned    DEFAULT NULL,
  `is_keep_group` tinyint(1) unsigned DEFAULT NULL,
  `is_passed`     tinyint(1) unsigned DEFAULT NULL,
  `is_rating`     tinyint(1) unsigned DEFAULT NULL,
  `is_karma`      tinyint(1) unsigned DEFAULT NULL,
  `passed_days`   int(11) unsigned    DEFAULT NULL,
  `passed_from`   tinyint(1) unsigned DEFAULT NULL,
  `rating`        int(11)             DEFAULT NULL,
  `karma`         int(11)             DEFAULT NULL,
  `is_notify`     tinyint(1) unsigned DEFAULT NULL,
  `notify_text`   text                DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_from_id` (`group_from_id`),
  KEY `group_to_id` (`group_to_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8 COMMENT ='Migration rules between groups';
CREATE TABLE `{#}users_ignors`
(
  `id`              int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id`         int(11) unsigned NOT NULL COMMENT 'User ID',
  `ignored_user_id` int(11) unsigned NOT NULL COMMENT 'Ignored user ID',
  PRIMARY KEY (`id`),
  KEY `ignored_user_id` (`ignored_user_id`, `user_id`),
  KEY `user_id` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}users_personal_settings`
(
  `id`       int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id`  int(11) unsigned NOT NULL,
  `skey`     varchar(150) DEFAULT NULL,
  `settings` text         DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`, `skey`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}users_tabs`
(
  `id`              int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title`           varchar(32)         DEFAULT NULL,
  `controller`      varchar(32)         DEFAULT NULL,
  `name`            varchar(32)         DEFAULT NULL,
  `is_active`       tinyint(1) unsigned DEFAULT NULL,
  `ordering`        int(11) unsigned    DEFAULT NULL,
  `groups_view`     text                DEFAULT NULL,
  `groups_hide`     text                DEFAULT NULL,
  `show_only_owner` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_active` (`is_active`, `ordering`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 9
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}widgets`
(
  `id`          int(11) unsigned NOT NULL AUTO_INCREMENT,
  `controller`  varchar(32)      DEFAULT NULL COMMENT 'Controler',
  `name`        varchar(32)      NOT NULL COMMENT 'System name',
  `title`       varchar(64)      DEFAULT NULL COMMENT 'Title',
  `author`      varchar(128)     DEFAULT NULL COMMENT 'Author name',
  `url`         varchar(250)     DEFAULT NULL COMMENT 'Author site',
  `version`     varchar(8)       DEFAULT NULL COMMENT 'Version',
  `is_external` tinyint(1)       DEFAULT 1,
  `files`       text             DEFAULT NULL COMMENT 'List of widget files (for third-party widgets)',
  `addon_id`    int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `version` (`version`),
  KEY `name` (`name`),
  KEY `controller` (`controller`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 20
  DEFAULT CHARSET = utf8;
CREATE TABLE `{#}widgets_bind`
(
  `id`               int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template`         varchar(30)         DEFAULT NULL COMMENT 'Template binding',
  `template_layouts` varchar(500)        DEFAULT NULL,
  `languages`        varchar(100)        DEFAULT NULL,
  `widget_id`        int(11) unsigned NOT NULL,
  `title`            varchar(128)     NOT NULL COMMENT 'Title',
  `links`            text                DEFAULT NULL,
  `class`            varchar(64)         DEFAULT NULL COMMENT 'CSS class',
  `class_title`      varchar(64)         DEFAULT NULL,
  `class_wrap`       varchar(64)         DEFAULT NULL,
  `is_title`         tinyint(1) unsigned DEFAULT 1 COMMENT 'Show title',
  `is_enabled`       tinyint(1) unsigned DEFAULT NULL COMMENT 'Enabled?',
  `is_tab_prev`      tinyint(1) unsigned DEFAULT NULL COMMENT 'Group with the previous?',
  `groups_view`      text                DEFAULT NULL COMMENT 'Show to groups',
  `groups_hide`      text                DEFAULT NULL COMMENT 'Do not show to groups',
  `options`          text                DEFAULT NULL COMMENT 'Options',
  `page_id`          int(11) unsigned    DEFAULT NULL COMMENT 'Page ID',
  `position`         varchar(32)         DEFAULT NULL COMMENT 'Position title ',
  `ordering`         int(11) unsigned    DEFAULT NULL COMMENT 'Order number',
  `tpl_body`         varchar(128)        DEFAULT NULL,
  `tpl_wrap`         varchar(128)        DEFAULT NULL,
  `device_types`     varchar(50)         DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `position` (`position`),
  KEY `widget_id` (`widget_id`),
  KEY `page_id` (`page_id`, `position`, `ordering`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 24
  DEFAULT CHARSET = utf8 COMMENT ='Site widgets';
CREATE TABLE `{#}widgets_pages`
(
  `id`            int(11) unsigned NOT NULL AUTO_INCREMENT,
  `controller`    varchar(32) DEFAULT NULL COMMENT 'Component',
  `name`          varchar(64) DEFAULT NULL COMMENT 'System name',
  `title_const`   varchar(64) DEFAULT NULL COMMENT 'Page title (language constant)',
  `title_subject` varchar(64) DEFAULT NULL COMMENT 'Subject title (transferred to the language constant)',
  `title`         varchar(64) DEFAULT NULL,
  `url_mask`      text        DEFAULT NULL COMMENT 'URL mask',
  `url_mask_not`  text        DEFAULT NULL COMMENT 'Negative mask',
  `groups`        text        DEFAULT NULL COMMENT 'Access groups',
  `countries`     text        DEFAULT NULL COMMENT 'Access countries',
  PRIMARY KEY (`id`),
  KEY `controller` (`controller`),
  KEY `name` (`name`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 201
  DEFAULT CHARSET = utf8;
BEGIN;
LOCK TABLES `{#}con_pages` WRITE;
DELETE
FROM `{#}con_pages`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_cats` WRITE;
DELETE
FROM `{#}con_pages_cats`;
INSERT INTO `{#}con_pages_cats` (`id`, `parent_id`, `title`, `description`, `slug`, `slug_key`, `seo_keys`, `seo_desc`, `seo_title`, `ordering`, `ns_left`, `ns_right`, `ns_level`,
                                                  `ns_differ`, `ns_ignore`, `allow_add`)
VALUES (1, 0, '---', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 0, '', 0, NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_cats_bind` WRITE;
DELETE
FROM `{#}con_pages_cats_bind`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_fields` WRITE;
DELETE
FROM `{#}con_pages_fields`;
INSERT INTO `{#}con_pages_fields` (`id`, `ctype_id`, `name`, `title`, `hint`, `ordering`, `fieldset`, `type`, `is_in_list`, `is_in_item`, `is_in_filter`, `is_private`, `is_fixed`,
                                                    `is_fixed_type`, `is_system`, `values`, `options`, `groups_read`, `groups_edit`, `filter_view`)
VALUES (1, 1, 'title', 'Title', NULL, 1, NULL, 'caption', 1, 1, 1, NULL, 1, 1, NULL, NULL,
        '---\nlabel_in_list: none\nlabel_in_item: none\nis_required: 1\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (2, 1, 'date_pub', 'Publication date', NULL, 2, NULL, 'date', NULL, NULL, NULL, NULL, 1, NULL, 1, NULL,
        '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n',
        NULL),
       (3, 1, 'user', 'Author', NULL, 3, NULL, 'user', NULL, NULL, NULL, NULL, 1, NULL, 1, NULL,
        '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n',
        NULL),
       (4, 1, 'content', 'Page content', NULL, 4, NULL, 'html', NULL, 1, NULL, NULL, 1, NULL, NULL, NULL,
        '---\neditor: redactor\nis_html_filter: null\nteaser_len:\nlabel_in_list: none\nlabel_in_item: none\nis_required: 1\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n',
        '---\n- 0\n', '---\n- 0\n', NULL),
       (5, 1, 'attach', 'Download', 'Attach a file to the page', 5, NULL, 'file', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nshow_name: 0\nextensions: jpg, gif, png\nmax_size_mb: 2\nshow_size: 1\nlabel_in_list: none\nlabel_in_item: none\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n',
        '---\n- 0\n', '---\n- 0\n', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_props` WRITE;
DELETE
FROM `{#}con_pages_props`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_props_bind` WRITE;
DELETE
FROM `{#}con_pages_props_bind`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}con_pages_props_values` WRITE;
DELETE
FROM `{#}con_pages_props_values`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}content_datasets` WRITE;
DELETE
FROM `{#}content_datasets`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}content_folders` WRITE;
DELETE
FROM `{#}content_folders`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}content_relations` WRITE;
DELETE
FROM `{#}content_relations`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}content_relations_bind` WRITE;
DELETE
FROM `{#}content_relations_bind`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}content_types` WRITE;
DELETE
FROM `{#}content_types`;
INSERT INTO `{#}content_types` (`id`, `title`, `name`, `description`, `ordering`, `is_date_range`, `is_premod_add`, `is_premod_edit`, `is_cats`, `is_cats_recursive`, `is_folders`,
                                                 `is_in_groups`, `is_in_groups_only`, `is_comments`, `is_comments_tree`, `is_rating`, `is_rating_pos`, `is_tags`, `is_auto_keys`, `is_auto_desc`,
                                                 `is_auto_url`, `is_fixed_url`, `url_pattern`, `options`, `labels`, `seo_keys`, `seo_desc`, `seo_title`, `item_append_html`, `is_fixed`)
VALUES (1, 'Pages', 'pages', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, '{id}-{title}',
        '---\nis_cats_change: null\nis_cats_open_root: null\nis_cats_only_last: null\nis_show_cats: null\nis_tags_in_list: null\nis_tags_in_item: null\nis_rss: null\nlist_on: null\nprofile_on: null\nlist_show_filter: null\nlist_expand_filter: null\nlist_style:\nitem_on: 1\nis_cats_keys: null\nis_cats_desc: null\nis_cats_auto_url: 1\n',
        '---\none: page\ntwo: pages\nmany: pages\ncreate: page\nlist:\nprofile:\n', NULL, NULL, NULL, NULL, 1);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}controllers` WRITE;
DELETE
FROM `{#}controllers`;
INSERT INTO `{#}controllers` (`id`, `title`, `name`, `slug`, `is_enabled`, `options`, `author`, `url`, `version`, `is_backend`, `is_external`, `files`, `addon_id`)
VALUES (1, 'Control Panel', 'admin', NULL, 1, NULL, 'InstantCMS Team', 'https://instantcms.ru', '2.0', 0, NULL, NULL, NULL),
       (2, 'Content', 'content', NULL, 1, NULL, 'InstantCMS Team', 'https://instantcms.ru', '2.0', 0, NULL, NULL, NULL),
       (3, 'User Profiles', 'users', NULL, 1,
        '---\nis_ds_online: 1\nis_ds_rating: 1\nis_ds_popular: 1\nis_filter: 1\nis_auth_only: null\nis_status: 1\nis_wall: 1\nis_themes_on: 1\nmax_tabs: 6\nis_friends_on: 1\nis_karma_comments: 1\nkarma_time: 30\n',
        'InstantCMS Team', 'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL),
       (6, 'Authorization & Registration', 'auth', NULL, 1,
        '---\nis_reg_enabled: 1\nreg_reason: >\n  We apologize, but,\n  we do not accept\n  new users at the moment\nis_reg_invites: null\nreg_captcha: 1\nverify_email: null\nverify_exp: 48\nauth_captcha: 0\nrestricted_emails: |\n  *@shitmail.me\r\n  *@mailspeed.ru\r\n  *@temp-mail.ru\r\n  *@guerrillamail.com\r\n  *@12minutemail.com\r\n  *@mytempemail.com\r\n  *@spamobox.com\r\n  *@disposableinbox.com\r\n  *@filzmail.com\r\n  *@freemail.ms\r\n  *@anonymbox.com\r\n  *@lroid.com\r\n  *@yopmail.com\r\n  *@TempEmail.net\r\n  *@spambog.com\r\n  *@mailforspam.com\r\n  *@spam.su\r\n  *@no-spam.ws\r\n  *@mailinator.com\r\n  *@spamavert.com\r\n  *@trashcanmail.com\nrestricted_names: |\n  admin*\r\n  admin*\r\n  moderator\r\n  moderator\nrestricted_ips:\nis_invites: 1\nis_invites_strict: 1\ninvites_period: 7\ninvites_qty: 3\ninvites_min_karma: 0\ninvites_min_rating: 0\ninvites_min_days: 0\nreg_auto_auth: 1\nfirst_auth_redirect: profileedit\nauth_redirect: none\n',
        'InstantCMS Team', 'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL),
       (12, 'reCAPTCHA', 'recaptcha', NULL, 1, '---\npublic_key:\nprivate_key:\ntheme: light\nlang: en\nsize: normal\n', 'InstantCMS Team', 'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL),
       (17, 'Search', 'search', NULL, 1, '---\nctypes:\n  - articles\n  - posts\n  - albums\n  - board\n  - news\nperpage: 15\n', 'InstantCMS Team', 'https://instantcms.ru', '2.0', 1, NULL, NULL,
        NULL),
       (19, 'Image Upload', 'images', NULL, 1, NULL, 'InstantCMS Team', 'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL),
       (20, 'Redirects', 'redirect', NULL, 1, '---\nno_redirect_list:\nblack_list:\nis_check_link: null\nwhite_list:\nredirect_time: 10\nis_check_refer: null\n', 'InstantCMS Team',
        'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL),
       (21, 'Geobase', 'geo', NULL, 1,
        '---\nauto_detect: 1\nauto_detect_provider: ipgeobase\ndefault_country_id: null\ndefault_country_id_cache: null\ndefault_region_id: null\ndefault_region_id_cache: null\n', 'InstantCMS Team',
        'https://instantcms.ru', '2.0', 1, NULL, NULL, NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}events` WRITE;
DELETE
FROM `{#}events`;
INSERT INTO `{#}events` (`id`, `event`, `listener`, `ordering`, `is_enabled`)
VALUES (7, 'menu_admin', 'admin', 7, 1),
       (8, 'user_login', 'admin', 8, 1),
       (9, 'admin_confirm_login', 'admin', 9, 1),
       (10, 'user_profile_update', 'auth', 10, 1),
       (11, 'frontpage', 'auth', 11, 1),
       (12, 'page_is_allowed', 'auth', 12, 1),
       (13, 'frontpage_types', 'auth', 13, 1),
       (23, 'fulltext_search', 'content', 23, 1),
       (24, 'admin_dashboard_chart', 'content', 24, 1),
       (25, 'menu_content', 'content', 25, 1),
       (26, 'user_delete', 'content', 26, 1),
       (27, 'user_privacy_types', 'content', 27, 1),
       (32, 'frontpage', 'content', 32, 1),
       (33, 'frontpage_types', 'content', 33, 1),
       (34, 'ctype_relation_childs', 'content', 34, 1),
       (35, 'admin_content_dataset_fields_list', 'content', 35, 1),
       (37, 'ctype_lists_context', 'content', 37, 1),
       (38, 'ctype_after_update', 'frontpage', 38, 1),
       (39, 'ctype_after_delete', 'frontpage', 39, 1),
       (62, 'user_delete', 'images', 62, 1),
       (85, 'captcha_html', 'recaptcha', 85, 1),
       (86, 'captcha_validate', 'recaptcha', 86, 1),
       (96, 'content_before_list', 'search', 96, 1),
       (97, 'content_before_item', 'search', 97, 1),
       (98, 'before_print_head', 'search', 98, 1),
       (99, 'html_filter', 'typograph', 99, 1),
       (100, 'admin_dashboard_chart', 'users', 100, 1),
       (101, 'menu_users', 'users', 101, 1),
       (104, 'user_privacy_types', 'users', 104, 1),
       (105, 'user_tab_info', 'users', 105, 1),
       (106, 'auth_login', 'users', 106, 1),
       (107, 'user_loaded', 'users', 107, 1),
       (111, 'content_privacy_types', 'users', 111, 1),
       (112, 'content_view_hidden', 'users', 112, 1),
       (114, 'content_before_childs', 'users', 114, 1),
       (115, 'ctype_relation_childs', 'users', 115, 1),
       (119, 'page_is_allowed', 'widgets', 119, 1),
       (140, 'admin_dashboard_block', 'users', 140, 1),
       (151, 'images_before_upload', 'typograph', 151, 1),
       (152, 'engine_start', 'content', 152, 1);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}images_presets` WRITE;
DELETE
FROM `{#}images_presets`;
INSERT INTO `{#}images_presets` (`id`, `name`, `title`, `width`, `height`, `is_square`, `is_watermark`, `wm_image`, `wm_origin`, `wm_margin`, `is_internal`, `quality`)
VALUES (1, 'micro', 'Micro', 32, 32, 1, NULL, NULL, NULL, NULL, NULL, 75),
       (2, 'small', 'Small', 64, 64, 1, NULL, NULL, NULL, NULL, NULL, 80),
       (3, 'normal', 'Medium', NULL, 256, NULL, NULL, NULL, NULL, NULL, NULL, 85),
       (4, 'big', 'Big', 690, 690, NULL, NULL, NULL, 'bottom-right', NULL, NULL, 90),
       (5, 'wysiwyg_markitup', 'Editor: markItUp!', 400, 400, NULL, NULL, NULL, 'top-left', NULL, 1, 85),
       (6, 'wysiwyg_redactor', 'Editor: Redactor', 800, 800, NULL, NULL, NULL, 'top-left', NULL, 1, 90),
       (7, 'wysiwyg_live', 'Editor: Live', 690, 690, NULL, NULL, NULL, 'top-left', NULL, 1, 90);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}jobs` WRITE;
DELETE
FROM `{#}jobs`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}menu` WRITE;
DELETE
FROM `{#}menu`;
INSERT INTO `{#}menu` (`id`, `name`, `title`, `is_fixed`)
VALUES (1, 'main', 'Main menu', 1),
       (2, 'personal', 'Personal Menu', 1),
       (4, 'toolbar', 'Actions menu', 1),
       (5, 'header', 'Header menu', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}menu_items` WRITE;
DELETE
FROM `{#}menu_items`;
INSERT INTO `{#}menu_items` (`id`, `menu_id`, `parent_id`, `is_enabled`, `title`, `url`, `ordering`, `options`, `groups_view`, `groups_hide`)
VALUES (13, 2, 0, 1, 'My profile', 'users/{user.id}', 1, '---\ntarget: _self\nclass: profile', '---\n- 0\n', NULL),
       (24, 2, 0, 1, 'Add', '{content:add}', 6, '---\ntarget: _self\nclass: add', '---\n- 0\n', NULL),
       (25, 2, 0, 1, 'Control panel', '{admin:menu}', 7, '---\ntarget: _self\nclass: cpanel', '---\n- 6\n', NULL),
       (29, 1, 0, 1, 'Users', 'users', 8, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
       (34, 5, 0, 1, 'Log in', 'auth/login', 9, '---\ntarget: _self\nclass: ajax-modal key', '---\n- 1\n', NULL),
       (35, 5, 0, 1, 'Sign up', 'auth/register', 10, '---\ntarget: _self\nclass: user_add', '---\n- 1\n', NULL),
       (43, 2, 0, 1, 'Log out', 'auth/logout', 12, '---\ntarget: _self\nclass: logout', '---\n- 0\n', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}perms_rules` WRITE;
DELETE
FROM `{#}perms_rules`;
INSERT INTO `{#}perms_rules` (`id`, `controller`, `name`, `type`, `options`, `show_for_guest_group`)
VALUES (1, 'content', 'add', 'list', 'premod,yes', NULL),
       (2, 'content', 'edit', 'list', 'premod_own,own,premod_all,all', NULL),
       (3, 'content', 'delete', 'list', 'own,all', NULL),
       (4, 'content', 'add_cat', 'flag', NULL, NULL),
       (5, 'content', 'edit_cat', 'flag', NULL, NULL),
       (6, 'content', 'delete_cat', 'flag', NULL, NULL),
       (9, 'content', 'privacy', 'flag', NULL, NULL),
       (13, 'content', 'view_all', 'flag', NULL, NULL),
       (18, 'content', 'limit', 'number', NULL, NULL),
       (24, 'content', 'pub_late', 'flag', NULL, NULL),
       (25, 'content', 'pub_long', 'list', 'days,any', NULL),
       (26, 'content', 'pub_max_days', 'number', NULL, NULL),
       (27, 'content', 'pub_max_ext', 'flag', NULL, NULL),
       (28, 'content', 'pub_on', 'flag', NULL, NULL),
       (32, 'content', 'add_to_parent', 'list', 'to_own,to_other,to_all', NULL),
       (33, 'content', 'bind_to_parent', 'list', 'own_to_own,own_to_other,own_to_all,other_to_own,other_to_other,other_to_all,all_to_own,all_to_other,all_to_all', NULL),
       (34, 'content', 'bind_off_parent', 'list', 'own,all', NULL),
       (35, 'content', 'move_to_trash', 'list', 'own,all', NULL),
       (36, 'content', 'restore', 'list', 'own,all', NULL),
       (37, 'content', 'trash_left_time', 'number', NULL, NULL),
       (38, 'users', 'delete', 'list', 'my,anyuser', NULL),
       (41, 'users', 'bind_to_parent', 'list', 'own_to_own,own_to_other,own_to_all,other_to_own,other_to_other,other_to_all,all_to_own,all_to_other,all_to_all', NULL),
       (43, 'users', 'bind_off_parent', 'list', 'own,all', NULL),
       (45, 'auth', 'view_closed', 'flag', NULL, NULL),
       (46, 'content', 'view_list', 'list', 'other,all', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}perms_users` WRITE;
DELETE
FROM `{#}perms_users`;
INSERT INTO `{#}perms_users` (`rule_id`, `group_id`, `subject`, `value`)
VALUES (10, 4, 'comments', '1'),
       (11, 4, 'comments', 'own'),
       (15, 4, 'groups', 'yes'),
       (17, 4, 'groups', 'own'),
       (16, 4, 'groups', 'own'),
       (19, 4, 'users', '1'),
       (10, 5, 'comments', '1'),
       (12, 5, 'comments', 'all'),
       (11, 5, 'comments', 'all'),
       (14, 5, 'comments', '1'),
       (15, 5, 'groups', 'yes'),
       (17, 5, 'groups', 'all'),
       (16, 5, 'groups', 'all'),
       (19, 5, 'users', '1'),
       (10, 3, 'comments', '1'),
       (12, 3, 'comments', 'own'),
       (11, 3, 'comments', 'own'),
       (1, 4, 'albums', 'yes'),
       (1, 5, 'albums', 'yes'),
       (1, 6, 'albums', 'yes'),
       (3, 4, 'albums', 'own'),
       (3, 5, 'albums', 'all'),
       (3, 6, 'albums', 'all'),
       (2, 4, 'albums', 'own'),
       (2, 5, 'albums', 'all'),
       (2, 6, 'albums', 'all'),
       (9, 4, 'albums', '1'),
       (9, 5, 'albums', '1'),
       (9, 6, 'albums', '1'),
       (8, 4, 'albums', '1'),
       (8, 5, 'albums', '1'),
       (8, 6, 'albums', '1'),
       (13, 5, 'albums', '1'),
       (13, 6, 'albums', '1'),
       (10, 6, 'comments', '1'),
       (12, 6, 'comments', 'all'),
       (11, 6, 'comments', 'all'),
       (20, 4, 'comments', '1'),
       (20, 5, 'comments', '1'),
       (20, 6, 'comments', '1'),
       (14, 6, 'comments', '1'),
       (21, 4, 'comments', '1'),
       (23, 5, 'activity', '1'),
       (23, 6, 'activity', '1'),
       (1, 3, 'albums', 'yes'),
       (3, 3, 'albums', 'own'),
       (2, 3, 'albums', 'own');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}scheduler_tasks` WRITE;
DELETE
FROM `{#}scheduler_tasks`;
INSERT INTO `{#}scheduler_tasks` (`id`, `title`, `controller`, `hook`, `period`, `is_strict_period`, `date_last_run`, `is_active`, `is_new`, `consistent_run`)
VALUES (1, 'User migrations between groups', 'users', 'migration', 1440, NULL, NULL, 1, 0, NULL),
       (4, 'Publish Content on a schedule', 'content', 'publication', 1440, NULL, NULL, 1, 1, NULL),
       (6, 'Delete unverified users', 'auth', 'delete_expired_unverified', 60, NULL, NULL, 1, 1, NULL),
       (7, 'Deleting of expired items from the trash', 'moderation', 'trash', 30, NULL, NULL, 1, 1, NULL),
       (8, 'Run system queue tasks', 'queue', 'run_queue', 1, NULL, NULL, 1, 1, NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}sessions_online` WRITE;
DELETE
FROM `{#}sessions_online`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}uploaded_files` WRITE;
DELETE
FROM `{#}uploaded_files`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users` WRITE;
DELETE
FROM `{#}users`;
INSERT INTO `{#}users` (`id`, `groups`, `email`, `password`, `password_salt`, `is_admin`, `nickname`, `date_reg`, `date_log`, `date_group`, `ip`, `is_deleted`, `is_locked`,
                                         `lock_until`, `lock_reason`, `pass_token`, `date_token`, `friends_count`, `subscribers_count`, `time_zone`, `karma`, `rating`, `theme`, `notify_options`,
                                         `privacy_options`, `status_id`, `status_text`, `inviter_id`, `invites_count`, `date_invites`, `birth_date`, `city`, `city_cache`, `hobby`, `avatar`, `icq`,
                                         `skype`, `phone`, `music`, `movies`, `site`)
VALUES (1, '---\n- 6\n', 'admin@example.com', '', '', 1, 'admin', '2018-12-13 10:36:06', '2018-12-13 10:36:06', '2018-12-13 10:36:06', '127.0.0.1', NULL, NULL, NULL, NULL, NULL, NULL, 468, 2,
        'Europe/London', 0, 0, '---\nbg_img: null\nbg_color: \'#ffffff\'\nbg_repeat: no-repeat\nbg_pos_x: left\nbg_pos_y: top\nmargin_top: 0\n',
        '---\nusers_friend_add: both\nusers_friend_delete: both\ncomments_new: both\ncomments_reply: email\nusers_friend_accept: pm\ngroups_invite: email\nusers_wall_write: email\n',
        '---\nusers_profile_view: anyone\nmessages_pm: anyone\n', NULL, NULL, NULL, 0, NULL, '1985-10-15 00:00:00', 12008, 'London',
        'Style too own civil out along. Perfectly offending attempted add arranging age gentleman concluded.', NULL, '987654321', 'admin', '100-20-30', 'Disco House, Minimal techno',
        'various interesting', 'instantcms.ru');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_auth_tokens` WRITE;
DELETE
FROM `{#}users_auth_tokens`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_contacts` WRITE;
DELETE
FROM `{#}users_contacts`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_fields` WRITE;
DELETE
FROM `{#}users_fields`;
INSERT INTO `{#}users_fields` (`id`, `ctype_id`, `name`, `title`, `hint`, `ordering`, `fieldset`, `type`, `is_in_list`, `is_in_item`, `is_in_filter`, `is_private`, `is_fixed`,
                                                `is_fixed_type`, `is_system`, `values`, `options`, `groups_read`, `groups_edit`, `filter_view`)
VALUES (1, NULL, 'birth_date', 'Age', NULL, 4, 'About', 'age', NULL, 1, 1, NULL, NULL, NULL, NULL, NULL,
        '---\ndate_title: Date of birth\nshow_y: 1\nshow_m: null\nshow_d: null\nshow_h: null\nshow_i: null\nrange: YEAR\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n',
        '---\n- 0\n', '---\n- 0\n', NULL),
       (2, NULL, 'city', 'City', 'Select the city where you live', 3, 'About', 'city', NULL, 1, 1, NULL, NULL, NULL, NULL, NULL,
        '---\nlabel_in_item: left\nis_required: 1\nis_digits: \nis_alphanumeric: \nis_email: \nis_unique: \n', '---\n- 0\n', '---\n- 0\n', NULL),
       (3, NULL, 'hobby', 'Tell us about yourself', 'Tell us about your interests and hobbies', 11, 'About me', 'text', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 255\nis_html_filter: null\nlabel_in_item: none\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n',
        NULL),
       (5, NULL, 'nickname', 'Username', 'Your display name on the website', 1, 'About', 'string', 1, 1, 1, NULL, 1, NULL, 1, NULL,
        '---\r\nlabel_in_list: left\r\nlabel_in_item: left\r\nis_required: 1\r\nis_digits: \r\nis_number: \r\nis_alphanumeric: \r\nis_email: \r\nis_unique: \r\nshow_symbol_count: 1\r\nmin_length: 2\r\nmax_length: 100\r\n',
        '---\n- 0\n', '---\n- 0\n', NULL),
       (6, NULL, 'avatar', 'Avatar', 'Your main photo', 2, 'About', 'image', 1, 1, NULL, NULL, 1, NULL, 1, NULL,
        '---\nsize_teaser: micro\nsize_full: normal\nsizes:\n  - micro\n  - small\n  - normal\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n',
        '---\n- 0\n', '---\n- 0\n', NULL),
       (7, NULL, 'icq', 'ICQ', NULL, 8, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 9\nlabel_in_item: left\nis_required: null\nis_digits: 1\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (8, NULL, 'skype', 'Skype', NULL, 9, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 32\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (9, NULL, 'phone', 'Phone number', NULL, 7, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (10, NULL, 'music', 'Favorite Music', NULL, 6, 'Preferences', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (11, NULL, 'movies', 'Favorite Movies', NULL, 5, 'Preferences', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL),
       (12, NULL, 'site', 'Website', 'Your personal website', 10, 'Contacts', 'url', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL,
        '---\nredirect: 1\nauto_http: 1\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_groups` WRITE;
DELETE
FROM `{#}users_groups`;
INSERT INTO `{#}users_groups` (`id`, `name`, `title`, `is_fixed`, `is_public`, `is_filter`)
VALUES (1, 'guests', 'Guests', 1, NULL, NULL),
       (3, 'newbies', 'Newbies', NULL, NULL, NULL),
       (4, 'members', 'Members', NULL, NULL, NULL),
       (5, 'moderators', 'Moderators', NULL, NULL, NULL),
       (6, 'admins', 'Administrators', NULL, NULL, 1);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_groups_members` WRITE;
DELETE
FROM `{#}users_groups_members`;
INSERT INTO `{#}users_groups_members` (`user_id`, `group_id`)
VALUES (1, 6);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_groups_migration` WRITE;
DELETE
FROM `{#}users_groups_migration`;
INSERT INTO `{#}users_groups_migration` (`id`, `is_active`, `title`, `group_from_id`, `group_to_id`, `is_keep_group`, `is_passed`, `is_rating`, `is_karma`, `passed_days`,
                                                          `passed_from`, `rating`, `karma`, `is_notify`, `notify_text`)
VALUES (1, 1, 'Time test', 3, 4, 0, 1, NULL, NULL, 3, 0, NULL, NULL, 1, '3 days elapsed from the moment of your registration.\r\nAll site features are available to you now');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_ignors` WRITE;
DELETE
FROM `{#}users_ignors`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_personal_settings` WRITE;
DELETE
FROM `{#}users_personal_settings`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}users_tabs` WRITE;
DELETE
FROM `{#}users_tabs`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}widgets` WRITE;
DELETE
FROM `{#}widgets`;
INSERT INTO `{#}widgets` (`id`, `controller`, `name`, `title`, `author`, `url`, `version`, `is_external`, `files`, `addon_id`)
VALUES (1, NULL, 'text', 'Text block', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (2, 'users', 'list', 'User list', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (3, NULL, 'menu', 'Menu', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (4, 'content', 'list', 'Content list', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (5, 'content', 'categories', 'Categories', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (8, 'users', 'online', 'Who is online', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (9, 'users', 'avatar', 'User Avatar', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (11, 'content', 'slider', 'Content slider', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (12, 'auth', 'auth', 'Authorization form', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (13, 'search', 'search', 'Search', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (14, NULL, 'html', 'HTML block', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (15, 'content', 'filter', 'Content filter', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL),
       (19, 'auth', 'register', 'Registration form', 'InstantCMS Team', 'https://instantcms.ru', '2.0', NULL, NULL, NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}widgets_bind` WRITE;
DELETE
FROM `{#}widgets_bind`;
INSERT INTO `{#}widgets_bind` (`id`, `template`, `template_layouts`, `languages`, `widget_id`, `title`, `links`, `class`, `class_title`, `class_wrap`, `is_title`, `is_enabled`,
                                                `is_tab_prev`, `groups_view`, `groups_hide`, `options`, `page_id`, `position`, `ordering`, `tpl_body`, `tpl_wrap`, `device_types`)
VALUES (1, 'default', NULL, NULL, 3, 'Main menu', NULL, NULL, NULL, NULL, NULL, 1, NULL, '---\n- 0\n', NULL, '---\nmenu: main\nis_detect: 1\nmax_items: 8\n', 0, 'top', 1, NULL, NULL, NULL),
       (2, 'default', NULL, NULL, 3, 'Auth menu', NULL, NULL, NULL, NULL, NULL, 1, NULL, '---\n- 1\n', NULL, '---\nmenu: header\nis_detect: 1\nmax_items: 0\n', 0, 'header', 1, NULL, NULL, NULL),
       (5, 'default', NULL, NULL, 3, 'Actions menu', NULL, NULL, NULL, 'fixed_actions_menu', NULL, 1, NULL, '---\n- 0\n', NULL, '---\nmenu: toolbar\ntemplate: menu\nis_detect: null\nmax_items: 0\n',
        0, 'left-top', 1, 'menu', 'wrapper', NULL),
       (20, 'default', NULL, NULL, 12, 'Log in', NULL, NULL, NULL, NULL, 1, 1, NULL, '---\n- 0\n', NULL, '', 0, 'right-center', 1, NULL, NULL, NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `{#}widgets_pages` WRITE;
DELETE
FROM `{#}widgets_pages`;
INSERT INTO `{#}widgets_pages` (`id`, `controller`, `name`, `title_const`, `title_subject`, `title`, `url_mask`, `url_mask_not`, `groups`, `countries`)
VALUES (0, NULL, 'all', 'LANG_WP_ALL_PAGES', NULL, NULL, NULL, NULL, NULL, NULL),
       (100, 'users', 'list', 'LANG_USERS_LIST', NULL, NULL, 'users\r\nusers/index\r\nusers/index/*', NULL, NULL, NULL),
       (101, 'users', 'profile', 'LANG_USERS_PROFILE', NULL, NULL, 'users/%*', 'users/%/edit', NULL, NULL),
       (102, 'users', 'edit', 'LANG_USERS_EDIT_PROFILE', NULL, NULL, 'users/%/edit', NULL, NULL, NULL);
UNLOCK TABLES;
COMMIT;
