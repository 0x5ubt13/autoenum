# autoEnum, an automatic enumeration tool

Heavily inspired by [autoNmap](../autoNmap/README.md), this tool goes far beyond `Nmap` enumeration.

In many external infra jobs (and practice labs), I found myself using `autoNmap` and the same extra enumeration tools afterwards over and over, so I came up with the idea of including these extra enumeration tools to the already nice functionality of `autoNmap`, so we could consider `autoEnum` as an **"autoNmap on steroids"**

Pass either a single IP address or a targets file to it and will first get the ports open on each host, then will concurrently launch tools appropriate for every open well-known port. These will start working on the background, so allow a few moments for them to run completely. You will get a notification on your terminal when each of them are done.

Due to some new functionality that is not present in `autoNmap`, `autoEnum` is written in a non-POSIX compliant manner (at least for now). Make sure you have `bash` (or `zsh`) installed, then simply run the script.

This tool is still in its early days, and comes with absolutely no guarantee. Please email `5ubt13@protonmail.com` with any suggestions you may have.

![autoEnum_gif](autoenum-demo.gif)

## Usage

Give it either a single IP address or a file containing a list of IPs, a name to use for the output files, sit back, and relax:

~~~txt
./autoEnum -h

              _____      __________                         
______ ____  ___  /_________  ____/__________  ________ ___ 
_  __ `/  / / /  __/  __ \_  __/  __  __ \  / / /_  __ `__ \
/ /_/ // /_/ // /_ / /_/ /  /___  _  / / / /_/ /_  / / / / /
\__,_/ \__,_/ \__/ \____//_____/  /_/ /_/\__,_/ /_/ /_/ /_/ 
                    by 0x5ubt13                             
   
Usage: autoenum [OPTIONS] -t <Single target's IP / Targets file>
	-a: Again      - Repeat the scan and compare with initial ports discovered.
	-b: Bruteforce - Activate all fuzzing and bruteforcing in the script.
	-d: DNS        - Specify custom DNS servers. Default option: -n.
	-h: Help       - Display this help and exit.
	-p: top Ports  - Run port sweep with nmap and the flag --top-ports=<your input>
	-q: Quiet      - Don't print the cool banner and decrease overall verbosity.
	-r: Range      - Specify a CIDR range to use tools for whole subnets.
	-s: Slower     - Don't use Rustscan for the initial port sweep.
	-t: Target     - Specify target single IP / List of IPs file.

Examples:
	autoenum -t 192.168.142.93
	autoenum -qa -t 192.168.142.93
	autoenum -t 10.129.121.60 -d <serv1[,serv2],...>
	autoenum -r 10.129.121.0/24 -t 10.129.121.60 
	autoenum -t targets_file.txt -r 10.10.8.0/24 
~~~

## 29 wrapped tools currently present

- Braa
- CeWL
- CrackMapExec
- Enum4linux
- Ffuf
- Gobuster
- Hydra
- Ident-user-enum
- Metasploit
- Nbtscan-unixwiz
- Netdiscover
- Nikto
- Nmap
- Nmblookup
- Ldapsearch
- ODAT
- Onesixtyone
- Responder-RunFinger
- RPCDump
- Rusers
- Rustscan
- Rwho
- SMBMap
- SNMPWalk
- SSH-Audit
- WPScan
- Xsltproc
- WhatWeb
- WafW00f

And many more doing magic tricks behind the scenes!!

## Tools yet to implement

- Do you have any other suggestion? Send a PR or a message!

## Installation

*Rustscan is **no longer** a forced pre-requisite, so if you don't have it, no worries, the initial port sweep will be run with nmap instead. If you don't want to run the [install_requisites](./install_requisites.sh) script, you can try to grab the script and run it, if you have all the tools necessary*

Since this script uses multiple enumeration tools used in Penetration Test engagements, it is expected you will be using a distro like `Kali Linux` or `Pwnbox`. All the packages that don't normally come pre-installed in `Kali` (`Seclists` and `Rustscan`, at the time of writing), are featured in the [install_requisites](./install_requisites.sh) script that you can find in this folder. Run it to automatically update your distro, install `Seclists`, `Homebrew`, `Rustscan`, `SSH-Audit` and `ODAT` for you if you don't have them yet, and it will also symlink `autoEnum` to your `/usr/bin` folder; you'll be able to call it by just issuing `autoenum`.

There are other checks involved, like the presence of `locate`, which should cover the installation for other non-Kali-but-Debian-based distros, although Kali, for ease of use, is recommended for package compatibility. If you spot an error, please report it and I will adjust as necessary. Also, installation for other distros, like Arch-based or RHEL-based will be considered on a request basis.

To run the installer, copy & paste the following:

~~~sh
git clone https://github.com/0x5ubt13/myToolkit.git
chmod +x mytoolkit/autoEnum/autoEnum
cd mytoolkit/autoEnum/
./install_requisites.sh
~~~

## To Do

- [x] Implement optional arguments
- [x] Experiment with nice colours
- [x] Implement the use of `printf` instead of `echo`
- [x] Adapt to Google's shell scripting style guide
- [x] Implement sending notifications when tools have finished on background
- [x] Hide many of the notifications behind an optional verbose flag
- [ ] Finish the core script
- [ ] Test thoroughly
- [ ] Link each wrapped tool on README to their repos
- [ ] Containerise
- [ ] Improve the way output is presented to terminal
- [ ] Convert to POSIX compliant
- [ ] Add MOAR enum tools
- [ ] Enumerate all things (legally!)