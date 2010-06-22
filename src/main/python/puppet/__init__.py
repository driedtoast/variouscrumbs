import yaml

class PuppetNode(yaml.YAMLObject):
        yaml_tag = u'!ruby/object:Puppet::Node'
        def __init__(self, classes, environment, expiration, name, parameters):
                self.classes = classes
                self.environment = environment
                self.expiration = expiration
                self.name = name
                self.parameters = parameters

        def __repr__(self):
                return "-- %s(classes=%r, environment=%r, expiration=%r, name=%r, parameters=%r)" % (
                     self.__class__.__name__, self.classes, self.environment, self.expiration, self.name, self.parameters)

