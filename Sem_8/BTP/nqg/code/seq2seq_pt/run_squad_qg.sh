#!/bin/bash

set -x

DATAHOME=${@:(-2):1}
EXEHOME=${@:(-1):1}

SAVEPATH=${DATAHOME}/models/NQG_plus

mkdir -p ${SAVEPATH}

cd ${EXEHOME}

python train.py \
       -save_path ${SAVEPATH} -log_home ${SAVEPATH} \
       -online_process_data \
       -train_src ${DATAHOME}/train/train.source.txt -src_vocab ${DATAHOME}/train/vocab.txt.20k \
       -train_bio ${DATAHOME}/train/train.bio.txt -bio_vocab ${DATAHOME}/train/bio.vocab.txt \
       -train_feats ${DATAHOME}/train/train.pos.txt ${DATAHOME}/train/train.ner.txt ${DATAHOME}/train/train.case.txt \
       -feat_vocab ${DATAHOME}/train/feat.vocab.txt \
       -train_tgt ${DATAHOME}/train/train.target.txt -tgt_vocab ${DATAHOME}/train/vocab.txt.20k \
       -layers 1 \
       -max_sent_length 500 \
       -enc_rnn_size 512 -brnn \
       -word_vec_size 300 \
       -dropout 0.5 \
       -batch_size 64 \
       -beam_size 5 \
       -epochs 20 -optim adam -learning_rate 0.001 \
       -gpus 0 \
       -curriculum 0 -extra_shuffle \
       -start_eval_batch 1000 -eval_per_batch 500 -halve_lr_bad_count 3 \
       -seed 12345 -cuda_seed 12345 \
       -log_interval 100 \
       -dev_input_src ${DATAHOME}/dev/dev.source.txt \
       -dev_bio ${DATAHOME}/dev/dev.bio.txt \
       -dev_feats ${DATAHOME}/dev/dev.pos.txt ${DATAHOME}/dev/dev.ner.txt ${DATAHOME}/dev/dev.case.txt \
       -dev_ref ${DATAHOME}/dev/dev.target.txt

