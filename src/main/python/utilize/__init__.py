from optparse import OptionParser

parser = OptionParser()
parser.add_option("-p", "--property",action="append", dest="property",
                  help="property to query")


(options, args) = parser.parse_args()

class ArgValues:

        kvpairs = None

        def __init__(self, options, args):
                self.options = options
                self.args = args

                properties = None

                if (hasattr(options,'property')):
                        properties = options.property
                self.kvpairs = dict()
                if (properties != None):
                        for value in properties:
                                kv = value.split('=')
                                self.kvpairs[kv[0]]=kv[1]
        def get(self, name):
                return self.kvpairs[name]

        def keys(self):
                return self.kvpairs

argvalues = ArgValues(options,args)

