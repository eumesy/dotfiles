#! /usr/bin/env python3
# -*- coding: utf-8; mode: Python -*-

import argparse

def main():


if __name__ == '__main__':
    # parser
    parser = argparse.ArgumentParser(
        description='...',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter) # --help に各 argument の default を追記


    # positional arguments
    parser.add_argument('arg_name', type=int,
                        help='...')

    # optional arguments
    parser.add_argument('-f', '-foo', type=int, default=0, # default の default: None
                        help='...')

    # optional arguments (flags)
    parser.add_argument('-f', 'foo', action='store_true',
                        help='...')

    # choice
    #   type=int, choice=[1,2,4]
    # opened file
    #   type=open
    #   type=argparse.FileType('w', encoding='UTF-8')
    # required (for optional arguments) (generally considered bad form)
    #   required=True


    # parse
    args = parser.parse_args()

    main()
