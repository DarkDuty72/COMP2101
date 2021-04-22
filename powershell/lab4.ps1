""
#function  hardwdes{
#get-wmiobject -class win32_computersystem | Format-List Description
#} 


function  hardwdes{
(get-wmiobject -class win32_computersystem).Description
} 

"System hardware description is " + (hardwdes)

""
#function  operatinginfo{
#get-wmiobject -class win32_operatingsystem | Format-List version name
#} 

function Ver{
(Get-WmiObject -Class win32_operatingsystem).version
}

function name{
(Get-WmiObject -Class win32_operatingsystem).name
}

"The the operating system name is " + (name) +   " and version number is " + (Ver)


""




function processor{
get-wmiobject -class win32_processor |
    foreach {
        new-object -TypeName psobject -Property @{
            description = $_.name
            numberofcores = $_.numberofcores
            "Speed(MHz)" = $_.CurrentClockSpeed
            L1CacheSize = $_.L1CacheSize
            L2CacheSize = $_.L2CacheSize
            L3CacheSize = $_.L3CacheSize
        }
    } |
fl description,
         "Speed(MHz)",
         numberofcores,
         L1CacheSize, 
         L2CacheSize, 
         L3CacheSize
}

processor


function RAM{

$totalcapacity = 0

get-wmiobject -class win32_physicalmemory |
    foreach {
        new-object -TypeName psobject -Property @{
            Manufacturer = $_.manufacturer
            "Speed(MHz)" = $_.speed
            "Size(MB)" = $_.capacity/1mb
            Bank = $_.banklabel
            Slot = $_.devicelocator
        }
        $totalcapacity += $_.capacity/1mb
    } |
ft -auto Manufacturer,
         "Size(MB)",
         "Speed(MHz)",
         Bank,
         Slot

"Total RAM: ${totalcapacity}MB "
}

RAM


function physicaldisk{

  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }

}
physicaldisk




function network {
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled |
format-table -Property ServiceName, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder
}

network

function vcard{
get-wmiobject -class win32_videocontroller |
    foreach {
        new-object -TypeName psobject -Property @{
            name = $_.name
            Description = $_.Description
            resolution = [string]$_.CurrentHorizontalResolution + "x" + [string]$_.CurrentVerticalResolution
            
        }
    } |
fl  name,
         Description,
         resolution

     
}

vcard
