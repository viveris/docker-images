Image to manipulate qcow2 disk images with libguestfs-tools.

**Run**
------------------------------------------
```
docker run --privileged -ti -v /path/to/images/:/images libvirt bash
# guestmount -a /path/to/images/myimage.qcow2 -i /mnt/
# ls /mnt
# guestunmount /mnt
```
The container must be run with option --privileged to be able to mount the disk image.
