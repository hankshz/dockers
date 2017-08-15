#!/usr/bin/env python3

import random
import requests
import time

NUM_LOOPS = 100
NUM_NUMBERS = 1000
NUM_TIMES = 100

def run_test(lang):
	elapse = 0
	for i in range(NUM_TIMES):
		items = [int(NUM_NUMBERS*random.random()) for i in range(NUM_NUMBERS)]
		data = '{{"Loops": {}, "Items": {}}}'.format(NUM_LOOPS, items)
		url = 'http://localhost:8080/r/testapp/{}-test'.format(lang)
		start = time.time()
		r = requests.post(url, data=data)
		end = time.time()
		elapse += end - start
		assert(r.status_code == 200)
		# There maybe \n at the end of print or log
		result = eval(r.text.strip('\n'))
		assert(result['Type'] == lang)
		assert(result['Result'] == sorted(items))
	return elapse

def run_local_test():
	elapse = 0
	for i in range(NUM_TIMES):
		items = [int(NUM_NUMBERS*random.random()) for i in range(NUM_NUMBERS)]
		start = time.time()
		r = sorted(items)
		end = time.time()
		elapse += end - start
	return elapse

print('Sorting a random list of {} floats {} loops {} round trips:'.format(NUM_NUMBERS, NUM_LOOPS, NUM_TIMES))
print('	local:')
print('		python3: {}sec'.format(run_local_test()))
print('	faas:')
print('		python3: {}sec'.format(run_test('python3')))
print('		go: {}sec'.format(run_test('go')))
print('		nodejs: {}sec'.format(run_test('nodejs')))
