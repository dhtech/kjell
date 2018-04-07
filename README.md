# kjell

A shell server container for dhtech.

Users' authentication keys will be loaded from LDAP using the included key
command. sssd is used to provision users on the server.

## Usage

Requires a configmap with the file `banner` to use as the SSH banner. Mount on
/config.

If persisted storage is mounted on /data/ host keys will be persisted across
restarts.

Set the environment variable `KJELL_ALLOWED_GROUP` to the group you want to
allow to login to the system.
