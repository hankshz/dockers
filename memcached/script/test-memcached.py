#!/usr/bin/env python3

import time
from pymemcache.client.base import Client

master = Client(('memcached-master', 11211))
slave1 = Client(('memcached-slave1', 11211))
slave2 = Client(('memcached-slave2', 11211))
slave3 = Client(('memcached-slave3', 11211))

# Invalidate all
# mcrouter seems not work properly with pymemcache flush_all
slave1.flush_all()
slave2.flush_all()
slave3.flush_all()

# Set & Get from the master
master.set('a', '1')
assert(master.get('a') == b'1')
master.set('b', '2')
assert(master.get('b') == b'2')
master.set('c', '3')
assert(master.get('c') == b'3')
master.set('d', '4')
assert(master.get('d') == b'4')

# Get from the slave1, only string starts with 'a'
slave1 = Client(('memcached-slave1', 11211))
assert(slave1.get('a') == b'1')
assert(slave1.get('b') == None)
assert(slave1.get('c') == None)
assert(slave1.get('d') == None)

# Get from the slave2, only string starts with 'b'
slave2 = Client(('memcached-slave2', 11211))
assert(slave2.get('a') == None)
assert(slave2.get('b') == b'2')
assert(slave2.get('c') == None)
assert(slave2.get('d') == None)

# Get from the slave3, only rest of strings
slave3 = Client(('memcached-slave3', 11211))
assert(slave3.get('a') == None)
assert(slave3.get('b') == None)
assert(slave3.get('c') == b'3')
assert(slave3.get('d') == b'4')
