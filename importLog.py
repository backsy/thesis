#!c:\python27\python.exe
# -*- coding: utf-8 -*-

'''
read a mavlink binary file into SQLite database
'''
from __future__ import print_function
from __future__ import division
from builtins   import range
from argparse   import ArgumentParser
from pymavlink  import mavutil
from timeit     import default_timer as timer
import os
import sys
import re
import sqlite3
import collections
import datetime
import math

extensions = collections.defaultdict(int)

def main(argv):
    # parser = ArgumentParser(description=__doc__)
    # parser.add_argument("database", help='Path to SQLite Database')
    # parser.add_argument("logs", metavar="LOG", nargs="+", help='List of logs to process')
    # args = parser.parse_args(argv)

    # for filename in args.logs:
    #     process_tlog(filename)
    size = 0
    folder_path = argv[1]
    for path, dirs, files in os.walk(folder_path):
        for filename in files:
            if os.path.splitext(filename)[1].lower() == '.bin':
                filesize = os.path.getsize(path+os.sep+filename)
                if filesize < 100000000 or filesize > 4000000:
                    size += filesize

    print('Total filesize to process: ' + humanize_bytes(size))
    todo_size = size
    time_elapsed = 0
    for path, dirs, files in os.walk(folder_path):
        for filename in files:
            if os.path.splitext(filename)[1].lower() == '.bin':
                filesize = os.path.getsize(path+os.sep+filename)
                if filesize > 100000000 or filesize < 4000000:
                    continue

                print('Processing file: ' + filename + ' in folder: ' + path)
                print('File size is: ' + humanize_bytes(filesize))

                start = timer()
                process_tlog(path+os.sep+filename)    
                end = timer()
                diff = end-start
                time_elapsed += diff
                print('Processing time for {}: {:2.2f}'.format(filename, diff))
                todo_size -= filesize
                processed = ((float(size) - float(todo_size)) / float(size)) * float(100)
                print('{:2.2f}% '.format(processed) + "processed")
                bit_time = float(diff) / float(filesize)
                time_left = float(bit_time) * float(todo_size)
                if time_left != 0:
                    print('Estimated time to completion: {}'.format(str(datetime.timedelta(seconds=math.floor(time_left)))))
                print('Time elapsed: ' + str(datetime.timedelta(seconds=math.floor(time_elapsed))))

def process_tlog(filename):
    '''convert a ardupilot BIN file to SQLite database'''
    mlog = mavutil.mavlink_connection(filename, dialect='ardupilotmega', zero_time_base=True)
    connection = create_connection('quadLogs2.db')
    # conn = create_connection(args.database)
    database = {}
    try:
        database = load_database_to_ram(connection)
    except:
        database = create_database(connection)

    add_flight(database, filename, connection)

    counter = 0

    while True:
        line = mlog.recv_match()
        # Exit on file end
        if line is None:
            break
        message = line.get_type()
        # Remove bad packets
        if message == 'BAD_DATA':
            continue
        # FMT defines the format and PARM is params... not sure if i need em or not
        if message in ['FMT', 'PARM']:
            continue

        process_header(line, database, connection)

        process_data(line, database)
        counter+=1
        if counter % 10000 == 0:
            bulk_write_values(database, connection)
            bulk_write_timestamps(database, connection)
    bulk_write_values(database, connection)
    bulk_write_timestamps(database, connection)
    connection.commit()
    connection.close()

def process_header(line, database, connection):
    message = line.get_type()
    if message not in database['messages']:
        add_message(message, database, connection)

    fieldnames = line._fieldnames
    parameters = []
    for field in fieldnames:
        val = getattr(line, field)
        if not isinstance(val, str):
            if type(val) is not list:
                parameters.append(field)
            else:
                for i in range(0, len(val)):
                    parameters.append(field + '%s'% i+1) 
    
    add_parameters(parameters, database, connection)
    if 'buffer' not in database:
        database['buffer'] = {}
    database['buffer'][message] = parameters

def process_data(line, database):        
    # add message type with parameters to buffer to be able to save to sqlite db later
    message = line.get_type()
    fieldnames = line._fieldnames
    data = []
    add_timestamp(line._timestamp, database)
    for field in fieldnames:
        val = getattr(line, field)
        if not isinstance(val, str):
            if type(val) is not list:
                data.append("%.20g"% val)
            else:
                for i in range(0, len(val)):
                    data.append("%.20g"% val[i])
    
    parameters_and_values = zip(database['buffer'][message], data)

    parameter = 0
    value = 1
    if 'values' not in database['buffer']:
        database['buffer']['values'] = []
    for parameter_pair in parameters_and_values:
        database['last value id'] += 1
        database['buffer']['values'].append((
            database['last value id'],
            database['last flight id'],
            database['last timestamp id'],
            database['messages'][message],
            database['parameters'][parameter_pair[parameter]],
            parameter_pair[value]
        ))

