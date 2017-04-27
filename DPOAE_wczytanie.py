#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
from io import StringIO

import numpy as np
import pandas

flag = 0
i = 0
a = 0
# data = np.empty_like((6, 52))
datas = ''
with open('dpoae13.txt', newline='') as csvfile:
    dpoaereader = csv.reader(csvfile)
    for row in dpoaereader:
        a += 1
        if 'TestData' in row:
            b = a + 1  # in which line data starts
            NoRows = (row[1])
            flag = 1
            continue
        if 'TestSession' in row:
            flag = 0
            NoSessions = (row[1])
            print('done', i)
        if flag and (b != a + 1):
            print(row)
            # data[i] = row
            # datas += row
            datas += '/n'
            i += 1
NamesList = 52 * ['a']
session = open('dpoae13.txt').read()
x = session.split('"TestData",6')[1]
x2 = x.split('"TestSession"')[0]
data = np.array(x2)
print(np.shape(data))

x3 = pandas.read_csv(StringIO(x2.strip('"')), names=NamesList, header=None)
print(x3)
