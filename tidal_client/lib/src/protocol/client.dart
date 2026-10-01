/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:tidal_client/src/protocol/log/day_log.dart' as _i91iyawq;
import 'package:tidal_client/src/protocol/log/flow_level.dart' as _ieqssu4z;
import 'package:tidal_client/src/protocol/log/mood.dart' as _io0y0e3q;
import 'package:tidal_client/src/protocol/pain/dose_log.dart' as _i95dlci0;
import 'package:tidal_client/src/protocol/pain/medication.dart' as _i2f8rdmx;
import 'package:tidal_client/src/protocol/pain/pain_entry.dart' as _imzr3ook;
import 'package:tidal_client/src/protocol/pain/pain_location.dart' as _ivkbsfwn;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Endpoint for logging day-to-day info: period flow, mood, and notes.
///
/// Every method only ever reads or writes the signed-in user's own data.
/// {@category Endpoint}
class EndpointLog extends _isc.EndpointRef {
  EndpointLog(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'log';

  /// Saves (or creates) the log for [date].
  ///
  /// Only the fields you pass in are changed. For example, calling this with
  /// just `mood` set leaves that day's `flow` and `note` untouched. To clear
  /// the flow back to "no period", pass `FlowLevel.none` explicitly.
  _ida.Future<_i91iyawq.DayLog> saveDay(
    DateTime date, {
    _ieqssu4z.FlowLevel? flow,
    _io0y0e3q.Mood? mood,
    String? note,
  }) => caller.callServerEndpoint<_i91iyawq.DayLog>(
    'log',
    'saveDay',
    {
      'date': date,
      'flow': flow,
      'mood': mood,
      'note': note,
    },
  );

  /// Returns all logged days between [start] and [end] (inclusive), ordered
  /// by date. Only the time part's day/month/year is used; it is normalized
  /// to midnight UTC, matching how dates are stored.
  _ida.Future<List<_i91iyawq.DayLog>> getRange(
    DateTime start,
    DateTime end,
  ) => caller.callServerEndpoint<List<_i91iyawq.DayLog>>(
    'log',
    'getRange',
    {
      'start': start,
      'end': end,
    },
  );

  /// Permanently deletes every day log belonging to the signed-in user.
  _ida.Future<void> deleteAll() => caller.callServerEndpoint<void>(
    'log',
    'deleteAll',
    {},
  );
}

/// Endpoint for pain and medication logging. Tidal only ever records what
/// the user says they took; it never suggests doses.
///
/// Every method only ever reads or writes the signed-in user's own data.
/// {@category Endpoint}
class EndpointPain extends _isc.EndpointRef {
  EndpointPain(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pain';

  /// Logs a pain entry for right now.
  _ida.Future<_imzr3ook.PainEntry> logPain(
    int level,
    List<_ivkbsfwn.PainLocation> locations,
  ) => caller.callServerEndpoint<_imzr3ook.PainEntry>(
    'pain',
    'logPain',
    {
      'level': level,
      'locations': locations,
    },
  );

  /// Returns the pain entries logged between [start] and [end] (inclusive
  /// days), ordered by time.
  _ida.Future<List<_imzr3ook.PainEntry>> getPainRange(
    DateTime start,
    DateTime end,
  ) => caller.callServerEndpoint<List<_imzr3ook.PainEntry>>(
    'pain',
    'getPainRange',
    {
      'start': start,
      'end': end,
    },
  );

  /// Returns the signed-in user's medications, in the order they were added.
  _ida.Future<List<_i2f8rdmx.Medication>> myMeds() =>
      caller.callServerEndpoint<List<_i2f8rdmx.Medication>>(
        'pain',
        'myMeds',
        {},
      );

  /// Adds a new medication to the signed-in user's "my meds" list.
  _ida.Future<_i2f8rdmx.Medication> addMedication(
    String name,
    String usualDose,
  ) => caller.callServerEndpoint<_i2f8rdmx.Medication>(
    'pain',
    'addMedication',
    {
      'name': name,
      'usualDose': usualDose,
    },
  );

  /// One-tap dose logging: records that [medicationId] was taken right now,
  /// using its usual dose. [painBefore] is optional context, e.g. the pain
  /// level the user just logged in the same sheet.
  _ida.Future<_i95dlci0.DoseLog> logDose(
    int medicationId, {
    int? painBefore,
  }) => caller.callServerEndpoint<_i95dlci0.DoseLog>(
    'pain',
    'logDose',
    {
      'medicationId': medicationId,
      'painBefore': painBefore,
    },
  );

  /// Returns the dose logs between [start] and [end] (inclusive days),
  /// ordered by time.
  _ida.Future<List<_i95dlci0.DoseLog>> getDoseRange(
    DateTime start,
    DateTime end,
  ) => caller.callServerEndpoint<List<_i95dlci0.DoseLog>>(
    'pain',
    'getDoseRange',
    {
      'start': start,
      'end': end,
    },
  );

  /// Returns the most recent dose log of any medication, or null if the
  /// user hasn't logged one yet. Used to show "time since last dose".
  _ida.Future<_i95dlci0.DoseLog?> getLastDose() =>
      caller.callServerEndpoint<_i95dlci0.DoseLog?>(
        'pain',
        'getLastDose',
        {},
      );

  /// Returns the oldest dose log that's ready for its "did it help?"
  /// check-in (set by [CheckInFutureCall]), or null if there isn't one.
  _ida.Future<_i95dlci0.DoseLog?> getPendingCheckIn() =>
      caller.callServerEndpoint<_i95dlci0.DoseLog?>(
        'pain',
        'getPendingCheckIn',
        {},
      );

  /// Answers a check-in: saves how the pain feels now.
  _ida.Future<_i95dlci0.DoseLog> recordRelief(
    int doseLogId,
    int painAfter,
  ) => caller.callServerEndpoint<_i95dlci0.DoseLog>(
    'pain',
    'recordRelief',
    {
      'doseLogId': doseLogId,
      'painAfter': painAfter,
    },
  );

  /// Dismisses the check-in for now and asks again in 30 minutes.
  _ida.Future<void> snoozeCheckIn(int doseLogId) =>
      caller.callServerEndpoint<void>(
        'pain',
        'snoozeCheckIn',
        {'doseLogId': doseLogId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    log = EndpointLog(this);
    pain = EndpointPain(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointLog log;

  late final EndpointPain pain;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'log': log,
    'pain': pain,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
