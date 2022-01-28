# Raspberry Pi Setup Linux Scripts (RPI-SLS)
These scripts are designed to automate the process of installing various minimalist linux distros on a raspberry pi.

If you want to install a minimal distro like void linux or alpine on your RPI you often have to test out different images, boot paramers, etc until you find a combination that works. These scripts automate that process to help you get up and running faster.

PRs welcome :)

## Usage
1. Find your distro/platform/bootmedia: `cd \<distro\>/\<platform\>`
2. Set the environment variable for the location of your bootable media device (`export PI_\<distro\>_\<platform\>_\<bootmedia\>=/dev/sdX`. The script will exit with error and warn you if this is unset.
3. (Optional) Modify the script if desired - basic parameters are at the top (image url, image version, image type, etc)
4. Run the script for the bootable media you want (`.\setup_{usb, sd}.sh`)
