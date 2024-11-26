# define N 256
# define LOGNTT_N 8

# define Q (8380417)
# # R mod^+- Q
# define RmodQ (-4186625)
# # -Q^{-1} mod^+- R
# define Qprime (-58728449)
# # (R^2 mod^+- Q) * Qprime mod^+- R
# define RmodQhi (-2145647103)

# define omegaQ (1753)
# define omegainvQ (731434)

# define INV256 (-32736)


def reduce(tmp, mod):
    if tmp > (mod // 2):
        res = tmp - mod
        return res
    elif tmp < -(mod // 2):
        res = tmp + mod
        return res
    else:
        return tmp

def cal(Q, omegaQ, R):
    # Q = 8380417
    print('// Q = %d' % Q)

    RmodQ = (R) % Q
    # if RmodQ > Q//2:
    #     RmodQ = RmodQ - Q
    # elif RmodQ < -Q//2:
    #     RmodQ = RmodQ + Q
    RmodQ = reduce(RmodQ, Q)
    print('#define RmodQ (%d)' % RmodQ)

    Qprime = -pow(Q, -1, R)
    print('#define Qprime (%d)' % Qprime)

    RmodQhi = (((R)**2 % Q) * Qprime) % (R)
    # if RmodQhi > (R//2):
    #     RmodQhi = RmodQhi - (R)
    # elif RmodQhi < (R//2):
    #     RmodQhi = RmodQhi + (R)
    RmodQhi = reduce(RmodQhi, R)
    print('#define RmodQhi (%d)' % RmodQhi)

    # omegaQ = 1753
    print('#define omegaQ (%d)' % omegaQ)
    omegainvQ = pow(omegaQ, -1, Q)
    # if omegainvQ > (R//2):
    #     omegainvQ = omegainvQ - (R)
    # elif RmodQhi < (R//2):
    #     omegainvQ = omegainvQ + (R)
    omegainvQ = reduce(omegainvQ, Q)
    print('#define omegainvQ (%d)' % omegainvQ)
    
    RsqrmodQ = pow(R, 2, Q)
    RsqrmodQ = reduce(RsqrmodQ, Q)
    print('#define RsqrmodQ (%d)' % RsqrmodQ)

    INV256 = pow(256, -1, Q)
    INV256 = reduce(INV256, Q)
    print('#define INV256 (%d)' % INV256)
    

# for NTT
cal(8380417, 1753, 2**32)
print()
cal(769, 62, 2**16)
print()
cal(3329, 10, 2**16)


# for CRT
Q1 = 7681
Q2 = 10753
R = 2**(16)
Q1_inv = pow(Q1,-1,R)
Q2_inv = pow(Q2,-1,R)
Q1_mont = R % Q1 - Q1
print('#define Q1_MONT (%d)' % Q1_mont)
Q2_mont  = R % Q2 - Q2
mont_pinv = (Q1_inv * Q1_mont) % R
mont_pinv = reduce(mont_pinv, R)
print('#define MONT_PINV (%d)' % mont_pinv)
crt_u = (Q2_mont * pow(Q1,-1,Q2)) % Q2
crt_u = reduce(crt_u, Q2)
print('#define CRT_U (%d)' % crt_u)
crt_u_pinv = (crt_u * Q2_inv) % R
crt_u_pinv = reduce(crt_u_pinv, R)
print('#define CRT_U_PINV (%d)' % crt_u_pinv)