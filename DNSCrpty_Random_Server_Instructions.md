# DNSCrypt Random Server Instructions

This file covers the steps required to install the DNSCrypt using the d0wn server Randomizer.

1. https://github.com/Noxwizard/dnscrypt-winclient
2. download .zip
3. http://download.dnscrypt.org/dnscrypt-proxy/
4. download latest dnscrypt-proxy-win32-full-x.x.x.zip (currently 1.6.0)
5. extract dnscrypt-proxy-win32-full-x.x.x.zip
6. within extracted files navigate to dnscrypt-resolver.csv and open it
7. insert a row below row 1 and input the data from steps 8-20
8. column A: d0wn-rd-ns1
9. column B: d0wn server Ramdomizer
10. colum C: Server provided by Martin 'd0wn' Albus
11. column D: Random
12. leave column E blank
13. column F: https://dns.d0wn.biz
14. column G: 1
15. column H: no
16. column I: yes
17. column J: yes
18. column K: 178.17.170.133
19. column L: 2.dnscrypt-cert.d0wn.biz
20. column M: 9970:E22D:7F6C:967F:8AED:CEEB:FBC1:94B9:AF54:376E:2BF7:39F1:F466:CBC9:AFDB:2A62
21. leave column N blank
22. save and close the file
23. extract dnscrypt-winclient-master.zip
24. copy ALL files (including edited dnscrypt-resolver.csv) from the dnscrypt-proxy-win32 directory
25. paste ALL copied files into dnscrypt-winclient-master\binaries\Release
26. copy dnscrypt-winclient-master file into C:\Program Files
27. navigate to C:\Program Files\dnscrypt-winclient-master\binaries\Release
28. run dnscrypt-winclient.exe ***AS ADMINISTRATOR***
29. select your primary network adapter (i.e. ethernet) on the NICs tab
30. select d0wn server randomizer from the drop down on the config tab
31. click install at the bottom
32. check DNS servers at ipleak.net