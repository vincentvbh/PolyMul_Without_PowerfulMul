DEVICE=stm32l100rct6

EXCLUDED_SCHEMES = \
    mupq/pqclean/crypto_kem/frodokem640% \
    mupq/pqclean/crypto_kem/frodokem976% \
    mupq/pqclean/crypto_kem/frodokem1344% \
    mupq/pqclean/crypto_kem/hqc-192-1-cca2% \
    mupq/pqclean/crypto_kem/hqc-192-2-cca2% \
    mupq/pqclean/crypto_kem/hqc-256-1-cca2% \
    mupq/pqclean/crypto_kem/hqc-256-2-cca2% \
    mupq/pqclean/crypto_kem/hqc-256-3-cca2% \
    mupq/pqclean/crypto_kem/mceliece% \
    mupq/pqclean/crypto_sign/rainbow% \
    mupq/crypto_sign/falcon-512% \
    mupq/crypto_sign/falcon-512-tree% \
    mupq/crypto_sign/falcon-1024% \
    mupq/crypto_sign/falcon-1024-tree% \
    mupq/pqclean/crypto_sign/sphincs-sha256-128% \
    mupq/pqclean/crypto_sign/sphincs-shake256-128% \
    mupq/pqclean/crypto_sign/sphincs-haraka-128% \
    mupq/pqclean/crypto_sign/sphincs-sha256-192% \
    mupq/pqclean/crypto_sign/sphincs-shake256-192% \
    mupq/pqclean/crypto_sign/sphincs-haraka-192% \
    mupq/pqclean/crypto_sign/sphincs-sha256-256% \
    mupq/pqclean/crypto_sign/sphincs-shake256-256% \
    mupq/pqclean/crypto_sign/sphincs-haraka-256%

include mk/opencm3.mk
