#!/usr/bin/python

f = open('data_ram.list', 'w')

for i in range(2**16):
  f.write('{:x}\n'.format(i))
