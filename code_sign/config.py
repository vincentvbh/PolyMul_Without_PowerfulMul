
import argparse
import multiprocessing
import platform

class Settings:

    parser = argparse.ArgumentParser()

    parser.add_argument('--jobs', default = multiprocessing.cpu_count())
    parser.add_argument('--platform', default = "nucleo-f207zg")

    if platform.system() == "Darwin":
        parser.add_argument('--device', default = "/dev/tty.usbmodem11103")
    else:
        parser.add_argument('--device', default = "/dev/ttyACM0")

    parser.add_argument('--baud_rate', default = 9600)
    parser.add_argument('--clean', default=False, action = 'store_true')

    args = parser.parse_args()

    JOBS = args.jobs
    PLATFORM = args.platform
    SERIAL_DEVICE = args.device
    BAUD_RATE = args.baud_rate
    CLEAN = args.clean

