# jails-configs
A collection of config files in order to easily deploy it on a Freebsd Jail.

## dnsmasq_jail.sh

A simple adblock dns server. Simplified version of [https://vlads.me/post/setting-up-dns-adblocker-freebsd-jail/](https://vlads.me/post/setting-up-dns-adblocker-freebsd-jail/)

**host requisites**

* csh shell (Available by default in FreeBSD)

* wget and diff to compare files if required

	```shell
	pkg install wget diffutils
	```

* An empty or existing jail
	*  	Set jail mount point with JAILMOUNTPOINT variable of dnsmasq_jail.sh script. I don' t know if it would be better to pass mountpoint as an script input arg
	```Shell
	set JAILMOUNTPOINT = "/mnt/jails"
	```


**Use it**

Just launch .sh script passing an existing jail name as argument
`./dnsmasq_jail.sh jailName`

