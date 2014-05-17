# encoding=UTF-8

# Copyright © 2014 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

'''
logging script for mitmproxy
usage: mitmproxy [options] --anticache -s httpdump.py
'''

import os
import re
import sys
import traceback

def response(context, flow, logindex=[0]):
    try:
        logindex[0] += 1
        path = 'log.{index:06}.{method}.{host}.{path}'.format(
            index=logindex[0],
            method=flow.request.method,
            host=flow.request.host,
            path=re.sub(r'[^\w.]', '_', flow.request.path),
        )
        fd = os.open(path, os.O_TRUNC | os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0600)
        with os.fdopen(fd, 'w') as log:
            for message in [flow.request, flow.response]:
                log.write(message._assemble_head())
                log.write(message.get_decoded_content())
                log.write('\n\n')
    except Exception:
        traceback.print_exc(file=sys.stderr)
