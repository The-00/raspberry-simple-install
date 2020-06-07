from config import *
import os

def r_u_sure(commande):
    print("use '" + commande +"' ?")
    sure = input("[Y|n]")
    if not sure.lower() in ["", "y", "yes"]:
        print("abort")
        exit(1)

## GET
get_commande = "1-getimage.sh"
if image_latest:
    if image_light:
        get_commande += " --light"
else:
    get_commande += " --url=" + image_url

if interactive_enable:
    r_u_sure(get_commande)

## CONFIGURE
configure_commande = "2-configure.sh"
if not wifi_enable:
    configure_commande += " --no-wifi"
else:
    configure_commande += " --wifi-ssid=\"" + wifi_SSID + "\""
    configure_commande += " --wifi-password=\"" + wifi_psw + "\""
    configure_commande += " --my-ip=\"" + wifi_fix_ip + "\""
    configure_commande += " --router-ip=\"" + wifi_default_gateway_ip + "\""
if len(ssh_path) > 0:
    configure_commande += " --ssh=\"" + ssh_path + "\""
if len(pi_password) > 0:
    configure_commande += " --password=\"" + pi_password + "\""

if interactive_enable:
    r_u_sure(configure_commande)

## FLASH
flash_commande = "3-flash"
flash_commande += " --device=" + flash_position

if interactive_enable:
    r_u_sure(flash_commande)

## USE

scripts="scripts/"

os.system(scripts + get_commande)
os.system(scripts + configure_commande)
os.system(scripts + flash_commande)
