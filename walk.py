# -*- coding: utf-8 -*-
from __future__ import division
import os
import collections
extensions = collections.defaultdict(int)
size = collections.defaultdict(int)

def main():
    for path, dirs, files in os.walk('C:\\Users\\karlu\\Documents\\School\\Thesis\\wip'):
        for filename in files:
            if os.path.splitext(filename)[1].lower() == '.bin':
                extensions[os.path.splitext(filename)[1].lower()] += 1
                size[os.path.splitext(filename)[1].lower()] += os.path.getsize(path+os.sep+filename)

    for key,value in extensions.items():
        print 'Extension: ', key, ' ', value, ' items'

    for key,value in size.items():
        print 'Extension: ', key, ' ', humanize_bytes(value), ' size'

def humanize_bytes(bytes, precision=1):
    """Return a humanized string representation of a number of bytes.

    Assumes `from __future__ import division`.

    >>> humanize_bytes(1)
    '1 byte'
    >>> humanize_bytes(1024)
    '1.0 kB'
    >>> humanize_bytes(1024*123)
    '123.0 kB'
    >>> humanize_bytes(1024*12342)
    '12.1 MB'
    >>> humanize_bytes(1024*12342,2)
    '12.05 MB'
    >>> humanize_bytes(1024*1234,2)
    '1.21 MB'
    >>> humanize_bytes(1024*1234*1111,2)
    '1.31 GB'
    >>> humanize_bytes(1024*1234*1111,1)
    '1.3 GB'
    """
    abbrevs = (
        (1<<50L, 'PB'),
        (1<<40L, 'TB'),
        (1<<30L, 'GB'),
        (1<<20L, 'MB'),
        (1<<10L, 'kB'),
        (1, 'bytes')
    )
    if bytes == 1:
        return '1 byte'
    for factor, suffix in abbrevs:
        if bytes >= factor:
            break
    return '%.*f %s' % (precision, bytes / factor, suffix)

if __name__ == "__main__":
    main()