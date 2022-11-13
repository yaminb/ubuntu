#login as admin to synology
#this allows you to run fsck on drives (DSM 7 right now)
#references
# https://community.synology.com/enu/forum/68/post/146217

sudo -i
synostgvolume --unmount -p /volume1
fsck.ext4 -vf /dev/vg1000/lv
reboot



