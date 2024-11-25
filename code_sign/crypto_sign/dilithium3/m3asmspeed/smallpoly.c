#include "smallpoly.h"
#include "smallntt.h"
// small NTT for computing cs
void poly_small_ntt_precomp(smallpoly *out, smallpoly *out2, poly *in) {
  for (int i = 0; i < N; i++)
  {
    out->coeffs[i] = in->coeffs[i];
  }
  small_ntt(out->coeffs);
  small_point_mul(out2->coeffs, out->coeffs);
}


void polyvecl_small_ntt(smallpoly v[L]) {
  unsigned int i;

  for(i = 0; i < L; ++i)
    small_ntt(v[i].coeffs);
}


void polyveck_small_ntt(smallpoly v[K]) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    small_ntt(v[i].coeffs);
}



void poly_small_basemul_invntt(poly *r, const smallpoly *a, const smallpoly *aprime, const smallpoly *b){
    // re-use the buffer
    smallpoly *tmp = (smallpoly *)r;
    small_asymmetric_mul(tmp->coeffs, b->coeffs, a->coeffs, aprime->coeffs);
    small_invntt_tomont(tmp->coeffs);

    // buffer is the same, so we neeed to be careful
     for (int j = N - 1; j >= 0; j--)
     {
        r->coeffs[j] = tmp->coeffs[j];
     }
}

void polyvecl_small_basemul_invntt(polyvecl *r, const smallpoly *a, const smallpoly *aprime, const smallpoly b[L])
{
    unsigned int i;
    for (i = 0; i < L; i++)
    {
      poly_small_basemul_invntt(&r->vec[i], a, aprime, &b[i]);
    }
}

void polyveck_small_basemul_invntt(polyveck* r,
                                   const smallpoly* a,
                                   const smallpoly* aprime,
                                   const smallpoly b[K])
{
  unsigned int i;
  for (i = 0; i < K; i++) {
    poly_small_basemul_invntt(&r->vec[i], a, aprime, &b[i]);
  }
}
// double-moduli NTT for computing ct
void poly_double_ntt_precomp(poly *out, poly *in)
{
    double_ntt((int16_t*)in->coeffs);
    double_point_mul((int16_t *)out->coeffs, (int16_t *)in->coeffs);
}

void poly_double_ntt(poly *v)
{
    double_ntt((int16_t *)v->coeffs);
}

void polyvecl_double_ntt(polyvecl *v)
{
    unsigned int i;

    for (i = 0; i < L; ++i)
        double_ntt((int16_t *)v->vec[i].coeffs);
}

void polyveck_double_ntt(polyveck *v)
{
    unsigned int i;

    for (i = 0; i < K; ++i)
        double_ntt((int16_t *)v->vec[i].coeffs);
}

void poly_double_basemul_invntt(poly *r, const poly *a, const poly *aprime, const poly *b)
{
    int16_t tmp[2*N];
    double_asymmetric_mul(tmp, (int16_t *)b->coeffs, (int16_t *)a->coeffs, (int16_t *)aprime->coeffs);
    double_invntt(tmp);
    double_CRT(r->coeffs, tmp, tmp + N); // output and input buffs cannot be the same
}

void polyvecl_double_basemul_invntt(polyvecl *r, const poly *a, const poly *aprime, const poly b[L])
{
    unsigned int i;
    for (i = 0; i < L; i++)
    {
      poly_double_basemul_invntt(&r->vec[i], a, aprime, &b[i]);
    }
}

void polyveck_double_basemul_invntt(polyveck* r, const poly* a, const poly* aprime, const polyveck* b)
{
    unsigned int i;
    for (i = 0; i < K; i++) {
      poly_double_basemul_invntt(&r->vec[i], a, aprime, &b->vec[i]);
    }
}



