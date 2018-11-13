#cloud-config

package_upgrade: true

packages:
  - epel-release
  - nginx

runcmd:
  - systemctl start nginx
  - systemctl enable nginx