import utilize

#############################
## used by python utilize_example.py -pname=value -pname=value
#############################


kvpairs = utilize.argvalues.keys()

for key in kvpairs:
        print key + ' = ' + kvpairs[key]

