#!/bin/bash
set -e
service vsftpd start
exec /usr/sbin/sshd -D
