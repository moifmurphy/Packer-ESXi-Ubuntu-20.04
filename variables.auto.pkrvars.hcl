/*
    DESCRIPTION:
    Ubuntu Server 20.04 LTS variables used by the Packer Plugin for VMware ESXi (vmware-iso).
*/

// Remote ESXi connection details - self explanatory. You cannot change the remote_type, it's esx5 or bust

  remote_cache_datastore = ""
  remote_datastore       = "CHANGEME"
  remote_host            = "CHANGEME"
  remote_password        = "CHANGEME"
  remote_type            = "esx5"
  remote_username        = "CHANGEME"
