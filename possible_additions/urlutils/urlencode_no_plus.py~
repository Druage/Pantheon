import urllib.request, urllib.parse, urllib.error
import sys

# urllib will always use quote plus encoding (meaning spaces in HTTP GET parameters are converted to '+', rather than
# '%20'.  This is a problem with the gamesdb API, since some searches, such as GetGame when searching text fields such
# as name will treat 'mega+man' as a searh for all games whose name contains either 'mega' or 'man'.  We need to send
# 'mega%20man' to get the expected results in most cases, so I am copying out urllib.urlencode here and using
# urllib.quote rather than urllib.quote_plus.

try:
    unicode
except NameError:
    def _is_unicode(x):
        return 0
else:
    def _is_unicode(x):
        return isinstance(x, unicode)


def urlencode_no_plus(query, doseq=0):
    """Encode a sequence of two-element tuples or dictionary into a URL query string.

    If any values in the query arg are sequences and doseq is true, each
    sequence element is converted to a separate parameter.

    If the query arg is a sequence of two-element tuples, the order of the
    parameters in the output will match the order of parameters in the
    input.
    :param query:
    :param doseq:
    """

    if hasattr(query,"items"):
        # mapping objects
        query = query.items()
    else:
        # it's a bother at times that strings and string-like objects are
        # sequences...
        try:
            # non-sequence items should not work with len()
            # non-empty strings will fail this
            if len(query) and not isinstance(query[0], tuple):
                raise TypeError
            # zero-length sequences of all types will get here and succeed,
            # but that's a minor nit - since the original implementation
            # allowed empty dicts that type of behavior probably should be
            # preserved for consistency
        except TypeError:
            ty,va,tb = sys.exc_info()
            raise TypeError("not a valid non-string sequence or mapping object", tb)

    l = []
    if not doseq:
        # preserve old behavior
        for k, v in query:
            k = urllib.parse.quote(str(k))
            v = urllib.parse.quote(str(v))
            l.append(k + '=' + v)
    else:
        for k, v in query:
            k = urllib.parse.quote(str(k))
            if isinstance(v, str):
                v = urllib.parse.quote(v)
                l.append(k + '=' + v)
            elif _is_unicode(v):
                # is there a reasonable way to convert to ASCII?
                # encode generates a string, but "replace" or "ignore"
                # lose information and "strict" can raise UnicodeError
                v = urllib.parse.quote(v.encode("ASCII","replace"))
                l.append(k + '=' + v)
            else:
                try:
                    # is this a sufficient test for sequence-ness?
                    len(v)
                except TypeError:
                    # not a sequence
                    v = urllib.parse.quote(str(v))
                    l.append(k + '=' + v)
                else:
                    # loop over the sequence
                    for elt in v:
                        l.append(k + '=' + urllib.parse.quote(str(elt)))
    return '&'.join(l)
