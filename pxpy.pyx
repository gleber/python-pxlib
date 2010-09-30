#  -*- Pyrex -*-
# :Project:  pxpy -- Python wrapper around pxlib
# :Source:   $Source: /cvsroot/pxlib/bindings/python/pxpy.pyx,v $
# :Created:  Sun, Apr 04 2004 00:20:28 CEST
# :Author:   Lele Gaifax <lele@nautilus.homeip.net>
# :Revision: $Revision: 1.6 $ by $Author: lele $
# :Date:     $Date: 2004/09/25 01:18:17 $
#

"""
Python wrapper around pxlib.

This module, written in Pyrex_, allow to read data from Paradox tables
using the pxlib_ library.

.. _pyrex: http://www.cosc.canterbury.ac.nz/~greg/python/Pyrex/
.. _pxlib: http://pxlib.sourceforge.net/
"""

import datetime
#from libc.stdlib cimport *


cdef extern from "Python.h":
    object PyString_FromStringAndSize(char *s, int len)
    object PyString_Decode(char *s, int len, char *encoding, char *errors)
    object PyString_FromStringAndSize(char *v, int len)
    object PyString_AsDecodedObject(object str, char *encoding, char *errors)


cdef extern from "string.h":
    int strnlen(char *s, int maxlen)

