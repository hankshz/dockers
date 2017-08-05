#!/usr/bin/env python

import argparse

from cassandra.cluster import Cluster

key_space_name = "testkeyspace"
table_name = "employee"

def create():
    cluster = Cluster()
    session = cluster.connect()
    command = "CREATE KEYSPACE \"{}\" with replication = {{'class':'SimpleStrategy', 'replication_factor' : 3}};".format(key_space_name)
    print(command)
    session.execute(command)
    command = 'use "{}";'.format(key_space_name)
    print(command)
    session.execute(command)
    command = "CREATE TABLE {} (id int PRIMARY KEY, name text, city text);".format(table_name)
    print(command)
    session.execute(command)
    for i in range(1, 10+1):
        command = "INSERT INTO {} (id, name, city) VALUES ({}, 'Name{}', 'City{}');".format(table_name, i, i, i)
        print(command)
        session.execute(command)
    session.execute(command)
    command = "ALTER TABLE employee ADD email text;"
    print(command)
    session.execute(command)
    for i in range(11, 20+1):
        command = "INSERT INTO {} (id, name, city, email) VALUES ({}, 'Name{}', 'City{}', 'Email{}');".format(table_name, i, i, i, i)
        print(command)
        session.execute(command)

def verify():
    cluster = Cluster()
    session = cluster.connect(key_space_name)
    command = 'SELECT id, name, city, email FROM {};'.format(table_name)
    print(command)
    rows = session.execute(command)
    rows = sorted(rows, key=lambda row: row.id)
    for i in range(1, 10+1):
        row = rows[i-1]
        assert(row.id == i)
        assert(row.name == 'Name{}'.format(i))
        assert(row.city == 'City{}'.format(i))
    for i in range(11, 20+1):
        row = rows[i-1]
        assert(row.id == i)
        assert(row.name == 'Name{}'.format(i))
        assert(row.city == 'City{}'.format(i))
        assert(row.email == 'Email{}'.format(i))

def delete():
    cluster = Cluster()
    session = cluster.connect()
    command = "DROP KEYSPACE \"{}\";".format(key_space_name)
    print(command)
    session.execute(command)
    
def main():
    parser = argparse.ArgumentParser(description="Quick Cassandra test")
    parser.add_argument("-c", "--create", action='store_true', default=False,
                        help="Create the data")
    parser.add_argument("-v", "--verify", action='store_true', default=False,
                        help="Verify the data")
    parser.add_argument("-d", "--delete", action='store_true', default=False,
                        help="Delete the data")
    args = parser.parse_args()
    try:
        if args.create:
            create()
        if args.verify:
            verify()
    except:
        delete()
        raise
    if args.delete:
        delete()

if __name__ == "__main__":
    main()
