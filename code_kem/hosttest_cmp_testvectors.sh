#!/bin/bash

diff <(./obj_armv7/lightsaber_m3ref_testvectors) <(./obj_armv7/lightsaber_m3old_testvectors)
diff <(./obj_armv7/lightsaber_m3ref_testvectors) <(./obj_armv7/lightsaber_m3speed_testvectors)

diff <(./obj_armv7/saber_m3ref_testvectors) <(./obj_armv7/saber_m3old_testvectors)
diff <(./obj_armv7/saber_m3ref_testvectors) <(./obj_armv7/saber_m3speed_testvectors)

diff <(./obj_armv7/firesaber_m3ref_testvectors) <(./obj_armv7/firesaber_m3old_testvectors)
diff <(./obj_armv7/firesaber_m3ref_testvectors) <(./obj_armv7/firesaber_m3speed_testvectors)