cdef extern from "paradox.h":
    ctypedef enum fieldtype_t:
        pxfAlpha = 0x01
        pxfDate = 0x02
        pxfShort = 0x03
        pxfLong = 0x04
        pxfCurrency = 0x05
        pxfNumber = 0x06
        pxfLogical = 0x09
        pxfMemoBLOb = 0x0C
        pxfBLOb = 0x0D
        pxfFmtMemoBLOb = 0x0E
        pxfOLE = 0x0F
        pxfGraphic = 0x10
        pxfTime = 0x14
        pxfTimestamp = 0x15
        pxfAutoInc = 0x16
        pxfBCD = 0x17
        pxfBytes = 0x18
        pxfNumTypes = 0x18

    ctypedef enum filetype_t:
        pxfFileTypIndexDB = 0
        pxfFileTypPrimIndex = 1
        pxfFileTypNonIndexDB = 2
        pxfFileTypNonIncSecIndex = 3
        pxfFileTypSecIndex = 4
        pxfFileTypIncSecIndex = 5
        pxfFileTypNonIncSecIndexG = 6
        pxfFileTypSecIndexG =       7
        pxfFileTypIncSecIndexG =    8

    ctypedef struct pxfield_t:
        char *px_fname
        char px_ftype
        int px_flen
        int px_fdc

    ctypedef struct pxhead_t:
        char *px_tablename
        int px_recordsize
        char px_filetype
        int px_fileversion
        int px_numrecords
        int px_theonumrecords
        int px_numfields
        int px_maxtablesize
        int px_headersize
        int px_fileblocks
        int px_firstblock
        int px_lastblock
        int px_indexfieldnumber
        int px_indexroot
        int px_numindexlevels
        int px_writeprotected
        int px_doscodepage
        int px_primarykeyfields
        char px_modifiedflags1
        char px_modifiedflags2
        char px_sortorder
        int px_autoinc
        int px_fileupdatetime
        char px_refintegrity
        pxfield_t *px_fields

    ctypedef struct pxdoc_t:
        char *px_name
        pxhead_t *px_head
        char *targetencoding
        void *(*malloc)(pxdoc_t *p, unsigned int size, char *caller)
        void  (*free)(pxdoc_t *p, void *mem)

    ctypedef struct pxdatablockinfo_t
    ctypedef struct pxblob_t:
        char *px_name
        pxdoc_t * pxdoc

    ctypedef struct pxpindex_t
    ctypedef struct pxstream_t

    pxdoc_t *PX_new()
    pxdoc_t* PX_new2(void  (*errorhandler)(pxdoc_t *p, int type, char *msg, void *data),
                     void* (*allocproc)(pxdoc_t *p, size_t size, char *caller),
                     void* (*reallocproc)(pxdoc_t *p, void *mem, size_t size, char *caller),
                     void  (*freeproc)(pxdoc_t *p, void *mem))
    char *PX_strdup(pxdoc_t *pxdoc, char *str)
    int PX_open_file(pxdoc_t *pxdoc, char *filename)
    int PX_create_file(pxdoc_t *pxdoc, pxfield_t *px_fields, unsigned int numfields,  char *filename, int type)
    int PX_read_primary_index(pxdoc_t *pindex)
    int PX_add_primary_index(pxdoc_t *pxdoc, pxdoc_t *pindex)
    int PX_set_targetencoding(pxdoc_t *pxdoc, char *encoding)
    int PX_set_inputencoding(pxdoc_t *pxdoc, char *encoding)
    pxblob_t *PX_new_blob(pxdoc_t *pxdoc)
    int PX_open_blob_file(pxblob_t *pxdoc, char *filename)
    int PX_close(pxdoc_t *pxdoc)
    int PX_close_blob(pxblob_t *pxdoc)
    void *PX_get_record(pxdoc_t *pxdoc, int recno, void *data)
    void *PX_get_record2(pxdoc_t *pxdoc, int recno, void *data, int *deleted, pxdatablockinfo_t *pxdbinfo)
    int PX_get_data_alpha(pxdoc_t *pxdoc, void *data, int len, char **value)
    int PX_get_data_bytes(pxdoc_t *pxdoc, void *data, int len, char **value)
    int PX_get_data_double(pxdoc_t *pxdoc, void *data, int len, double *value)
    int PX_get_data_long(pxdoc_t *pxdoc, void *data, int len, long *value)
    int PX_get_data_short(pxdoc_t *pxdoc, void *data, int len, short int *value)
    int PX_get_data_byte(pxdoc_t *pxdoc, void *data, int len, char *value)

    int PX_put_record(pxdoc_t *pxdoc, char *data)

    void PX_put_data_alpha(pxdoc_t *pxdoc, char *data, int len, char *value)
    void PX_put_data_double(pxdoc_t *pxdoc, char *data, int len, double value)
    void PX_put_data_long(pxdoc_t *pxdoc, char *data, int len, int value)
    void PX_put_data_short(pxdoc_t *pxdoc, char *data, int len, short int value)

    char *PX_read_blobdata(pxblob_t *pxblob, void *data, int len, int *mod, int *blobsize)
    void PX_SdnToGregorian(long int sdn, int *pYear, int *pMonth, int *pDay)
    long int PX_GregorianToSdn(int year, int month, int day)

cdef void errorhandler(pxdoc_t *p, int type, char *msg, void *data):
    print 'error', type, msg

cdef class PXDoc:
    """
    Basic wrapper to 'pxdoc_t' based objects.
    """

    cdef pxdoc_t *doc
    cdef char *filename
    cdef char isopen

    def __init__(self, filename):
        """
        Create a PXDoc instance, associated to the given external filename.
        """

        self.filename = filename
        self.doc = PX_new2(&errorhandler, NULL, NULL, NULL)
        self.isopen = 0

    def open(self):
        """
        Open the data file.
        """

        if PX_open_file(self.doc, self.filename)<0:
            raise Exception("Couldn't open `%s`" % self.filename)
        self.isopen = 1

    def close(self):
        """
        Close the data file if needed.
        """

        if self.isopen:
            PX_close(self.doc)
            self.isopen = 0

    def setTargetEncoding(self, encoding):
        PX_set_targetencoding(self.doc, encoding)

    def setInputEncoding(self, encoding):
        PX_set_inputencoding(self.doc, encoding)

    def __dealloc__(self):
        """
        Close the data file
        """

        self.close()


