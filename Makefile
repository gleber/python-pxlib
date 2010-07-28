# -*- Makefile -*-
# :Project:  pxpy -- Makefile
# :Source:   $Source: /cvsroot/pxlib/bindings/python/Makefile,v $
# :Created:  Sun, Apr 04 2004 00:13:57 CEST
# :Author:   Lele Gaifax <lele@nautilus.homeip.net>
# :Revision: $Revision: 1.2 $ by $Author: lele $
# :Date:     $Date: 2004/07/19 14:38:04 $
# 

all:
	python Setup.py build_ext --inplace

clean:
	rm -f *.c *.o *.so *~ core
	rm -rf build
