#! /usr/bin/python
# -*- mode: python; coding: utf-8 -*-
# :Project:  pxpy -- silly tester
# :Source:   $Source: /cvsroot/pxlib/bindings/python/test.py,v $
# :Created:  Thu, May 13 2004 01:48:30 CEST
# :Author:   Lele Gaifax <lele@nautilus.homeip.net>
# :Revision: $Revision: 1.2 $ by $Author: lele $
# :Date:     $Date: 2004/07/19 14:38:04 $
# 

import pxpy

t = pxpy.Table("test/Automezzi.DB")
print t
t.open()
t.setPrimaryIndex("test/Automezzi.PX")
t.setBlobFile("test/Automezzi.MB")

print "Fields: ", t.getFieldsCount()

record = t.record

while t.readRecord():
    for i in range(record.getFieldsCount()):
        f = record.fields[i]
        value = f.getValue()
        print "%s: %s" % (f.fname, value)
    print "================================="
    
