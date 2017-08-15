import sys
sys.path.append("packages")
import json
# Just to verify that we can add packages
import flask

obj = json.loads(sys.stdin.read())
for i in range(obj['Loops']):
    obj['Result'] = sorted(obj['Items'])
obj['Type'] = 'python3'
print(obj)
