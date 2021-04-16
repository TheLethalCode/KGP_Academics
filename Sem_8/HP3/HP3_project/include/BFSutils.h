#ifndef BFS_UTILS
#define BFS_UTILS

__global__ void BFS_kernel(int , int , int *, int *, int *, int *, int *);

__global__ void queueBfs(int, int *, int *, int *, int *, int, int *, int *, int *);

__global__ void nextLayer(int , int *, int *, int *, int *, int , int *);
__global__ void countDegrees(int *, int *, int *, int , int *, int *);
__global__ void scanDegrees(int , int *, int *);
__global__ void assignVerticesNextQueue(int *, int *, int *, int ,int *,
                                                int *, int *, int *, int);


#endif