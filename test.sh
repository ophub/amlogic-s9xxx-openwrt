#!/bin/bash

FDTFILE="meson-sssm1-x96-max-plus-100m.dtb"

if [[ "${FDTFILE}" != *-sm1-* ]]; then
  echo "不包含"
else
  echo "包含"
fi