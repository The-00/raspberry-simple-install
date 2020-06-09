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
    if len(wifi_fix_ip)>0 and len(wifi_default_gateway_ip):
        configure_commande += " --my-ip=\"" + wifi_fix_ip + "\""
        configure_commande += " --router-ip=\"" + wifi_default_gateway_ip + "\""
if len(ssh_path) > 0:
    configure_commande += " --ssh=\"" + ssh_path + "\""
if len(pi_password) > 0:
    configure_commande += " --password=\"" + pi_password + "\""
if len(pi_hostname) > 0:
    configure_commande += " --hostname=\"" + pi_hostname + "\""
if len(pi_timezone) > 0:
    configure_commande += " --timezone=\"" + pi_timezone + "\""
if len(advanced_script)>0:
    configure_commande += " --script=\"" + advanced_script + "\""

if interactive_enable:
    r_u_sure(configure_commande)

## FLASH
flash_commande = "3-flash"
flash_commande += " --device=\"" + flash_position +"\""

if interactive_enable:
    r_u_sure(flash_commande)

## USE

scripts="scripts/"

if interactive_enable:
    sure = input("autorun ? [Y|n]")
    if not sure.lower() in ["", "y", "yes"]:
        print("you can run thoses manually with:")
        print(scripts + get_commande)
        print("sudo " + scripts + configure_commande)
        print("sudo " + scripts + flash_commande)
        exit(0)

os.system(scripts + get_commande)
os.system("sudo " + scripts + configure_commande)
os.system("sudo " + scripts + flash_commande)
