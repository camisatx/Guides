# PostgreSQL Backup Strategies

This file contains some strategies for backing up and restoring a PostgreSQL database. Many of the items were sourced from Magnus Hagander's PGCon 2013 presentation (PostgreSQL Backup Strategies) [1](#sources).

Contents:
- [Dump Specified Database](#dump-specified-database)
- [Dump Miscellaneous Database Values](#dump-miscellaneous-database-values)
- [Restore Database Dump](#restore-the-dump)
- [Sources](#sources)

Postgres database backups involve two main activities, dumping the data and restoring the data.

For databases smaller than 1TB, it is worthwhile to use ```pg_dump``` to dump all database values into an archival object. The size limitation is based on the time required to not only dump the data, but also to restore the data. Restoring the data is a much more time sensitive activity, because you are often rebuilding the database from scratch after a database issue, thus you need to be up and running as quickly as possible.

Alternatively, you can also use live replication of the database, creating a fail-over system. Thus, if the main database system fails, it could seamlessly fail onto the replicated system, preventing any downtime.

# Dump Specified Database

The easiest way to backup a database is to dump the values into an object and store it on another machine. Using ```pg_dump```, you can specify the object type, if to compress it and whether to parallellize the dump.

[pg_dump](https://www.postgresql.org/docs/current/static/app-pgdump.html)

### Custom format dump with good compression

Using the custom format variable of ```-Fc``` with pd_dump, it compresses the data while still being readable. Additionally, using the ```-Z<n>``` variable, you can specify the compression level between 0 (off; -Z0) and 9 (max; -Z9), with 6 being the default of ```-Fc```.

### Choosing where to run the dump

When running ```pg_dump```, you can determine what machine is performing the compression of the data, along with the impact of IO. This is done by either running ```pg_dump``` on the database server or on a remote backup server.

#### Local Database Server

Run the ```pg_dump``` on the database server directly.

Impacts the database server's CPU, while having minimal IO impact.

Best to store dump on either a separate disk or on another machine, just not on the same disk (causes random read/write of the data).

Default level 6 compression:

```bash
pg_dump -Fc -U postgres mydb > mydb.dump
```

Maximum compression level 9:

```bash
pg_dump -Z9 -Fc -U postgres mydb > mydb.dump
```

Backing up the pySecMaster with default settings:

```bash
C:\Program Files\PostgreSQL\9.5\bin\pg_dump -Fc -U postgres pysecmaster > C:\Users\joshs\Desktop\pysecmaster_20160702.dump
```

#### Remote Backup Server

SSH into the database server to run pg_dump.

Allows the remote server's CPU to compress the dump, using SSH to securely transfer the uncompressed data (you must specify for SSH to not compress the data). Does not impact the database server's CPU, but does impact it's IO.

Maximum compression level 9:

```bash
ssh -o "Compression=no" db.domain.com "pg_dump -Z9 -Fc -U postgres mydb" > mydb.dump
```


# Dump Miscellaneous Database Values

Along with dumping the actual database values, it is important to also dump the database global objects, including the roles and tablespaces. This is done via the ```pg_dumpall -g``` command (the ```-g``` variable dumps global objects only).

[pg_dumpall](https://www.postgresql.org/docs/current/static/app-pg-dumpall.html)

Backing up the pySecMaster global objects:

```bash
pg_dumpall -g -U postgres > C:\Users\joshs\Desktop\postgres_misc_20160702.dump
```


# Restore the Dump

Half of backing up databases involve being able to restore the data in a timely manner. ```pg_restore``` allows for loading the previously dumped data into a fresh database structure.

However, ```pg_restore``` starts to fail with databases over 1TB because it can take far too long to restore the data dump. This is when it is pertinent to use a replicated database system to prevent having to restore massive databases from scratch.

[pg_restore](https://www.postgresql.org/docs/current/static/app-pgrestore.html)

#### Important Flags

```-1``` flag does a full restore as a single transaction. With this flag, the database will only be restored if the entire restore was successful. Meaning you won't be left with a corrupt or missing database structure. 


```-j <n>``` flag parallels the restore, however, it is not compatible with -1 flag. This is a very important flag for large databases where they need to be restored as quickly as possible. The number of parallel processes is limited by the IO.


# Sources
1. [Magnus Hagander's PGCon 2013 Presentation](https://www.youtube.com/watch?v=FyR3TD11hlc)