def load_database_to_ram(connection):    
    """ load a database specified by connection into memory
    :param connection: connection to database
    :return: database
    """
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM parameter')
    parameters = dict(map(lambda (id, name): (name.encode('ascii'), id), cursor.fetchall()))
    cursor.execute('SELECT * FROM message')
    messages = dict(map(lambda (id, name): (name.encode('ascii'), id), cursor.fetchall()))
    cursor.execute('SELECT * FROM parameter ORDER BY id DESC LIMIT 1')
    last_parameter_id = (cursor.fetchall())[0][0]
    cursor.execute('SELECT * FROM message ORDER BY id DESC LIMIT 1')
    last_message_id = (cursor.fetchall())[0][0]
    cursor.execute('SELECT * FROM timestamp ORDER BY id DESC LIMIT 1')
    last_timestamp_id = (cursor.fetchall())[0][0]
    cursor.execute('SELECT * FROM value ORDER BY id DESC LIMIT 1')
    last_value_id = (cursor.fetchall())[0][0]
    cursor.execute('SELECT * FROM flight ORDER BY id DESC LIMIT 1')
    last_flight_id = (cursor.fetchall())[0][0]
    database = {
        'last value id': last_value_id,
        'last flight id': last_flight_id,
        'last message id': last_message_id,
        'last timestamp id': last_timestamp_id,
        'last parameter id': last_parameter_id,
        'messages': messages,
        'parameters': parameters
    }
    return database

def create_database(connection):    
    """ create a database specified by connection and leave a copy into memory
    :param connection: connection to database
    :return: database
    """
    cursor = connection.cursor()
    cursor.execute('CREATE TABLE flight (id INTEGER NOT NULL PRIMARY KEY, path TEXT)')
    cursor.execute('CREATE TABLE message (id INTEGER NOT NULL PRIMARY KEY, message TEXT)')
    cursor.execute('CREATE TABLE timestamp (id INTEGER NOT NULL PRIMARY KEY, timestamp INTEGER)')
    cursor.execute('CREATE TABLE parameter (id INTEGER NOT NULL PRIMARY KEY, parameter TEXT)')
    cursor.execute("""
    CREATE TABLE value (
        id INTEGER NOT NULL PRIMARY KEY,
        flight INTEGER NOT NULL,
        message INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        parameter INTEGER NOT NULL,
        value REAL,
        FOREIGN KEY(flight) REFERENCES flight(id)
        FOREIGN KEY(message) REFERENCES message(id)
        FOREIGN KEY(timestamp) REFERENCES timestamp(id)
        FOREIGN KEY(parameter) REFERENCES parameter(id)
    )""")
    database = {
        'last flight id': 0,
        'last message id': 0,
        'last timestamp id': 0,
        'last parameter id': 0,
        'last value id': 0,
        'messages': {},
        'parameters': {}
    }
    return database

def bulk_write_values(database, connection):
    # write buffered values to database
    cursor = connection.cursor()
    sql = get_sql('value',['id', 'flight', 'timestamp', 'message', 'parameter', 'value'])
    cursor.executemany(sql, database['buffer']['values'])
    database['buffer']['values'] = []

def bulk_write_timestamps(database, connection):
    cursor = connection.cursor()
    sql = get_sql('timestamp',['id', 'timestamp'])
    cursor.executemany(sql, database['buffer']['timestamps'])
    database['buffer']['timestamps'] = []

def add_flight(database, filename, connection):
    database['last flight id'] += 1    
    cursor = connection.cursor()
    sql = 'INSERT INTO flight(id, path) VALUES(?,?)'
    cursor.execute(sql, [database['last flight id'], scrub(filename)])

def add_message(message, database, connection):
    database['last message id'] += 1
    database['messages'][message] = database['last message id']
    sql = get_sql('message', ['id', 'message'])
    data = (database['messages'][message], message)
    cursor = connection.cursor()
    cursor.execute(sql, data)

def add_timestamp(timestamp, database):
    if 'timestamps' not in database['buffer']:
        database['buffer']['timestamps'] = []
    database['last timestamp id'] += 1
    database['buffer']['timestamps'].append((database['last timestamp id'], timestamp))

def add_parameters(parameters, database, connection):
    buffer = []
    params = filter(lambda p: p not in database['parameters'], parameters)
    for parameter in params:
        database['last parameter id'] += 1
        database['parameters'][parameter] = database['last parameter id']
        buffer.append((database['last parameter id'], parameter))
    
    sql = get_sql('parameter', ['id', 'parameter'])
    cursor = connection.cursor()
    cursor.executemany(sql, buffer)
    connection.commit()

def get_sql(table_name, column_names):
    questionmarks = ','.join(map(lambda x: '?', column_names))
    column_names_string = ','.join(column_names)
    return 'INSERT INTO {}({}) VALUES({})'.format(scrub(table_name), column_names_string, questionmarks)

def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by db_file
    :param db_file: database file
    :return: Connection object or None
    """
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Exception as e:
        print(e)

    return None

def scrub(table_name):
    return ''.join( chr for chr in table_name if chr.isalnum())

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
    main(sys.argv)