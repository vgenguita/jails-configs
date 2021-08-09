# jails-configs
A collection of config files in order to easily deploy it on a Freebsd Jail.

## dnsmasq_jail.sh

A simple adblock dns server. Simplified version of [https://vlads.me/post/setting-up-dns-adblocker-freebsd-jail/](https://vlads.me/post/setting-up-dns-adblocker-freebsd-jail/)

### **PRE INSTALL**

* csh shell (Available by default in FreeBSD)

* wget and diff to compare files if required

	```Console
	root@host:/ # pkg install wget diffutils
	```

* An empty or existing jail
	*  	Set jail mount point with JAILMOUNTPOINT variable of dnsmasq_jail.sh script. I don' t know if it would be better to pass mountpoint as an script input arg
	
	```Shell
	set JAILMOUNTPOINT = "/mnt/jails"
	```


### **INSTALL**

Just launch .sh script passing an existing jail name as argument

```console
user@host:/ # ./dnsmasq_jail.sh jailName
```

### **POST INSTALL**

Pass port from jail to host with pf or prefered firewall. 
Example for /etc/pf.conf

```Shell
dns="{53}"
rdr on $ext_if proto udp from any to any port $dns-> $jail_ip
```
Check config on jail

```console
user@host:/ #  jexec jail
user@jail:/ # dnsmasq --test
dnsmasq: syntax check OK.
```
For test before launch service

On Jail

```console
user@jail:/ # dnsmasq -d -q
```

On host dns query asking to jail ip

```console
user@host:/ # drill freebsd.org @192.168.35.4
;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 15521
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0 
;; QUESTION SECTION:
;; freebsd.org.	IN	A

;; ANSWER SECTION:
freebsd.org.	3600	IN	A	96.47.72.84

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 71 msec
;; SERVER: 192.168.35.4
;; WHEN: Mon Aug  9 13:53:29 2021
;; MSG SIZE  rcvd: 45
```

Finally, launch dnsquery service on jail

```console
user@host:/ # jexec jail
user@jail:/ # service dnsmasq start
Starting dnsmasq.
```

