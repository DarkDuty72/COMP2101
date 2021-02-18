#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard
#check if root

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# Get the current hostname using the hostname command and save it in a variable
x=$(hostname)

#read x
# Tell the user what the current hostname is in a human friendly way
echo "the current hostname is" $x
# Ask for the user's student number using the read command

#y=$(echo -n "what is your number")
#echo -n "what is your studentnumber?:"
#read studentnumber

read -p "what is your studentnumber?: " studentnumber

#echo $studentnumber
#y=$(echo -n "what is your number")


# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
z="pc"$studentnumber
echo $z

# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts


sed -i "s/$x/$z/" /etc/hosts



# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname
echo "the hostname has been changed"
hostnamectl set-hostname $z
echo "you need to reboot to make sure the new name takes full effect"
