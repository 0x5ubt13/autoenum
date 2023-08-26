# autoEnum, an automatic enumeration tool

Heavily inspired by [autoNmap](https://github.com/0x5ubt13/myToolkit/tree/main/autoNmap), this tool goes far beyond `Nmap` enumeration.

In many external infra jobs, practice labs, and some boot2root CTFs, I found myself using `autoNmap` and the same extra enumeration tools afterwards over and over, so I came up with the idea of including these extra enumeration tools to the already nice functionality of `autoNmap`, so we could consider `autoEnum` as an **"autoNmap on steroids"**

Pass either a single IP address or a targets file to it and will first get the ports open on each host, then will concurrently launch tools appropriate for every open well-known port. These will start working on the background, so allow a few moments for them to run completely. You will get a notification on your terminal when each of them are done.

Due to some new functionality that is not present in `autoNmap`, `autoEnum` is written in a non-POSIX compliant manner (at least for now). Make sure you have `bash` (or `zsh`) installed, then simply run the script.

This tool is still in its early days, and comes with absolutely no guarantee. Please email `5ubt13@protonmail.com` with any suggestions you may have.

![autoEnum_gif](autoenum-demo.gif)

## Usage

Give it either a single IP address or a file containing a list of IPs, a name to use for the output files, sit back, and relax:

~~~txt
┌──(kali㉿SubtleLabs)-[~]
└─$ autoenum -h             

             _____      __________                         
______ ____ ___  /_________  ____/_________  ________ ___ 
_  __ ` / / / /  __/  __ \_  __/ __  __ \  / / /_  __ `__ \
/ /_/ // /_/ // /_ / /_/ /  /___ _  / / / /_/ /_  / / / / /
\__,_/ \__,_/ \__/ \____//_____/ /_/ /_/\__,_/ /_/ /_/ /_/ 
                    by 0x5ubt13                               
                                            

[*] ---------- Starting Phase 0: running initial checks ----------

[*] Help flag detected. Aborting other checks and printing usage.

Usage: autoenum [OPTIONS] -t <Single target's IP/Targets file>
    -a: Again      - Repeat the scan and compare with initial ports discovered.
    -b: Bruteforce - Activate all fuzzing and bruteforcing in the script.
    -d: DNS        - Specify custom DNS servers. Default option: -n.
    -h: Help       - Display this help and exit.
    -p: Top Ports  - Run port sweep with nmap and the flag --top-ports=<your input>
    -q: Quiet      - Don't print the cool banner and decrease overall verbosity.
    -r: Range      - Specify a CIDR range to use tools for whole subnets.
    -s: Slower     - Don't use Rustscan for the initial port sweep.
    -t: Target     - Specify target single IP / List of IPs file.

Examples:
    autoenum -t 192.168.142.93
    autoenum -qa -t 192.168.142.93
    autoenum -t 10.129.121.60 -d <serv1[,serv2],...>
    autoenum -t 10.129.121.60 -r 10.129.121.0/24
    autoenum -t targets_file.txt -r 10.10.8.0/24
~~~

## Wrapped tools currently present

- Braa
- CeWL
- CrackMapExec
- Enum4linux
- Ffuf
- Fping
- Gobuster
- Hydra
- Ident-user-enum
- Metasploit
- Nbtscan-unixwiz
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

Apart from the above 29 tools, there are many more included in GNU/Linux doing magic tricks behind the scenes!!

## Tools yet to implement

- Do you have any other suggestion? Send a PR or a message!

## Installation

*Rustscan is **no longer** a forced pre-requisite, so if you don't have it, no worries, the initial port sweep will be run with nmap instead. If you don't want to run the [install_requisites](./install_requisites.sh) script, you can try to grab the script and run it, if you have all the tools necessary*

Since this script uses multiple enumeration tools used in Penetration Test engagements, it is expected you will be using a distro like `Kali Linux` or `Pwnbox`. All the packages that don't normally come pre-installed in `Kali` (`Seclists` and `Rustscan`, at the time of writing), are featured in the [install_requisites](./install_requisites.sh) script that you can find in this folder. Run it to automatically update your distro, install `Seclists`, `Homebrew`, `Rustscan`, `SSH-Audit` and `ODAT` for you if you don't have them yet, and it will also symlink `autoEnum` to your `/usr/bin` folder; you'll be able to call it by just issuing `autoenum`.

There are other checks involved, like the presence of `locate`, which should cover the installation for other non-Kali-but-Debian-based distros, although Kali, for ease of use, is recommended for package compatibility. If you spot an error, please report it and I will adjust as necessary. Also, installation for other distros, like Arch-based or RHEL-based will be considered on a request basis.

To run the installer, copy & paste the following:

~~~sh
git clone https://github.com/0x5ubt13/autoenum.git
chmod +x autoenum/autoEnum
cd autoEnum/
./install_requisites.sh
~~~

## Update: porting tool to Go
Although in the next section I reflect on why Bash was initially chosen over Python or Go, I've decided it's time to prove myself and try to compile this tool into a nice, fast, concurrent binary that takes full advantage of the nice features Golang has to offer! :)

You can see the porting process and updates here: [Enumeraga](https://github.com/0x5ubt13/enumeraga)

## Why Bash; and the 'Slow' flag
The way this script works is it first sweeps all open TCP ports, then sweeps some hard-coded UDP ports, and only then, launches the global `Nmap` attack and parses all open ports.

This is clearly the bottleneck of the script, accounting pretty much for the 95% of its running time, and the reason why Bash was chosen over Python or Golang: there's not much point in trying to speed it up if it's going to depend upon the port sweeping to do the logic afterwards anyway.

This is the reason why there are many experiments in the `ports_sweep()` function (TODO: insert line number once the script is finished). `Rustscan` is suggested to be installed in the [install_requisites.sh](./install_requisites.sh) script, but this can sometimes be detrimental as it runs so fast that sometimes, inevitably, it misses open ports.

I have seen the script being run with `Rustscan` to be done in about 10 to 20 seconds (per host), and maybe miss an important port. In the other hand, I have seen the ports sweep being performed with `Nmap` with the slow flag (-s) being done in about 60 to 100 seconds (per host); that is a massive time increase, but not missing any port (the overwhelming majority of times).

In jobs that would normally use VA scanners like `Nessus`, a minute of your time is not really a big issue as those scanners take ages to cover the targets properly, so I would suggest that if you have time, let the script run with the slow flag to ensure coverage is adequate. Otherwise, if you like to risk it a bit and want to play around with the script, the default mode is at full tilt for fun and still covers the majority of ports!

## To Do

- [x] Implement optional arguments
- [x] Experiment with nice colours
- [x] Implement the use of `printf` instead of `echo`
- [x] Adapt to Google's shell scripting style guide
- [x] Implement sending notifications when tools have finished on background
- [x] Hide many of the notifications behind an optional verbose flag
- [x] Finish the core script
- [ ] Implement more utility flags
- [ ] Test thoroughly
- [ ] Link each wrapped tool on README to their official repos
- [ ] Containerise
- [ ] Improve the way output is presented to terminal
- [ ] Improve README.md to show all protocols the script enumerates
- [ ] Convert to POSIX compliant
- [ ] Add MOAR enum tools
- [ ] Enumerate all things (legally!)