import os

class FileSystem:

        def __init__(self,directory):
                self.dir=directory
                self.filelist = []
                arglist = {}
                self.fileversions = {}
                os.path.walk(directory,self.callback,arglist)
                pass

        def refresh(self):
                self.fileversions = {}
                for f in self.filelist:
                        if(self.fileversions.has_key(f.mainname) == False):
                                self.fileversions[f.mainname] = []
                        self.fileversions[f.mainname].append(f)

        def callback(self, arg, dirname, fnames):
                sum =0
                for file in fnames:
                        fullpath = os.path.join(dirname, file)
                        if ( os.path.exists(fullpath) ): ## determines if link exists
                                fdef = FileDef(dirname,file)
                                self.filelist.append(fdef)
                        else:
                                print 'BAD FILE: ' + fullpath
                        #if (os.path.islink(fullpath)):
                        #       print fullpath + ' link ' + os.path.realpath(fullpath)

                        # sum += os.path.getsize(file)
                #arg.append(sum)
class FileDef:



        def __init__(self, dirname, filename):
                self.dir = dirname
                self.fname = filename
                self.fullpath = os.path.join(dirname, filename)
                self.mark = False
                self.tags = []
                self.version = None
                self.mainname = filename
                self.versions = []


        def consolidate(self,fdef):
                if(fdef.mainname == self.mainname):
                        self.versions.append(fdef)
                ## order based on versions


        ## Marks a name that can be used for consolidating
        def setMainname(self, name):
                self.mainname = name

        def linkpath(self):
                if ( os.path.islink(self.fullpath)):
                        return os.path.realpath(self.fullpath)
                return None

        def references(self,fdef):
                lpath = fdef.fullpath
                return (self.linkpath() == lpath)
        def mark(self):
                self.mark = True
        def unmark(self):
                self.mark = False
        def ismarked(self):
                return self.mark

        def tag(self, tag):
                if(self.istagged(tag) == False):
                        self.tags.append(tag)

        def istagged(self,tag):
                for t in self.tags:
                        if(tag == t): return True
                return False
        ## Sets the version for ordering for main names
        def setVersion(self,version):
                self.version = version
                                                                                                                                          84,3-17       Bot

