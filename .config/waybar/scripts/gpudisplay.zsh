#!/usr/bin/zsh
nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,name --format=csv,nounits,noheader | sed -E 's/([0-9]+),\s*([0-9]+),\s*(.*)/{"text":"\1% 🌡️\2°C","tooltip":"\3"}/'