void polyeta_unpack_small(smallpoly *r, const uint8_t *a) {
  unsigned int i;

#if ETA == 2
  for(i = 0; i < N/8; ++i) {
    r->coeffs[8*i+0] =  (a[3*i+0] >> 0) & 7;
    r->coeffs[8*i+1] =  (a[3*i+0] >> 3) & 7;
    r->coeffs[8*i+2] = ((a[3*i+0] >> 6) | (a[3*i+1] << 2)) & 7;
    r->coeffs[8*i+3] =  (a[3*i+1] >> 1) & 7;
    r->coeffs[8*i+4] =  (a[3*i+1] >> 4) & 7;
    r->coeffs[8*i+5] = ((a[3*i+1] >> 7) | (a[3*i+2] << 1)) & 7;
    r->coeffs[8*i+6] =  (a[3*i+2] >> 2) & 7;
    r->coeffs[8*i+7] =  (a[3*i+2] >> 5) & 7;

    r->coeffs[8*i+0] = ETA - r->coeffs[8*i+0];
    r->coeffs[8*i+1] = ETA - r->coeffs[8*i+1];
    r->coeffs[8*i+2] = ETA - r->coeffs[8*i+2];
    r->coeffs[8*i+3] = ETA - r->coeffs[8*i+3];
    r->coeffs[8*i+4] = ETA - r->coeffs[8*i+4];
    r->coeffs[8*i+5] = ETA - r->coeffs[8*i+5];
    r->coeffs[8*i+6] = ETA - r->coeffs[8*i+6];
    r->coeffs[8*i+7] = ETA - r->coeffs[8*i+7];
  }
#elif ETA == 4
  for(i = 0; i < N/2; ++i) {
    r->coeffs[2*i+0] = a[i] & 0x0F;
    r->coeffs[2*i+1] = a[i] >> 4;
    r->coeffs[2*i+0] = ETA - r->coeffs[2*i+0];
    r->coeffs[2*i+1] = ETA - r->coeffs[2*i+1];
  }
#endif
}

void polyt0_unpack_small(poly* r, const uint8_t* a)
{
  int16_t* rp = (int16_t*) r->coeffs;
  unsigned int i;

  for (i = 0; i < N / 8; ++i) {
    rp[8 * i + 0] = a[13 * i + 0];
    rp[8 * i + 0] |= (uint32_t) a[13 * i + 1] << 8;
    rp[8 * i + 0] &= 0x1FFF;

    rp[8 * i + 1] = a[13 * i + 1] >> 5;
    rp[8 * i + 1] |= (uint32_t) a[13 * i + 2] << 3;
    rp[8 * i + 1] |= (uint32_t) a[13 * i + 3] << 11;
    rp[8 * i + 1] &= 0x1FFF;

    rp[8 * i + 2] = a[13 * i + 3] >> 2;
    rp[8 * i + 2] |= (uint32_t) a[13 * i + 4] << 6;
    rp[8 * i + 2] &= 0x1FFF;

    rp[8 * i + 3] = a[13 * i + 4] >> 7;
    rp[8 * i + 3] |= (uint32_t) a[13 * i + 5] << 1;
    rp[8 * i + 3] |= (uint32_t) a[13 * i + 6] << 9;
    rp[8 * i + 3] &= 0x1FFF;

    rp[8 * i + 4] = a[13 * i + 6] >> 4;
    rp[8 * i + 4] |= (uint32_t) a[13 * i + 7] << 4;
    rp[8 * i + 4] |= (uint32_t) a[13 * i + 8] << 12;
    rp[8 * i + 4] &= 0x1FFF;

    rp[8 * i + 5] = a[13 * i + 8] >> 1;
    rp[8 * i + 5] |= (uint32_t) a[13 * i + 9] << 7;
    rp[8 * i + 5] &= 0x1FFF;

    rp[8 * i + 6] = a[13 * i + 9] >> 6;
    rp[8 * i + 6] |= (uint32_t) a[13 * i + 10] << 2;
    rp[8 * i + 6] |= (uint32_t) a[13 * i + 11] << 10;
    rp[8 * i + 6] &= 0x1FFF;

    rp[8 * i + 7] = a[13 * i + 11] >> 3;
    rp[8 * i + 7] |= (uint32_t) a[13 * i + 12] << 5;
    rp[8 * i + 7] &= 0x1FFF;

    rp[8 * i + 0] = (1 << (D - 1)) - rp[8 * i + 0];
    rp[8 * i + 1] = (1 << (D - 1)) - rp[8 * i + 1];
    rp[8 * i + 2] = (1 << (D - 1)) - rp[8 * i + 2];
    rp[8 * i + 3] = (1 << (D - 1)) - rp[8 * i + 3];
    rp[8 * i + 4] = (1 << (D - 1)) - rp[8 * i + 4];
    rp[8 * i + 5] = (1 << (D - 1)) - rp[8 * i + 5];
    rp[8 * i + 6] = (1 << (D - 1)) - rp[8 * i + 6];
    rp[8 * i + 7] = (1 << (D - 1)) - rp[8 * i + 7];

    rp[8 * i + 0 + N] = rp[8 * i + 0];
    rp[8 * i + 1 + N] = rp[8 * i + 1];
    rp[8 * i + 2 + N] = rp[8 * i + 2];
    rp[8 * i + 3 + N] = rp[8 * i + 3];
    rp[8 * i + 4 + N] = rp[8 * i + 4];
    rp[8 * i + 5 + N] = rp[8 * i + 5];
    rp[8 * i + 6 + N] = rp[8 * i + 6];
    rp[8 * i + 7 + N] = rp[8 * i + 7]; // two copies
  }

}


