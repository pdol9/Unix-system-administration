#!/bin/bash

if [[ $(cut -f 1 -d '.' /proc/uptime) -lt 300 ]]; then echo no; fi

