#!/usr/bin/env python3

import datetime
import subprocess
import sys
from os.path import exists

import serial
import numpy as np
from config import Settings

crypto_type = "kem"
testtype = "stack"
outFileName = "stack.txt"
iterations = 1
testedList = [["keygen", "keypair stack usage:"],
              ["encap", "encaps stack usage:"],
              ["decap", "decaps stack usage:"]
             ]
schemeList = ["lightsaber", "saber", "firesaber"]
impleList = ["ref", "old", "speed"]
cpu = "m3"

runned = []
skipped = []

def toLog(name, value, k=None):
  return f"{name}: {value}\n"

def getBinary(scheme, impl):
    return f"elf/crypto_{crypto_type}_{scheme}_{impl}_{testtype}.elf"

def getFlash(binary):
    return f"openocd -f nucleo-f2.cfg -c \"program {binary} reset exit\" "

def makeAll():
    if Settings.CLEAN == True:
        subprocess.check_call(f"make clean", shell=True)
    subprocess.check_call(f"make all -j {Settings.JOBS} ITERATIONS={iterations} DEVICE={Settings.DEVICE}", shell=True)

def run_bench(scheme, impl):
    binary = getBinary(scheme, impl)

    if exists(binary) == 0:
        skipped.append(binary)
        print(f"skip {binary}")
        return b""

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"openocd failed --> retry {binary}")
        return run_bench(scheme, impl)

    runned.append(binary)

    # get serial output and wait for '#'
    with serial.Serial(Settings.SERIAL_DEVICE, Settings.BAUD_RATE, timeout=10) as dev:
        iteration = 0
        log = b""
        while iteration < iterations:
            device_output = dev.read()
            if device_output == b'':
                print(f"timeout --> retry {binary}")
                return run_bench(scheme, impl)
            sys.stdout.buffer.write(device_output)
            sys.stdout.flush()
            log += device_output
            if device_output == b'#':
                break
    return log


def parseLog(log, ignoreErrors):
    log = log.decode(errors="ignore")
    if "error" in log.lower() and not ignoreErrors:
        raise Exception("error in scheme. this is very bad.")
    lines = str(log).splitlines()

    def get(lines, key):
        if key in lines:
            return int(lines[1+lines.index(key)])
        else:
            return None

    def cleanNullTerms(d):
        return {
            k:v
            for k, v in d.items()
            if v is not None
        }

    return cleanNullTerms({
            k: get(lines, v)
            for k, v in testedList
    })

def average(results):
    avgs = dict()
    for key in results[0].keys():
        avgs[key] = int(np.array([results[i][key] for i in range(len(results))]).mean())
    return avgs


def bench(scheme, texName, impl, outfile, ignoreErrors=False):
    log    = run_bench(scheme, impl)
    results = []
    try:
        result = parseLog(log, ignoreErrors)
    except:
        print("parsing log failed -> retry")
        return bench(scheme, texName, impl, outfile)
    results.append(result)

    avgResults = average(results)
    print(f"{cpu} results for {scheme} (impl={impl})", file=outfile)

    for key, value in avgResults.items():
        macro = toLog(f"{texName}{key}", value)
        print(macro.strip())
        print(macro, end='', file=outfile)
    print('', file=outfile, flush=True)

with open(outFileName, "w") as outfile:

    now = datetime.datetime.now(datetime.timezone.utc)
    print(f"{testtype} measurements written on {now}; iterations={iterations}\n", file=outfile)

    makeAll()

    for scheme in schemeList:
        for imple in impleList:
            bench(scheme, scheme + cpu + imple, cpu + imple, outfile)

    print("\n======== Runned ========\n")
    print(str.join('\n', runned))
    print("\n======== Skipped ========\n")
    print(str.join('\n', skipped))

