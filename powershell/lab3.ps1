 get-ciminstance win32_networkadapterconfiguration | where-object ipenabled |
format-table -Property ServiceName, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder