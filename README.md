# Raspberry Pi Setup Linux Scripts (RPI-SLS)
These scripts are designed to automate the process of installing various minimalist linux distros on a raspberry pi.

If you want to install a minimal distro like void linux or alpine on your RPI you often have to test out different images, boot paramers, etc until you find a combination that works. These scripts automate that process to help you get up and running faster.

## Warning
These scripts currently don't do any verification of mount points or whatnot *be careful with them*.

## Usage
1. Make sure your raspberry pi drive is mounted at `/dev/sda` or modify the script to point to the right location
2. `cd` to the directory of the \<distro\>_\<rpi\> you want
3. (Optional) Modify the script if necessary - basic parameters are at the top (image url, image version, image type, etc)
4. Run the script
