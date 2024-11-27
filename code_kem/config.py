
import argparse
import multiprocessing
import platform

class Settings:

    parser = argparse.ArgumentParser()

    parser.add_argument('--jobs', default = multiprocessing.cpu_count())
    parser.add_argument('--device', default = "stm32f207zg")
    parser.add_argument('--device_config', default = "nucleo-f2.cfg")

    if platform.system() == "Darwin":
        parser.add_argument('--serial_device', default = "/dev/tty.usbmodem11103")
    else:
        parser.add_argument('--serial_device', default = "/dev/ttyACM0")

    parser.add_argument('--baud_rate', default = 9600)
    parser.add_argument('--clean', default=False, action = 'store_true')

    args = parser.parse_args()

    JOBS = args.jobs
    DEVICE = args.device
    DEVICE_CONFIG = args.device_config
    SERIAL_DEVICE = args.serial_device
    BAUD_RATE = args.baud_rate
    CLEAN = args.clean

