orientdb-docker
===============

A dockerfile for creating an orientdb image with :

  - explicit orientdb version (1.7.9) 
  - init by supervisord
  - config, databases and backup folders expected to be mounted as volumes

Running orientdb
----------------

To run the image, run:

```bash
docker run --name orientdb -d -v <config_path>:/opt/orientdb/config -v <databases_path>:/opt/orientdb/databases -v <backup_path>:/opt/orientdb/backup -p 2424 -p 2480 c12e/orientdb
```

The docker image contains a unconfigured orientdb installation and for running it you need to provide your own config folder from which OrientDB will read its startup settings.

The same applies for the databases folder which if local to the running container would go away as soon as it died/you killed it.

The backup folder only needs to be mapped if you activate that setting on your OrientDB configuration file.


OrientDB distributed
--------------------

If you're running OrientDB distributed* you won't have the problem of losing the contents of your databases folder since they are already replicated to the other OrientDB nodes. From the setup above simply leave out the "--volumes-from orientdb_databases" argument and OrientDB will use the container storage to hold your databases' files.

*note: some extra work might be needed to correctly setup hazelcast running inside docker containers ([see this discussion](https://groups.google.com/forum/#!topic/vertx/MvKcz_aTaWM)).


Ad-hoc backups
--------------

With orientdb 1.7.9 we can now create ad-hoc backups by taking advantage of [the new backup.sh script](https://github.com/orientechnologies/orientdb/wiki/Backup-and-Restore#backup-database):

  - Using the orientdb_backup data container that was created above:
    ```bash
    docker run -i -t --volumes-from orientdb_config --volumes-from orientdb_backup c12e/orientdb ./backup.sh <dburl> <user> <password> /opt/orientdb/backup/<backup_file> [<type>]
    ```

  - Or using a host folder:

    `docker run -i -t --volumes-from orientdb_config -v <host_backup_path>:/backup c12e/orientdb ./backup.sh <dburl> <user> <password> /backup/<backup_file> [<type>]`

Either way, when the backup completes you will have the backup file located outside of the OrientDB container and read for safekeeping.

Running the orientdb console
----------------------------

```bash
docker run --rm -it \
            --volumes-from orientdb_config \
            --volumes-from orientdb_databases \
            --volumes-from orientdb_backup \
            c12e/orientdb \
            /opt/orientdb/bin/console.sh
