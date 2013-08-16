#!/usr/bin/python
from argparse import ArgumentParser


if __name__ == "__main__":
    parser = ArgumentParser(description='Argument parser')
    parser.add_argument('scr', nargs=1, help="Please provide a Scrbble list")
    args = parser.parse_args()
    print args.scr[0]
    pass
