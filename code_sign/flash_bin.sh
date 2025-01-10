#!/bin/bash

openocd -f nucleo-f2.cfg -c "program $1 reset exit"