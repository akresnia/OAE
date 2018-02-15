#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np

NamesList = 52 * ['a']
session = open('dpoae13.txt').read()
x = session.split('"TestData",6')[1]
x2 = x.split('"TestSession"')[0]
data = np.array(x2.strip('"'))
print(np.shape(data))

