import yaml
import os, glob
import puppet
from optparse import OptionParser

dirname = '/var/lib/puppet/yaml/node/'
env = 'dev'

parser = OptionParser()
parser.add_option("-p", "--property",action="append", dest="property",
                  help="property to query")
(options, args) = parser.parse_args()
print (options )


for infile in glob.glob (os.path.join(dirname, '*.yaml')):
        stream = file(infile, 'r')
        obj = yaml.load(stream)
        classfound = False
        for cs in obj.classes:
                if cs == 'webserver':
                        classfound=True
                        break
        if (classfound):
                print ( infile + " has webserver ")
        if (hasattr(obj, 'environment') and env == obj.environment):
                print ( infile + " is in dev ")


