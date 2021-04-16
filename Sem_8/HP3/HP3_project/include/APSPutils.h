#ifndef APSP_UTILS
#define APSP_UTILS

// FW Constants
#define BLOCK_SIZE 16

__global__ void APSP_kernel1(int*, int, int);

__global__ void _blocked_fw_independent_ph(const int, size_t, const int, int* const);
__global__ void _blocked_fw_partial_dependent_ph(const int, size_t, const int, int* const);
__global__ void _blocked_fw_double_dependent_ph(const int, size_t, const int, int* const);

#endif