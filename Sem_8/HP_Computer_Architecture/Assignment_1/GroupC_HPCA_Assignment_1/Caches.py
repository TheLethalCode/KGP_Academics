from __future__ import print_function
from __future__ import absolute_import
from m5.objects import *
import constants as ct


class L1Cache(Cache):
    assoc = 2
    tag_latency = ct.L1_TAG_LATENCY
    data_latency = ct.L1_DATA_LATENCY
    response_latency = ct.L1_RESPONSE_LATENCY
    mshrs = ct.L1_MSHRS
    tgts_per_mshr = ct.L1_TGSTS_PER_MSHR


class L1_ICache(L1Cache):
    is_read_only = True
    writeback_clean = True


class L1_DCache(L1Cache):
    pass


class L2Cache(Cache):
    assoc = 8
    tag_latency = ct.L2_TAG_LATENCY
    data_latency = ct.L2_DATA_LATENCY
    response_latency = ct.L2_RESPONSE_LATENCY
    mshrs = ct.L2_MSHRS
    tgts_per_mshr = ct.L2_TGSTS_PER_MSHR
    write_buffers = 8


class IOCache(Cache):
    assoc = 8
    tag_latency = 50
    data_latency = 50
    response_latency = 50
    mshrs = 20
    size = '1kB'
    tgts_per_mshr = 12


class PageTableWalkerCache(Cache):
    assoc = 2
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 10
    size = '1kB'
    tgts_per_mshr = 12
    is_read_only = False
    