
emq-auth-mysql-ex
==============

Authentication, ACL with MySQL Database.

Notice: changed mysql driver to [mysql-otp](https://github.com/mysql-otp/mysql-otp).

Build Plugin
-------------

make && make tests

Configure Plugin
----------------

File: etc/emq_auth_mysql_ex.conf

```
## MySQL server address.
##
## Value: Port | IP:Port
##
## Examples: 3306, 127.0.0.1:3306, localhost:3306
auth.mysqlex.server = 127.0.0.1:3306

## MySQL pool size.
##
## Value: Number
auth.mysqlex.pool = 8

## MySQL username.
##
## Value: String
## auth.mysqlex.username =

## MySQL Password.
##
## Value: String
## auth.mysqlex.password =

## MySQL database.
##
## Value: String
auth.mysqlex.database = mqtt

## Variables: %u = username, %c = clientid

## Authentication query.
##
## Note that column names should be 'password' and 'salt' (if used).
## In case column names differ in your DB - please use aliases,
## e.g. "my_column_name as password".
##
## Value: SQL
##
## Variables:
##  - %u: username
##  - %c: clientid
##
auth.mysqlex.auth_query = select password, max_online from mqtt_user where username = '%u' limit 1
## auth.mysql.auth_query = select password_hash as password, max_online from mqtt_user where username = '%u' limit 1

## Password hash.
##
## Value: plain | md5 | sha | sha256 | bcrypt
auth.mysqlex.password_hash = sha256

## sha256 with salt prefix
## auth.mysqlex.password_hash = salt,sha256

## bcrypt with salt only prefix
## auth.mysqlex.password_hash = salt,bcrypt

## sha256 with salt suffix
## auth.mysqlex.password_hash = sha256,salt

## pbkdf2 with macfun iterations dklen
## macfun: md4, md5, ripemd160, sha, sha224, sha256, sha384, sha512
## auth.mysqlex.password_hash = pbkdf2,sha256,1000,20

## Superuser query.
##
## Value: SQL
##
## Variables:
##  - %u: username
##  - %c: clientid
auth.mysqlex.super_query = select is_superuser from mqtt_user where username = '%u' limit 1

## ACL query.
##
## Value: SQL
##
## Variables:
##  - %a: ipaddr
##  - %u: username
##  - %c: clientid
auth.mysqlex.acl_query = select allow, ipaddr, username, clientid, access, topic from mqtt_acl where ipaddr = '%a' or username = '%u' or username = '$all' or clientid = '%c'

```

Import mqtt.sql
---------------

Import mqtt.sql into your database.

Load Plugin
-----------

./bin/emqttd_ctl plugins load emq_auth_mysql

Auth Table
----------

Notice: This is a demo table. You could authenticate with any user table.

```sql
CREATE TABLE `mqtt_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `salt` varchar(35) DEFAULT NULL,
  `is_superuser` tinyint(1) DEFAULT 0,
  `max_online` int(1) DEFAULT 1 COMMENT 'user login max count',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mqtt_username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
```

ACL Table
----------

```sql
CREATE TABLE `mqtt_acl` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `allow` int(1) DEFAULT NULL COMMENT '0: deny, 1: allow',
  `ipaddr` varchar(60) DEFAULT NULL COMMENT 'IpAddress',
  `username` varchar(100) DEFAULT NULL COMMENT 'Username',
  `clientid` varchar(100) DEFAULT NULL COMMENT 'ClientId',
  `access` int(2) NOT NULL COMMENT '1: subscribe, 2: publish, 3: pubsub',
  `topic` varchar(100) NOT NULL DEFAULT '' COMMENT 'Topic Filter',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

License
-------

Apache License Version 2.0

Author
-------

EMQ X Team.

