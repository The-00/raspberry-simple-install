# to unset a value : ""

# pi
pi_password             = "bestBoy"                      # password set with salt 'pilog' (optional -> keep "raspberry")
pi_hostname             = "BESTBOY"                      # the raspberry pi hostname (optional -> keep "raspberrypi")
pi_timezone             = "Europe/Paris"                 # cocorico | the raspberry pi timezone (optional -> keep "Europe/Paris")

# image
image_latest            = True                           # if false, check url
image_light             = True                           # if false, get full version
image_url               = ""                             # you can pick an image here : https://downloads.raspberrypi.org/ -> you need the zip file (optional)

# ssh
ssh_path                = "/home/USER/.ssh/id_rsa.pub"   # path of you ssh key, please generate one if you don't have one

# wifi
wifi_enable             = True                           # enable wifi access (raspberry 3 or +)
wifi_SSID               = "MyWifiName"                   # wifi SSID
wifi_psw                = "MyW1f1P455"                   # wifi password
wifi_fix_ip             = "192.168.1.42/24"              # raspberry expected ip + mask (optional)
wifi_default_gateway_ip = "192.168.1.1"                  # router (box, phone with internet acces, other) (optional)

# flash
flash_position          = "/dev/mmcblk0"                 # the position of the device to flash

# interactive
interactive_enable      = True                           # interactive version of the script

# advanced
advanced_script         = "src/script_ex.sh"             # path to script, if you want somthing to be executed on the image before the first use of the raspberry
                                                         # (git clone, echo things) (optional)