cdef class BlobFile:
    """
    External BLOb file.
    """

    cdef pxblob_t *blob
    cdef char *filename
    cdef char isopen

    def __init__(self, PXDoc table, filename):
        """
        Create a new BlobFile instance, associated to the given external file.
        """

        self.filename = filename
        self.blob = PX_new_blob(table.doc)
        self.isopen = 0

    def open(self):
        """
        Actually open the external blob file.
        """

        if PX_open_blob_file(self.blob, self.filename)<0:
            raise Exception("Couldn't open blob `%s`" % self.filename)
        self.isopen = 1

    def close(self):
        """
        Close the external blob file, if needed.
        """

        if self.isopen:
            PX_close_blob(self.blob)
            self.isopen = 0

    def __dealloc__(self):
        """
        Close the external blob file
        """

        self.close()

cdef class PrimaryIndex(PXDoc):
    """
    The primary index file.
    """

    def open(self):
        """
        Open the primary index file.
        """

        PXDoc.open(self)
        if PX_read_primary_index(self.doc)<0:
            raise Exception("Couldn't read primary index `%s`" % self.filename)


cdef class Record


cdef class Table(PXDoc):
    """
    A `Table` represent a Paradox table, with primary index and blob file.

    An instance has notion about the current record number, and
    keeps a copy of the values associated to each field.
    """

    cdef readonly Record record
    cdef int current_recno
    cdef BlobFile blob
    cdef PrimaryIndex primary_index

    cdef fields

    def create(self, *fields):
        self.fields = fields
        n = len(fields)
        cdef pxfield_t *f = <pxfield_t *>(self.doc.malloc(self.doc,
                                                          n * sizeof(pxfield_t),
                                                          "Memory for fields"))
        for i from 0 <= i < n:
            f[i].px_fname = PX_strdup(self.doc, fields[i].fname)
            f[i].px_flen = fields[i].flen
            f[i].px_ftype = fields[i].ftype
            f[i].px_fdc = 0

        if PX_create_file(self.doc, f, n, self.filename, pxfFileTypIndexDB) < 0:
            raise Exception("Couldn't open '%s'" % self.filename)
        self.isopen = 1
        self.current_recno = -1

    def open(self):
        """
        Open the data file and associate a Record instance.
        """

        PXDoc.open(self)
        self.record = Record(self)
        self.current_recno = -1
        self.primary_index = None

    def close(self):
        """
        Close the eventual primary index or blob file, then the data file.
        """

        if self.primary_index:
            self.primary_index.close()
        if self.blob:
            self.blob.close()

        PXDoc.close(self)

    def getCodePage(self):
        """
        Return the code page of the underlying Paradox table.
        """

        return "cp%d" % self.doc.px_head.px_doscodepage

    def setPrimaryIndex(self, indexname):
        """
        Set the primary index of the table.
        """

        self.primary_index = PrimaryIndex(indexname)
        self.primary_index.open()
        if PX_add_primary_index(self.doc, self.primary_index.doc)<0:
            raise Exception("Couldn't add primary index `%s`" % indexname)

    def setBlobFile(self, blobfilename):
        """
        Set and open the external blob file.
        """
        self.blob = BlobFile(self, blobfilename)
        self.blob.open()

    def getFieldsCount(self):
        """
        Get number of fields in the table.
        """

        return self.record.getFieldsCount()

    def readRecord(self, recno=None):
        """
        Read the data of the next/some specific `recno` record.

        Return False if at EOF or `recno` is beyond the last record,
        True otherwise. This makes this method suitable to be called
        in a while loop in this way::

           record = t.record
           while t.readRecord():
               for i in range(record.getFieldsCount()):
                   f = record.fields[i]
                   value = f.getValue()
                   print "%s: %s" % (f.fname, value)
        """

        if not recno:
            recno = self.current_recno+1
        else:
            self.current_recno = recno

        if recno>=self.doc.px_head.px_numrecords:
            return False

        self.current_recno = recno

        return self.record.read(recno)

    def append(self, values):
        l = len(self.fields)
        n = sum([ f.flen for f in self.fields ])
        cdef char *buffer = <char *>(self.doc.malloc(self.doc,
                                                     n * sizeof(char),
                                                     "Memory for appended record"))
        o = 0
        fs = {}
        for i from 0 <= i < l:
            f = self.fields[i]
            v = values.get(f.fname, None)
            if f.ftype == pxfAlpha:
                s = str(v or '')
                PX_put_data_alpha(self.doc, &buffer[o], f.flen, <char *>s)
            elif f.ftype == pxfLong:
                PX_put_data_long(self.doc, &buffer[o], f.flen, <long>int(v or 0))
            elif f.ftype == pxfNumber:
                PX_put_data_double(self.doc, &buffer[o], f.flen, <double>float(v or 0.0))
            else:
                raise Exception("unknown type")
            o += f.flen

        # for i from 0 <= i < o:
        #     print buffer[i],
        # print

        if PX_put_record(self.doc, buffer) == -1:
            raise Exception("unable to put record")

        self.current_recno = self.current_recno + 1

