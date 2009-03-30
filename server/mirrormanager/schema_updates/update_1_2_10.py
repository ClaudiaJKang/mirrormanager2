import turbogears
from sqlobject import *
from mirrormanager.model import *
import hashlib

del Arch.primaryArch
del Arch.publiclist
del FileDetail.sha256
del FileDetail.sha512

def initialize_filedetail():
    for fd in FileDetail.select():
        fd.sha256 = None
        fd.sha512 = None

def fill_filedetail():    
    for r in Repository.select():
        d = r.directory
        try:
            d = Directory.byName("%s/repodata" % (d.name))
        except:
            print "warning: Repository at Directory %s missing repodata subdir" % d.name
            continue
        for fd in d.fileDetails:
            if fd.filename == 'repomd.xml':
                try:
                    fname = "%s/repomd.xml" % (fd.directory.name)
                    f = open(fname, 'rb')
                    s = f.read()
                    f.close()
                    fd.sha256 = hashlib.sha256(s).hexdigest()
                    fd.sha512 = hashlib.sha512(s).hexdigest()
                    del s
                except:
                    print "warning: couldn't update sha checksums for %s" % d.name
                # only add to the most recent one
                break

def fill_arch():
    primary = ('i386', 'x86_64', 'ppc')
    for a in Arch.select():
        a.publiclist = (a.name != 'source')
        a.primaryArch = (a.name in primary)

def update_schema_arch():
    rc = False
    c = Arch.sqlmeta.columns
    if 'publiclist' not in c and 'primaryArch' not in c:
        Arch.publiclist = Arch.sqlmeta.addColumn(BoolCol(name='publiclist', default=True), changeSchema=True)
        Arch.primaryArch = Arch.sqlmeta.addColumn(BoolCol(name='primary_arch', default=False), changeSchema=True)
        rc = True
    return rc

def update_schema_filedetail():
    rc = False
    c = FileDetail.sqlmeta.columns
    if 'sha256' not in c and 'sha512' not in c:
        FileDetail.sha256 = FileDetail.sqlmeta.addColumn(UnicodeCol(name='sha256', default=None), changeSchema=True)
        FileDetail.sha512 = FileDetail.sqlmeta.addColumn(UnicodeCol(name='sha512', default=None), changeSchema=True)
        rc = True
    return rc

def update():
    rc = update_schema_arch()
    if rc:
        fill_arch()
    rc = update_schema_filedetail()
    if rc:
        initialize_filedetail()
        fill_filedetail()