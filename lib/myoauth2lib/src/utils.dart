import 'dart:convert';

/// Adds additional query parameters to [url], overwriting the original
/// parameters if a name conflict occurs.
Uri addQueryParameters(Uri url, Map<String, String> parameters) => url.replace(
    queryParameters: Map.from(url.queryParameters)..addAll(parameters));

String basicAuthHeader(String identifier, String secret) {
  var userPass = Uri.encodeFull(identifier) + ':' + Uri.encodeFull(secret);
  return 'Basic ' + base64Encode(ascii.encode(userPass));
}
