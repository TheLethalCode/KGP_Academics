#!/bin/bash
set -e

OUTDIR=output/
EXEC=build/X86/gem5.opt
SCRIPT=HPCA/exSe.py
CMD=HPCA/qsort

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

SIZE=(3 2 3 3 3 2 3 3 2 2) # Sizes in reverse
TOTAL=11664
for (( i=0; i<11664; i++ ))
do
    args=""
    valCpy=$i
    for s in "${SIZE[@]}"
    do
        rem=$(( $valCpy % $s ))
        rem=$(( $rem + 1 ))
        valCpy=$(( $valCpy / $s )) 
        args="${rem}${args}"
    done
    ${EXEC} --outdir=${OUTDIR}num-${i}_args-${args} ${SCRIPT} --cmd=${CMD} --args=${args}
    echo "Sim Number ${i} Done"
done
