from __future__ import print_function
from __future__ import absolute_import

import optparse, sys, os, m5
from Caches import *
import constants as ct
from m5.objects import *

# Variable
# 0 - L1D_SIZE = ['32kB', '64kB']
# 1 - L1I_SIZE = ['32kB', '64kB']
# 2 - L2_SIZE = ['128kB', '256kB', '512kB']
# 3 - L1_ASSOC = [2, 4, 8]
# 4 - L2_ASSOC = [4, 8]
# 5 - BP_TYPE = [TournamentBP, BiModeBP, LocalBP]
# 6 - LQ_ENTRIES = [16, 32, 64]
# 7 - SQ_ENTRIES = [16, 32, 64]
# 8 - ROB_ENTRIES = [128, 192]
# 9 - IQ_ENTRIES = [16, 32, 64]

L1D_SIZE = "32kB"
L1I_SIZE = "32kB"
L2_SIZE = "128kB"
L1_ASSOC = 2
L2_ASSOC = 4
BP_TYPE = TournamentBP
LQ_ENTRIES = 16
SQ_ENTRIES = 16
ROB_ENTRIES = 128
IQ_ENTRIES = 16

RANKED = ["2133213123", "2133213323", "2231212123", "1232213323", "2133113123", \
                "2133212223", "2133113323", "2231112123", "1232113323", "2132223313"]


def get_processes(options):
    process = Process(pid = 100)
    process.executable = options.cmd
    process.cmd = [options.cmd]
    return [process]


def config_mem(system):
    # Create interface
    r = system.mem_ranges[0]
    dram_intf = ct.MEM_TYPE()
    dram_intf.range = m5.objects.AddrRange(r.start, size = r.size())

    # Memory Controller
    mem_ctrl = m5.objects.MemCtrl()
    mem_ctrl.dram = dram_intf
    mem_ctrl.port = system.membus.master

    system.mem_ctrls = [mem_ctrl]


def config_cache(system):
    # Set the cache classes    
    dcache_class = L1_DCache
    icache_class = L1_ICache
    l2_cache_class = L2Cache 
    walk_cache_class = PageTableWalkerCache

    # Set the cache line size of the system
    system.cache_line_size = 64

    #L2 Cache
    system.l2 = l2_cache_class(clk_domain=system.cpu_clk_domain,
                                size=L2_SIZE,
                                assoc=L2_ASSOC)

    system.tol2bus = L2XBar(clk_domain = system.cpu_clk_domain)
    system.l2.cpu_side = system.tol2bus.master
    system.l2.mem_side = system.membus.slave

    # L1 Cache
    icache = icache_class(size=L1I_SIZE, assoc=L1_ASSOC)
    dcache = dcache_class(size=L1D_SIZE, assoc=L1_ASSOC)
    iwalkcache = walk_cache_class()
    dwalkcache = walk_cache_class()

    # Connect caches to the cput
    system.cpu.addPrivateSplitL1Caches(icache, dcache, iwalkcache, dwalkcache)
    system.cpu.createInterruptController()
    system.cpu.connectAllPorts(system.tol2bus, system.membus)
        

def run():
    m5.instantiate()
    print("**** REAL SIMULATION ****")
    exit_event = m5.simulate()
    print('Exiting @ tick {} because {}'.format(m5.curTick(), exit_event.getCause()))
    if exit_event.getCode() != 0:
        print("Simulated exit code not 0! Exit code is", exit_event.getCode())


# Parse Args
def parseArgs():
    parser = optparse.OptionParser()
    parser.add_option("-c", "--cmd", default="",
                        help="The binary to run in syscall emulation mode.")
    parser.add_option("-a", "--args", default="1111111111",
                        help="Choosing the different args")
    parser.add_option("-r", "--rank", type="int", default=0,
                      help = "Which of the top 10 configuration")
    (options, args) = parser.parse_args()


    # Handle ranking configuration
    if (options.rank != 0) and (options.rank <= 10): 
        print("Running Rank {} configuration".format(options.rank))
        configuration = RANKED[options.rank - 1]
    else:
        if options.rank != 0:
            print("Only top 10 configurations are supported. Running default configuration.")
        configuration = options.args


    # Arguments
    global L1D_SIZE
    L1D_SIZE = ct.L1D_SIZE[int(configuration[0]) - 1]
    global L1I_SIZE
    L1I_SIZE = ct.L1I_SIZE[int(configuration[1]) - 1]
    global L2_SIZE
    L2_SIZE = ct.L2_SIZE[int(configuration[2]) - 1]
    global L1_ASSOC
    L1_ASSOC = ct.L1_ASSOC[int(configuration[3]) - 1]
    global L2_ASSOC
    L2_ASSOC = ct.L2_ASSOC[int(configuration[4]) - 1]
    global BP_TYPE
    BP_TYPE = ct.BP_TYPE[int(configuration[5]) - 1]
    global LQ_ENTRIES
    LQ_ENTRIES = ct.LQ_ENTRIES[int(configuration[6]) - 1]
    global SQ_ENTRIES
    SQ_ENTRIES = ct.SQ_ENTRIES[int(configuration[7]) - 1]
    global ROB_ENTRIES
    ROB_ENTRIES = ct.ROB_ENTRIES[int(configuration[8]) - 1]
    global IQ_ENTRIES
    IQ_ENTRIES = ct.IQ_ENTRIES[int(configuration[9]) - 1]


    # Process
    if options.cmd:
        multiprocesses = get_processes(options)
    else:
        print("No workload specified. Exiting!\n", file=sys.stderr)
        sys.exit(1)
    return multiprocesses


def constantCode():
    multiprocesses = parseArgs() # Parse args to get the target executable
    system = System(cpu = ct.CPU_MODEL(),
                    mem_mode = ct.MEM_MODE,
                    mem_ranges = [AddrRange(ct.MEM_SIZE)],
                    cache_line_size = ct.CACHE_LINE)

    # Create clock and voltage domains
    system.voltage_domain = VoltageDomain(voltage = '1V')
    system.clk_domain = SrcClockDomain(clock = ct.CLOCK_FREQ, voltage_domain = system.voltage_domain)
    system.cpu_voltage_domain = VoltageDomain()
    system.cpu_clk_domain = SrcClockDomain(clock = '2GHz', voltage_domain = system.cpu_voltage_domain)
    system.cpu.clk_domain = system.cpu_clk_domain # Assign the domains to the CPU

    system.cpu.workload = multiprocesses[0] # Create workload

    system.membus = SystemXBar() # Configure Memory
    system.system_port = system.membus.slave
    config_mem(system)

    system.cpu.numRobs = ct.NUM_ROB
    return system


def variableCode(system):

    system.cpu.LQEntries = LQ_ENTRIES
    system.cpu.SQEntries = SQ_ENTRIES
    system.cpu.numROBEntries = ROB_ENTRIES
    system.cpu.numIQEntries = IQ_ENTRIES
    
    system.cpu.branchPred = BP_TYPE() # Configure BP and Cache
    system.cpu.createThreads()
    config_cache(system)

    # Create root and run simulation
    root = Root(full_system = False, system = system)
    run()

system = constantCode()
variableCode(system)