cdef class ParadoxField:
    cdef readonly fname
    cdef readonly ftype
    cdef readonly flen

    def __cinit__(self, *args):
        #print 'ParadoxField cinit', args
        pass

    def _init_fields(self, fname, int ftype, int flen):
        self.fname = fname
        self.ftype = ftype
        self.flen = flen

    def __init__(self, fname, int ftype, int flen):
        self._init_fields(fname, ftype, flen)

def default_field_length(int ftype, len = 10):
    if ftype == pxfLong:
        return 4
    elif ftype == pxfAlpha:
        return len
    elif ftype == pxfNumber:
        return 8
    else:
        return 0

def type_to_field_type(type ftype):
    if ftype == int:
        return pxfLong
    elif ftype == str:
        return pxfAlpha
    elif ftype == float:
        return pxfNumber
    else:
        raise Exception("unsupported field type %s" % ftype)

cdef class Field(ParadoxField):
    def __init__(self, fname, type t, int flen = 0):
        ft = type_to_field_type(t)
        fl = default_field_length(ft, flen)
        ParadoxField.__init__(self, fname, ft, fl)

cdef class RecordField(ParadoxField):
    """
    Represent a single field of a Record associated to some Table.
    """

    cdef void *data
    cdef Record record

    def __init__(self, Record record, int index, int offset):
        """
        Create a new instance, associated with the given `record`,
        pointing to the index-th field, which data is displaced by
        `offset` from the start of the record memory buffer.
        """

        self.record = record
        self.data = record.data+offset
        ParadoxField.__init__(self,
                              record.table.doc.px_head.px_fields[index].px_fname,
                              record.table.doc.px_head.px_fields[index].px_ftype,
                              record.table.doc.px_head.px_fields[index].px_flen)

    def getValue(self):
        """
        Get the field's value.

        Return some Python value representing the current value of the field.
        """

        cdef double value_double
        cdef long value_long
        cdef char value_char
        cdef short value_short
        cdef int year, month, day
        cdef char *blobdata
        cdef int size
        cdef int mod_nr

        if self.ftype == pxfAlpha:
            codepage = self.record.table.getCodePage()
            size = strnlen(<char*> self.data, self.flen)
            if size==0:
                return None
            else:
                py_string = PyString_FromStringAndSize(<char*> self.data, size);
                if not py_string:
                    raise Exception("Cannot get value from string %s" % self.fname)
                return PyString_AsDecodedObject(py_string, codepage, "replace")

        elif self.ftype == pxfDate:
            if PX_get_data_long(self.record.table.doc,
                                self.data, self.flen, &value_long)<0:
                raise Exception("Cannot extract long field '%s'" % self.fname)
            if value_long:
                PX_SdnToGregorian(value_long+1721425,
                                  &year, &month, &day)
                return datetime.date(year, month, day)
            else:
                return None

        elif self.ftype == pxfShort:
            if PX_get_data_short(self.record.table.doc,
                                self.data, self.flen, &value_short)<0:
                raise Exception("Cannot extract short field '%s'" % self.fname)

            return value_short

        elif self.ftype == pxfLong or self.ftype == pxfAutoInc:
            if PX_get_data_long(self.record.table.doc,
                                self.data, self.flen, &value_long)<0:
                raise Exception("Cannot extract long field '%s'" % self.fname)

            return value_long

        elif self.ftype == pxfCurrency or self.ftype == pxfNumber:
            if PX_get_data_double(self.record.table.doc,
                                  self.data, self.flen, &value_double)<0:
                raise Exception("Cannot extract double field '%s'" % self.fname)

            return value_double

        elif self.ftype == pxfLogical:
            if PX_get_data_byte(self.record.table.doc,
                                self.data, self.flen, &value_char)<0:
                raise Exception("Cannot extract double field '%s'" % self.fname)
            if value_char:
                return True
            else:
                return False

        elif self.ftype in [pxfMemoBLOb, pxfFmtMemoBLOb]:

            if not self.record.table.blob:
                return "NO BLOB FILE"

            blobdata = PX_read_blobdata(self.record.table.blob.blob,
                                        self.data, self.flen,
                                        &mod_nr, &size)
            if blobdata and size>0:
                codepage = self.record.table.getCodePage()
                py_string = PyString_FromStringAndSize(<char*> blobdata, size);
                if not py_string:
                    raise Exception("Cannot get value from string %s" % self.fname)
                return PyString_AsDecodedObject(py_string, codepage, "replace")

        elif self.ftype in [pxfBLOb, pxfGraphic]:
            if not self.record.table.blob:
                return "NO BLOB FILE"

            blobdata = PX_read_blobdata(self.record.table.blob.blob,
                                        self.data, self.flen,
                                        &mod_nr, &size)
            if blobdata and size>0:
                return PyString_FromStringAndSize(blobdata, size)

        elif self.ftype == pxfOLE:
            pass
        elif self.ftype == pxfTime:
            if PX_get_data_long(self.record.table.doc,
                                self.data, self.flen, &value_long)<0:
                raise Exception("Cannot extract long field '%s'" % self.fname)
            if value_long:
                return datetime.time(value_long/3600000,
                                     value_long/60000%60,
                                     value_long%60000/1000.0)
            else:
                return None

        elif self.ftype == pxfTimestamp:
            pass
        elif self.ftype == pxfBCD:
            pass
        elif self.ftype == pxfBytes:
            pass
        elif self.ftype == pxfNumTypes:
            pass


cdef class Record:
    """
    An instance of this class wraps the memory buffer associated to a
    single record of a given table.
    """

    cdef void *data
    cdef Table table
    cdef public fields

    def __init__(self, Table table):
        """
        Create a Record instance, allocating the memory buffer and
        building the list of the Field instances.
        """

        cdef int offset

        self.data = table.doc.malloc(table.doc,
                                     table.doc.px_head.px_recordsize,
                                     "Memory for record")
        self.table = table
        self.fields = []
        offset = 0
        for i in range(self.getFieldsCount()):
            field = RecordField(self, i, offset)
            self.fields.append(field)
            offset = offset + table.doc.px_head.px_fields[i].px_flen

    def getFieldsCount(self):
        """
        Get number of fields in the record.
        """
        return self.table.doc.px_head.px_numfields

    def read(self, recno):
        """
        Read the data associated to the record numbered `recno`.
        """

        if PX_get_record(self.table.doc, recno, self.data) == NULL:
            raise Exception("Couldn't get record %d from '%s'" % (recno,
                                                                  self.table.filename))
        return True

