import re
from subprocess import getoutput

DEVICES = getoutput("bluetoothctl devices")
PATTERN = r"Device ([0-9A-Z\:]*) (.*)"

MAC_ADDRS, DEV_NAMES = zip(*re.findall(PATTERN, DEVICES))
DEV_DICT = dict(zip(DEV_NAMES, MAC_ADDRS))

OPTIONS = "\n".join(DEV_NAMES)
SELECTED = getoutput(
    f'echo -e "{OPTIONS}" | rofi -dmenu -p "Select device to try to connect to"'
)
if SELECTED == "":
    exit()
print(f"selected {SELECTED}")

print(getoutput("bluetoothctl connect {}".format(DEV_DICT[SELECTED])))
