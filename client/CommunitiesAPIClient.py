############################################################
#
# Autogenerated by the KBase type compiler -
# any changes made here will be overwritten
#
# Passes on URLError, timeout, and BadStatusLine exceptions.
#     See: 
#     http://docs.python.org/2/library/urllib2.html
#     http://docs.python.org/2/library/httplib.html
#
############################################################

try:
    import json
except ImportError:
    import sys
    sys.path.append('simplejson-2.3.3')
    import simplejson as json
    
import urllib2, httplib
from urllib2 import URLError

class ServerError(Exception):

    def __init__(self, name, code, message):
        self.name = name
        self.code = code
        self.message = message

    def __str__(self):
        return self.name + ': ' + str(self.code) + '. ' + self.message

class CommunitiesAPI:

    def __init__(self, url, timeout = 30 * 60):
        if url != None:
            self.url = url
        self.timeout = int(timeout)
        if self.timeout < 1:
            raise ValueError('Timeout value must be at least 1 second')

    def get_abundanceprofile_instance(self, get_abundanceprofile_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_abundanceprofile_instance',
                     'params': [get_abundanceprofile_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_library_query(self, get_library_query_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_library_query',
                     'params': [get_library_query_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_library_instance(self, get_library_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_library_instance',
                     'params': [get_library_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_metagenome_query(self, get_metagenome_query_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_metagenome_query',
                     'params': [get_metagenome_query_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_metagenome_instance(self, get_metagenome_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_metagenome_instance',
                     'params': [get_metagenome_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_project_query(self, get_project_query_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_project_query',
                     'params': [get_project_query_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_project_instance(self, get_project_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_project_instance',
                     'params': [get_project_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sample_query(self, get_sample_query_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sample_query',
                     'params': [get_sample_query_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sample_instance(self, get_sample_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sample_instance',
                     'params': [get_sample_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sequences_md5(self, get_sequences_md5_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sequences_md5',
                     'params': [get_sequences_md5_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sequences_annotation(self, get_sequences_annotation_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sequences_annotation',
                     'params': [get_sequences_annotation_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sequenceset_instance(self, get_sequenceset_instance_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sequenceset_instance',
                     'params': [get_sequenceset_instance_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')

    def get_sequenceset_list(self, get_sequenceset_list_params):

        arg_hash = { 'method': 'CommunitiesAPI.get_sequenceset_list',
                     'params': [get_sequenceset_list_params],
                     'version': '1.1'
                     }

        body = json.dumps(arg_hash)
        ret = urllib2.urlopen(self.url, body, timeout = self.timeout)
        if ret.code != httplib.OK:
            raise URLError('Received bad response code from server:' + ret.code)
        resp = json.loads(ret.read())

        if 'result' in resp:
            return resp['result'][0]
        elif 'error' in resp:
            raise ServerError(**resp['error'])
        else:
            raise ServerError('Unknown', 0, 'An unknown server error occurred')




        
