import re
from subprocess import getoutput

SINKS = getoutput("pactl list sinks")
PATTERN = r"Sink #(\d+)(?:\n|.*?)*Description: ([a-zA-Z0-9 ]+)"

SINK_NUMS, SINK_NAMES = zip(*re.findall(PATTERN, SINKS, re.MULTILINE))
SINK_DICT = dict(zip(SINK_NAMES, SINK_NUMS))

OPTIONS = "\n".join(SINK_NAMES)
SELECTED = getoutput(f'echo -e "{OPTIONS}" | rofi -dmenu -p "Select audio out"')
if SELECTED == "":
    exit()
print(f"selected {SELECTED}")

SINK_INPUTS = getoutput("pacmd list-sink-inputs | grep index").strip()
for line in SINK_INPUTS.split("\n"):
    si = line.split(": ")[1]
    print(f"Changing input {si} to sink {SELECTED}")
    print(getoutput(f"pacmd move-sink-input {si} {SINK_DICT[SELECTED]}"))
