#!/bin/bash

sudo /etc/init.d/postgresql stop
sudo xfs_freeze -f /mnt

# Take snapshot in AWS console

