#!/bin/sh

echo "192.168.1.20 HA1
	  192.168.1.21 HA2" >> /etc/hosts

cat /etc/hosts




#แปลกตรงที่ตั้ง pass เป็นตัวอักษรยากหรือสัญลักษณ์ไม่ได้
echo password | passwd --stdin hacluster



yum -y install ntp 

systemctl start ntpd
systemctl enable ntpd

yum -y install epel-release 
yum -y install pcs fence-agents-all 

firewall-cmd --permanent --add-service=high-availability; firewall-cmd --reload



#systemctl start pcsd
#systemctl enable pcsd
#systemctl status pcsd

systemctl enable --now pcsd
pcs cluster auth HA1 HA2

pcs cluster setup --start --name mycluster HA1 HA2


cluster enable --all

pcs cluster status

corosync-quorumtool


#firewall stop

echo "firewall stop"


systemctl status firewalld
firewall-cmd --state
firewall-cmd --zone=public --list-all
#firewall-cmd --zone=public --remove-port=514/tcp --permanent
firewall-cmd --zone=public --add-port=2224/udp --permanent

more /etc/firewalld/zones/public.xml
firewall-cmd --reload

firewall-cmd --zone=public --list-all
