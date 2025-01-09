# Distributed-Threatfeed

This project is about setting up a web server that displays IP addresses from a GitHub repository.
There is also a whitelist so that only authorised sources can access the information provided.

In my case, malicious IP addresses are stored in a GitHub repository file with the name index.html in the format 200.12.13.14/32. We then specify this web server as the source in our FortiGates. Of course, this also works with other firewalls. 

Translated with DeepL.com (free version)
