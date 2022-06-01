# Deploy an Ubuntu 20.04 Live Server VM to an ESXi 7.0 standalone host with Packer

I am in the process of skilling up and along the way, I am documenting the steps with a view to hopefully helping someone else out.

With that in mind, this repository is a work in progress and I welcome comments on how to improve the build files.

There are many blogs on how to deploy a VM to vCenter, but not many on deploying straight to ESXi 7.0.

These scripts will enable you to deploy an Ubuntu 20.04 VM on ESXi 7.0 and up.

We're making use of the vnc_over_websocket feature which was added on the back of vnc being removed from ESXi 7.0: 

William Lams [blog entry](https://williamlam.com/2020/10/quick-tip-vmware-iso-builder-for-packer-now-supported-with-esxi-7-0.html)

The Github PR raised on the back of [VNC being removed from ESXi 7.0](https://github.com/hashicorp/packer/issues/8984)

This eliminates the need to mess around with the ESXi Firewall services.xml - believe me, that was a rabbit hole I thought I'd never get out of.

In the hcl and user-data files, you’ll find the string: CHANGEME - change this to match your requirements.

The password hash needed for the user account in the user-data file is generated with:

```
mkpasswd —method=SHA-512 —rounds=4096
```


Proof of build (Windows):

```
S:\Lab\Packer\Packer ESXi Ubuntu 20.04>packer build -var-file=variables.pkrvars.hcl ubuntu-20.04-live-server-packer.pkr.hcl
Warning: Your vmx data contains the following variable(s), which Packer normally sets when it generates its own default vmx template. This may cause your build to fail 
or behave unpredictably: numvcpus, memsize, ethernet0.virtualDev

  on ubuntu-20.04-live-server-packer.pkr.hcl line 51:
  (source code not available)


vmware-iso.moiflab-ub01: output will be in this color.

==> vmware-iso.moiflab-ub01: Retrieving ISO
==> vmware-iso.moiflab-ub01: Trying ubuntu-20.04.4-live-server-amd64.iso
==> vmware-iso.moiflab-ub01: Trying ubuntu-20.04.4-live-server-amd64.iso?checksum=sha256%3A28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad
==> vmware-iso.moiflab-ub01: ubuntu-20.04.4-live-server-amd64.iso?checksum=sha256%3A28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad => S:\Lab\Packer\Packer ESXi Ubuntu 20.04\packer_cache\47de2d7266acde194681de2a24f5d76b43b452ca.iso
==> vmware-iso.moiflab-ub01: Configuring output and export directories...
==> vmware-iso.moiflab-ub01: Remote cache was verified skipping remote upload...
==> vmware-iso.moiflab-ub01: Creating required virtual machine disks
==> vmware-iso.moiflab-ub01: Building and writing VMX file
==> vmware-iso.moiflab-ub01: Starting HTTP server on port 8826
==> vmware-iso.moiflab-ub01: Registering remote VM...
==> vmware-iso.moiflab-ub01: Starting virtual machine...
==> vmware-iso.moiflab-ub01: Connecting to VNC over websocket...
==> vmware-iso.moiflab-ub01: Waiting 3s for boot...
==> vmware-iso.moiflab-ub01: Typing the boot command over VNC...
==> vmware-iso.moiflab-ub01: Waiting for SSH to become available...
==> vmware-iso.moiflab-ub01: Connected to SSH!
==> vmware-iso.moiflab-ub01: Provisioning with shell script: C:\Users\Moif\AppData\Local\Temp\packer-shell1277354851
    vmware-iso.moiflab-ub01: bin   dev  home  lib32     libx32      media  opt   root  sbin  srv       sys  usr
    vmware-iso.moiflab-ub01: boot  etc  lib      lib64  lost+found  mnt    proc  run   snap  swap.img  tmp  var
==> vmware-iso.moiflab-ub01: Gracefully halting virtual machine...
    vmware-iso.moiflab-ub01: Waiting for VMware to clean up after itself...
==> vmware-iso.moiflab-ub01: Deleting unnecessary VMware files...
    vmware-iso.moiflab-ub01: Deleting: /vmfs/volumes/NVMe_Crucial01_1TB/packer-moiflab-ub01/vmware.log
==> vmware-iso.moiflab-ub01: Compacting all attached virtual disks...
    vmware-iso.moiflab-ub01: Compacting virtual disk 1
==> vmware-iso.moiflab-ub01: Cleaning VMX prior to finishing up...
    vmware-iso.moiflab-ub01: Detaching ISO from CD-ROM device ide0:0...
    vmware-iso.moiflab-ub01: Disabling VNC server...
==> vmware-iso.moiflab-ub01: Skipping export of virtual machine...
==> vmware-iso.moiflab-ub01: Keeping virtual machine registered with ESX host (keep_registered = true)
Build 'vmware-iso.moiflab-ub01' finished after 11 minutes 48 seconds.

==> Wait completed after 11 minutes 48 seconds

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso.moiflab-ub01: VM files in directory: /vmfs/volumes/NVMe_Crucial01_1TB/packer-moiflab-ub01
```

