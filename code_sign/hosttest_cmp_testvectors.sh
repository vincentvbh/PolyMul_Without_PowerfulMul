#!/bin/bash

diff <(./obj_armv7/crypto_sign_dilithium2_m3ref_testvectors) <(./obj_armv7/crypto_sign_dilithium2_m3plant_testvectors)
diff <(./obj_armv7/crypto_sign_dilithium2_m3ref_testvectors) <(./obj_armv7/crypto_sign_dilithium2_m3asmspeed_testvectors)

diff <(./obj_armv7/crypto_sign_dilithium3_m3ref_testvectors) <(./obj_armv7/crypto_sign_dilithium3_m3plant_testvectors)
diff <(./obj_armv7/crypto_sign_dilithium3_m3ref_testvectors) <(./obj_armv7/crypto_sign_dilithium3_m3asmspeed_testvectors)

diff <(./obj_armv7/crypto_sign_dilithium5_m3plant_testvectors) <(./obj_armv7/crypto_sign_dilithium5_m3asmspeed_testvectors)

