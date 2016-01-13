sm_fstab
========

This is the sm_fstab module. It provides...


# Table of Contents

* [Summary](#summary)
* [Class Parameters](#class-parameters)
* [Examples](#examples)
* [External References](#external-references)

## Summary
The sm_fstab module manages entries in /etc/fstab, mountpoints and the mount status.

## Class Parameters
  * __ensure__ - (default = 'mounted'), can be mounted/present, unmounted, absent.
When set to mounted or present, an entry is added to /etc/fstab, the mountpoint directory
is created if necessary, and the device mounted.  When set to unmounted or absent, the entry 
is removed from /etc/fstab, the device is unmounted and the mountpoint is deleted.
  * __source__ - (required), the disk device/NFS resource.
  * __dest__ - (required), the mountpoint directory to attach the source to.
  * __type__ - (required), ext3, ext4, nfs, etc.
  * __opts__ - (default = 'defaults'), dependant on type.
  * __dump__ - (default = 0)
  * __passno__ - (default = 0)
  * __dest_owner__ - (default = 'root'), user permission.
  * __dest_group__ - (default = 'root'), group permission.
  * __dest_mode__ - (default = '0755'), mode.

## Examples
```
sm_fstab::fstab_entries:
  "oracle_dump":
    source: "/dev/mapper/oracle_dumpp1"
    dest:   "/oracle/dump"
    type:   "ext4"
    dest_owner: "oracle"
    dest_group: "dba"
```

Each mount configuration is a hash, the key being a description of your choice.  The example above will mount the device
/dev/mapper/oracle_dumpp1 to the directory /oracle/dump using the file system type ext4.  The mountpoint directory will 
have permissions set to an owner of oracle, group of dba.

### External References
Depends on the module dirtree.

