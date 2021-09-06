import sys
from frictionless import Package, transform, steps



def transform(resource_name): 
    
    dp = Package('datapackage.json')
    resource = dp.get_resource(resource_name)

    # resource.hashing = 'sha256'
    # transform(resource, steps=[steps.resource_update(hash = resource.stats['hash']),])

    resource.infer(stats = True)
    dp.to_json('datapackage.json')
    
    return exit(0)

if __name__ == '__main__':
    transform(sys.argv[1])