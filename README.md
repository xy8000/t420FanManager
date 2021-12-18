# t420FanManager
Manager to disengage the fan of a Lenovo T420 automatically. It will disengage the fan after reaching a certain temperature.
#	Params:
1. $1 = Manual high temp
1. $2 = Seconds between updates in Seconds
# Additional Information
- Only for Lenovo-PCs (tested on T420)
- Only works for Linux
- `sensors` should be available
# How does it work
- **Disengage** fan: `echo level disengaged > /proc/acpi/ibm/fan`
- Setting fan to **auto**: `"echo level auto > /proc/acpi/ibm/fan`
