#!/bin/bash
set -e
# as root
su
apt install sudo -y

# as user using sudo
sudo apt update -y
sudo apt install ufw vim members libpam-cracklib kdump-tools -y
# sudo apt list cron
----------------------------------------------------------------------------------

#configure ufw

sudo ufw enable
sudo ufw allow 4242
sudo ufw status verbose
sudo ufw status numbered
# sudo ufw delete [num]


#configure SSH
sudo systemctl status ssh
sudo vim /etc/ssh/sshd_config
	#port 22 --> 4242
	# PermitRootlogin no
		# https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/

# ================================================================================================ #

	export EDITOR=vim
		visudo							# user hosts=(users:groups) commands
										# user ALL=(ALL:ALL) READ
										# Cmnd_Alias READ = mytop,cat,tail

# configure sudo
	# https://www.unixtutorial.org/how-to-use-visudo/
	# https://www.unixtutorial.org/how-to-setup-sudo-in-debian/
	
# vim /etc/sudoers
sudo cat << EOF >> /etc/sudoers
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password ..."
Defaults     logfile="/var/log/sudo/sudo.log"
Defaults     log_input
Defaults     log_output
Defaults     requiretty

pdolinar	ALL(ALL:ALL) ALL
pdolinar	ALL(ALL) NOPASSWD: /path/to/file	# --> running file w/o sudo
EOF


	# https://codepre.com/how-to-configure-a-strong-password-policy-in-debian.html
	# https://ostechnix.com/how-to-set-password-policies-in-linux/
	
	# vim /etc/pam.d/common.password
sudo cat << EOF >> /etc/pam.d/common.password
minlen = 10 maxrepeat = 3 difok = 7 ucredit = -1 dcredit = -1 enforce_for_root reject_username retry = 3 
EOF

	# vim /etc/login.defs
sudo cat << EOF >> /etc/login.defs
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
EOF

# Check if password rules working in users:
	chage -1 testuser

    chage -M (max days)
    chage -m (min days)
    chage -W (warning days)
    chage -l
    
# configure user group

# list all users
	less etc/passwd	
	getent passwd
	awk –F: ‘{print $1}’ /etc/passwd
	cut –d: –f1 /etc/passwd

# members of a group
grep editorial /etc/group

	# https://phoenixnap.com/kb/how-to-list-users-linux
	# https://www.techrepublic.com/article/how-to-create-users-and-groups-in-linux-from-the-command-line/

	adduser testuser
	useradd -g sudo testuser				
	sudo usermod -a -G testgroup1 testuser		# another way

# Find out the Groups a User belongs
	groups testuser		# OR -->
	id -nG testuser

# Removing User from a Group Using usermod
	usermod -G testgroup testuser		# Add that group which you want to preserve

	getent group sudo				# check user's group
	# https://linoxide.com/remove-linux-user-from-group/

# ================================================================================================ #

# AppArmor
/etc/init.d/apparmor start
/etc/init.d/apparmor status
aa-status
	# https://www.cyberciti.biz/faq/suse-ubuntu-linux-start-stop-restart-apparmor-command/

# KDump
sudo apt install kdump-tools
sudo update-grub
sudo kdump-config status
sudo dmesg | grep -i crash

	# --- https://www.bentasker.co.uk/posts/documentation/linux/312-installing-and-configuring-kdump-on-debian-jessie.html >> setting up
	# --- https://wikimho.com/us/q/superuser/280767   >> setting up the kdump

	# https://ubuntu.com/server/docs/kernel-crash-dump
	# https://www.cyberciti.biz/faq/how-to-on-enable-kernel-crash-dump-on-debian-linux/
	# https://mudongliang.github.io/2018/07/02/debian-enable-kernel-dump.html


# ================================================================================================ #
chmod 755 minitoring.sh
visudo
	# awk: https://www.youtube.com/watch?v=fRZvwBevctA		
	# awk https://linuxhandbook.com/awk-command-tutorial/
		
# last boot : last -x|grep shutdown | head -1

# users
		# counting login sessions, but if a user has more than one login session open they are counted more than once
	w			# w -h | wc -l
	who			# who | wc -l
	# who | cut -d " " -f 1 | sort -u | wc -l		--->  get only unique users who use server 
	# https://www.computerhope.com/issues/ch001649.htm
		# count any user running a process
			ps


# 

# number of users using the server 
	# https://www.computerhope.com/issues/ch001649.htm

	wall -n "..."	# To suppress the banner and show only the text you types to the logged-in users
	wall " ..."

	# https://phoenixnap.com/kb/linux-commands-check-memory-usage
	# https://www.cyberciti.biz/tips/linux-last-reboot-time-and-date-find-out.html

# ================================================================================================ #

#CRONTAB
	# https://codepre.com/how-to-set-up-a-cron-job-in-debian-10.html
	# https://phoenixnap.com/kb/set-up-cron-job-linux
crontab -l
crontab -e -u root
sudo crontab -u root -e
sudo service cron status

# stop cron service
/etc/init.d/cron stop
sudo systemctl stop cron.service

	# @reboot /sbin/ip addr | grep inet\ | tail -n1 | awk '{ print $2 }' > /etc/issue && echo "" >> /etc/issue



#passwords: 
#root: we
#user:aaa
#cryp:sa


# -------------
# user wer
# pdolinar we


	# https://www.tecmint.com/trace-shell-script-execution-in-linux/

# ================================================================================================ #

# change host name

hostnamectl
sudo hostnamectl set-hostname <new_hostname>
hostnamectl status

sudo vim /etc/hosts

127.0.0.1 localhost
127.0.0.1 new-hostname

sudo usermod -a -G testgroup1 testuser
getent group sudo


# ================================================================================================ #
								##		BONUS PART		##
	
# install vsftpd
		# https://linoxide.com/how-to-install-vsftpd-ftp-server-on-debian/  

		# https://www.linode.com/community/questions/22444/ftp-connect-connection-timed-out
		# https://linuxconfig.org/how-to-setup-vsftpd-on-debian
		# https://www.techrepublic.com/article/use-vsftp-for-a-secure-reliable-ftp-server/
								
# install latest PHP 

		# https://www.linuxshelltips.com/install-php-8-debian/
		
		
# install lighttpd

		# https://www.osradar.com/install-lighttpd-debian-10/
		# 
		


#wordpress passwd> WG2^v0lwo%q3jaOIH1
