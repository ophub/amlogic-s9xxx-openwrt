#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os

def get_soc_temp():
    files = ('/sys/devices/virtual/thermal/thermal_zone0/temp',
             '/sys/devices/platform/scpi/scpi:sensors/hwmon/hwmon0/temp1_input',
            )
    result = 'Unknown'
    for file in files:
        if os.access(file, os.F_OK) and os.access(file, os.R_OK):
            f = open(file)
            temp = f.readline().strip('\n')
            result = "{:.1f}℃".format(float(temp) / 1000)
            f.close()
            break

    return result


def get_cpu_freq():
    files = ('/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq',)
    result = 'Unknown'
    for file in files:
        if os.access(file, os.F_OK) and os.access(file, os.R_OK):
            f = open(file)
            freq = f.readline().strip('\n')
            result = "{:.0f}Mhz".format(float(freq) / 1000)
            f.close()
            break

    return result

if __name__ == '__main__':
    print(get_cpu_freq() + ' / ' + get_soc_temp())
