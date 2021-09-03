import 'credentials.dart';

/// An exception raised when attempting to use expired OAuth2 credentials.
class ExpirationException implements Exception {
  /// The expired credentials.
  final Credentials credentials;

  /// Creates an ExpirationException.
  ExpirationException(this.credentials);

  /// Provides a string description of the ExpirationException.
  @override
  String toString() =>
      "OAuth2 credentials have expired and can't be refreshed.";
}
