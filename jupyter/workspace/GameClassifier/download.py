#!/usr/bin/env python3

import argparse
import hashlib
import json
import os
import requests
import subprocess
import sys
import xml.etree.ElementTree as ET

def downloadGameInfo(id, location, filename='info', force=False, allow=False):
    filepath = os.path.join(location, filename)
    if not os.path.isfile(filepath) or force:
        url = 'http://thegamesdb.net/api/GetGame.php?id={}'.format(id)
        response = requests.get(url)
        if response.status_code != 200:
            print('{}: {}'.format(response.status_code, url))
            if not allow:
                sys.exit(1)
            return
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w') as f:
            f.write(response.text)

def parseGameInfo(id, location, filename='info', allow=False):
    result = {'id':id}
    filepath = os.path.join(location, filename)
    if not os.path.isfile(filepath):
        print('File {} is missing'.format(filename))
        if not allow:
            sys.exit(1)
        return result
    tree = ET.parse(filepath)
    root = tree.getroot()
    for child in root:
        if child.tag == 'baseImgUrl':
            result['baseImgUrl'] = child.text
        if child.tag == 'Game':
            for childChild in child:
                if childChild.tag == 'GameTitle':
                    result['GameTitle'] = childChild.text
                elif childChild.tag == 'Platform':
                    result['Platform'] = childChild.text
                elif childChild.tag == 'Overview':
                    result['Overview'] = childChild.text
                elif childChild.tag == 'Platform':
                    result['Platform'] = childChild.text
                elif childChild.tag == 'Genres':
                    result['Genres'] = []
                    for childChildChild in childChild:
                        if childChildChild.tag == 'genre':
                            result['Genres'].append(childChildChild.text)
                elif childChild.tag == 'Images':
                    result['Images'] = []
                    for childChildChild in childChild.iter(tag='screenshot'):
                        for childChildChildChild in childChildChild.iter(tag='original'):
                            result['Images'].append(childChildChildChild.text)
    return result

def hashURL(url):
    m = hashlib.md5()
    m.update(url.encode('utf-8'))
    return m.hexdigest()

def downloadGameImages(id, location, infofile='info', imagedir='images', allow=False, force=False):
    info = parseGameInfo(id, location, infofile)
    os.makedirs(os.path.join(location, imagedir), exist_ok=True)
    if len(info.get('Images', [])) == 0:
        print('No images for game {}'.format(id))
        if not allow:
            sys.exit(1)
        return
    for image in info['Images']:
        url = info['baseImgUrl'] + image
        filepath = os.path.join(location, imagedir, hashURL(url))
        if not os.path.isfile(filepath) or force:
            cmd=['wget', '--retry-connrefused', '--waitretry=1', '-O', filepath, url]
            rt = subprocess.call(cmd)
            if rt != 0:
                print('Failed to download image {}'.format(url))
                os.remove(filepath)
                if not allow:
                    sys.exit(1)

def cleanUp(location):
    for root, dirs, files in os.walk(location):
        for name in files:
            filename = os.path.join(root, name)
            if os.path.getsize(filename) == 0:
                print('Remove empty file {}'.format(filename))
                os.remove(filename)

def main():
    parser = argparse.ArgumentParser(description="Downloading tool")
    parser.add_argument("-d", "--debug", action='store_true', default=False,
                        help="Enable debug messages.")
    subparsers = parser.add_subparsers()

    parser_info = subparsers.add_parser("info")
    parser_info.add_argument("--start", type=int, default=1,
                               help="Starting game ID")
    parser_info.add_argument("--count", type=int, default=1,
                               help="How many games")
    parser_info.set_defaults(func='info')

    parser_info = subparsers.add_parser("image")
    parser_info.add_argument("--start", type=int, default=1,
                               help="Starting game ID")
    parser_info.add_argument("--count", type=int, default=1,
                               help="How many games")
    parser_info.set_defaults(func='image')

    parser_info = subparsers.add_parser("clean")
    parser_info.set_defaults(func='clean')

    args = parser.parse_args()

    downloadspath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'downloads')

    if args.func == 'info':
        for i in range(args.start, args.start+args.count):
            if (i - args.start+1) % 20 == 0:
                print('Downloaded {} games info...'.format(i - args.start+1))
            downloadGameInfo(i, os.path.join(downloadspath, str(i)), allow=True)
    elif args.func == 'image':
        for i in range(args.start, args.start+args.count):
            if (i - args.start+1) % 20 == 0:
                print('Downloaded {} games images...'.format(i - args.start+1))
            downloadGameImages(i, os.path.join(downloadspath, str(i)), allow=True)
    elif args.func == 'clean':
        cleanUp(downloadspath)

if __name__ == "__main__":
    main()
