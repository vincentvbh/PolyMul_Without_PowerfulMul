#!/bin/bash

diff <(./obj_armv7/crypto_kem_lightsaber_m3ref_testvectors) <(./obj_armv7/crypto_kem_lightsaber_m3old_testvectors)
diff <(./obj_armv7/crypto_kem_lightsaber_m3ref_testvectors) <(./obj_armv7/crypto_kem_lightsaber_m3speed_testvectors)

diff <(./obj_armv7/crypto_kem_saber_m3ref_testvectors) <(./obj_armv7/crypto_kem_saber_m3old_testvectors)
diff <(./obj_armv7/crypto_kem_saber_m3ref_testvectors) <(./obj_armv7/crypto_kem_saber_m3speed_testvectors)

diff <(./obj_armv7/crypto_kem_firesaber_m3ref_testvectors) <(./obj_armv7/crypto_kem_firesaber_m3old_testvectors)
diff <(./obj_armv7/crypto_kem_firesaber_m3ref_testvectors) <(./obj_armv7/crypto_kem_firesaber_m3speed_testvectors)

