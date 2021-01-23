import sys
import struct


def save_sf_model(model):
    name_dicts = {'encoder.word_lut.weight': 'SrcWordEmbed_Embed_W',
                  'encoder.forward_gru.linear_input.weight': 'EncGRUL2R_GRU_W',
                  'encoder.forward_gru.linear_input.bias': 'EncGRUL2R_GRU_B',
                  'encoder.forward_gru.linear_hidden.weight': 'EncGRUL2R_GRU_U',
                  'encoder.backward_gru.linear_input.weight': 'EncGRUR2L_GRU_W',
                  'encoder.backward_gru.linear_input.bias': 'EncGRUR2L_GRU_B',
                  'encoder.backward_gru.linear_hidden.weight': 'EncGRUR2L_GRU_U',
                  'decoder.word_lut.weight': 'TrgWordEmbed_Embed_W',
                  'decoder.rnn.layers.0.linear_input.weight': 'DecGRU_GRU_W',
                  'decoder.rnn.layers.0.linear_input.bias': 'DecGRU_GRU_B',
                  'decoder.rnn.layers.0.linear_hidden.weight': 'DecGRU_GRU_U',
                  'decoder.attn.linear_pre.weight': 'Alignment_ConcatAtt_W',
                  'decoder.attn.linear_pre.bias': 'Alignment_ConcatAtt_B',
                  'decoder.attn.linear_q.weight': 'Alignment_ConcatAtt_U',
                  'decoder.attn.linear_v.weight': 'Alignment_ConcatAtt_v',
                  'decoder.readout.weight': 'Readout_Linear_W',
                  'decoder.readout.bias': 'Readout_Linear_b',
                  'decIniter.initer.weight': 'DecInitial_Linear_W',
                  'decIniter.initer.bias': 'DecInitial_Linear_b',
                  'generator.0.weight': 'Scoring_Linear_W',
                  'generator.0.bias': 'Scoring_Linear_b', }

    nParams = sum([p.nelement() for p in model.parameters()])
    # logger.info('* number of parameters: %d' % nParams)

    b_count = 0
    of = open('model', 'wb')
    for name, param in model.named_parameters():
        # logger.info('[{0}] [{1}] [{2}]'.format(name, param.size(), param.nelement()))
        SF_name = name_dicts[name]
        # print(SF_name)
        byte_name = bytes(SF_name, 'utf-16-le')
        name_size = len(byte_name)
        byte_name_size = name_size.to_bytes(4, sys.byteorder)
        of.write(byte_name_size)
        of.write(byte_name)
        b_count += len(byte_name_size)
        b_count += len(byte_name)
        d = param.data.cpu()
        if param.dim() == 1:
            d = d.unsqueeze(0)
        elif not SF_name.endswith('Embed_W'):
            d = d.transpose(0, 1).contiguous()
        for dim in d.size():
            dim_byte = dim.to_bytes(4, sys.byteorder)
            of.write(dim_byte)
            b_count += len(dim_byte)
        datas = d.view(-1).numpy().tolist()
        float_array = struct.pack('f' * len(datas), *datas)
        b_count += len(float_array)
        of.write(float_array)
    of.close()
    # print('Total write {0} bytes'.format(b_count))
