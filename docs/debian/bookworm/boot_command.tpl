<wait>c<wait3>

linux /install.a64/vmlinuz 
  hostname=${vm_name}
  auto=true
  priority=critical
  interface=auto
  net.ifnames=0 biosdevname=0
  preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg
  DEBIAN_FRONTEND=text
<enter>

initrd /install.a64/initrd.gz
<enter>

boot
<enter>
