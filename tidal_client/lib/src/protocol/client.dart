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
import 'package:tidal_client/src/protocol/insights/cycle_summary.dart'
    as _iw3iju6d;
import 'package:tidal_client/src/protocol/insights/prediction.dart'
    as _iodim5iz;
import 'package:tidal_client/src/protocol/log/day_log.dart' as _i91iyawq;
import 'package:tidal_client/src/protocol/log/flow_level.dart' as _ieqssu4z;
import 'package:tidal_client/src/protocol/log/mood.dart' as _io0y0e3q;
import 'package:tidal_client/src/protocol/pain/dose_log.dart' as _i95dlci0;
import 'package:tidal_client/src/protocol/pain/medication.dart' as _i2f8rdmx;
import 'package:tidal_client/src/protocol/pain/medication_type.dart'
    as _ij1j67ck;
import 'package:tidal_client/src/protocol/pain/pain_entry.dart' as _imzr3ook;
import 'package:tidal_client/src/protocol/pain/pain_location.dart' as _ivkbsfwn;
import 'package:tidal_client/src/protocol/period/period_change.dart'
    as _i992737b;
import 'package:tidal_client/src/protocol/period/period_length_info.dart'
    as _im0wuj63;
import 'package:tidal_client/src/protocol/period/period_span.dart' as _idzkd17y;
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

/// Turns the signed-in user's periods into cycle predictions, and manages
/// the `CycleSettings` collected at sign-up (cycle length, period length,
/// birth year).
///
/// Predictions themselves are never persisted — every call recomputes them
/// from the user's `Period` rows, so starting, ending, or removing a period
/// is reflected immediately with no separate record to keep in sync. Age is
/// the same way: only birth year is stored, and age is always computed
/// fresh from it, so it's never stale.
/// {@category Endpoint}
class EndpointInsight extends _isc.EndpointRef {
  EndpointInsight(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insight';

  _ida.Future<_iodim5iz.Prediction> getPrediction() =>
      caller.callServerEndpoint<_iodim5iz.Prediction>(
        'insight',
        'getPrediction',
        {},
      );

  /// Average cycle and period length, plus the recent cycles behind them,
  /// for the Insights tab.
  _ida.Future<_iw3iju6d.CycleSummary> getCycleSummary() =>
      caller.callServerEndpoint<_iw3iju6d.CycleSummary>(
        'insight',
        'getCycleSummary',
        {},
      );

  /// Whether the signed-in user has completed sign-up's cycle length /
  /// period length / birth year step. Gates that one-time flow — it stays
  /// false until birth year is saved, even if cycle/period length were
  /// saved earlier (e.g. before this field existed).
  _ida.Future<bool> hasCycleSettings() => caller.callServerEndpoint<bool>(
    'insight',
    'hasCycleSettings',
    {},
  );

  /// The signed-in user's saved birth year, or null if they haven't set one.
  _ida.Future<int?> getBirthYear() => caller.callServerEndpoint<int?>(
    'insight',
    'getBirthYear',
    {},
  );

  /// Saves the signed-in user's birth year, used to compute [getAge]. Only
  /// the year is ever asked for or stored — see `CycleSettings.birthYear`.
  /// Asked once, at sign-up (saving it completes sign-up); it can't be
  /// changed afterwards.
  _ida.Future<void> saveBirthYear(int year) => caller.callServerEndpoint<void>(
    'insight',
    'saveBirthYear',
    {'year': year},
  );

  /// The signed-in user's current age in years, computed from their saved
  /// birth year. Null if they haven't set one. Since only the year is
  /// known (never the month or day), this can be one year ahead of the
  /// true age until their actual birthday passes each year.
  _ida.Future<int?> getAge() => caller.callServerEndpoint<int?>(
    'insight',
    'getAge',
    {},
  );

  /// Typical days between period starts. Defaults to 28 until the user sets
  /// their own (at sign-up, or later from Me).
  _ida.Future<int> getCycleLength() => caller.callServerEndpoint<int>(
    'insight',
    'getCycleLength',
    {},
  );

  /// Saves how many days typically pass between period starts. Only allowed
  /// during sign-up (before birth year completes it), as the user's first
  /// estimate — it seeds predictions until real cycles have been logged, and
  /// the learned average is shown on Insights afterwards.
  _ida.Future<void> saveCycleLength(int days) =>
      caller.callServerEndpoint<void>(
        'insight',
        'saveCycleLength',
        {'days': days},
      );

  /// How many days the signed-in user's period usually lasts. Defaults to
  /// 5 until they set their own.
  _ida.Future<int> getPeriodLength() => caller.callServerEndpoint<int>(
    'insight',
    'getPeriodLength',
    {},
  );

  /// Saves how many days the signed-in user's period usually lasts. Only
  /// allowed during sign-up (before birth year completes it) — afterwards
  /// the default comes from the user's own recorded periods instead (see
  /// `computeDefaultPeriodLength`), and Me only shows it.
  _ida.Future<void> savePeriodLength(int days) =>
      caller.callServerEndpoint<void>(
        'insight',
        'savePeriodLength',
        {'days': days},
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

/// Endpoint for pain logging and the user's medications list. Tidal only
/// ever records what the user says they took; it never suggests doses.
///
/// Pain entries and doses each store the day they belong to, the time they
/// happened (chosen by the user, defaulting to now in the app), and the
/// exact moment they were saved.
///
/// Every method only ever reads or writes the signed-in user's own data.
/// {@category Endpoint}
class EndpointPain extends _isc.EndpointRef {
  EndpointPain(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pain';

  /// Logs a pain entry for [date] (the calendar day it belongs to) that
  /// happened at [timestamp].
  _ida.Future<_imzr3ook.PainEntry> logPain(
    int level,
    List<_ivkbsfwn.PainLocation> locations,
    DateTime date,
    DateTime timestamp,
  ) => caller.callServerEndpoint<_imzr3ook.PainEntry>(
    'pain',
    'logPain',
    {
      'level': level,
      'locations': locations,
      'date': date,
      'timestamp': timestamp,
    },
  );

  /// Returns the pain entries for the days [start] through [end]
  /// (inclusive), ordered by time.
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

  /// Adds a new medication to the signed-in user's list. [type] is optional.
  _ida.Future<_i2f8rdmx.Medication> addMedication(
    String name,
    String usualDose, {
    _ij1j67ck.MedicationType? type,
  }) => caller.callServerEndpoint<_i2f8rdmx.Medication>(
    'pain',
    'addMedication',
    {
      'name': name,
      'usualDose': usualDose,
      'type': type,
    },
  );

  /// One-tap logging: records that [medicationId] was taken at [timestamp],
  /// on [date] (the calendar day it belongs to), using its usual dose.
  _ida.Future<_i95dlci0.DoseLog> logDose(
    int medicationId,
    DateTime date,
    DateTime timestamp,
  ) => caller.callServerEndpoint<_i95dlci0.DoseLog>(
    'pain',
    'logDose',
    {
      'medicationId': medicationId,
      'date': date,
      'timestamp': timestamp,
    },
  );

  /// Returns the dose logs for the days [start] through [end] (inclusive),
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

  /// The most recent dose of each medication the user has ever taken, so
  /// the Medications sheet can show "last taken 3h ago" per medication.
  _ida.Future<List<_i95dlci0.DoseLog>> getLastDosePerMedication() =>
      caller.callServerEndpoint<List<_i95dlci0.DoseLog>>(
        'pain',
        'getLastDosePerMedication',
        {},
      );
}

/// Starting, ending, and removing periods by long-pressing Calendar days,
/// plus reading them back for the Calendar. See "Period tracking" in
/// CLAUDE.md for the rules.
///
/// Every method only ever reads or writes the signed-in user's own data.
/// {@category Endpoint}
class EndpointPeriod extends _isc.EndpointRef {
  EndpointPeriod(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'period';

  /// Applies a long-press on [date] and returns what happened, so the app
  /// can describe it and offer Undo. In order:
  ///
  /// 1. On a period's start date: removes that period.
  /// 2. Up to the 10th day of the latest period that started before it (or
  ///    anywhere inside that period's assumed days): sets it as the end.
  /// 3. Up to 9 days before the next period's start: moves that start
  ///    earlier to [date], rather than creating an overlapping period.
  /// 4. Otherwise: starts a new period on [date], with an assumed end.
  ///
  /// Throws for future dates — periods can only be logged for today or
  /// earlier.
  _ida.Future<_i992737b.PeriodChange> longPress(DateTime date) =>
      caller.callServerEndpoint<_i992737b.PeriodChange>(
        'period',
        'longPress',
        {'date': date},
      );

  /// Reverses a change returned by [longPress] (the "Undo" button).
  _ida.Future<void> undo(_i992737b.PeriodChange change) =>
      caller.callServerEndpoint<void>(
        'period',
        'undo',
        {'change': change},
      );

  /// Every period overlapping [start]..[end] (inclusive days), with
  /// assumed end dates filled in, ordered by start date.
  _ida.Future<List<_idzkd17y.PeriodSpan>> getPeriods(
    DateTime start,
    DateTime end,
  ) => caller.callServerEndpoint<List<_idzkd17y.PeriodSpan>>(
    'period',
    'getPeriods',
    {
      'start': start,
      'end': end,
    },
  );

  /// The signed-in user's default period length and where it comes from
  /// (shown read-only on Me).
  _ida.Future<_im0wuj63.PeriodLengthInfo> getDefaultPeriodLength() =>
      caller.callServerEndpoint<_im0wuj63.PeriodLengthInfo>(
        'period',
        'getDefaultPeriodLength',
        {},
      );
}

/// "Delete all my data" from the Privacy screen.
/// {@category Endpoint}
class EndpointPrivacy extends _isc.EndpointRef {
  EndpointPrivacy(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privacy';

  /// Permanently deletes everything tied to the signed-in user — day logs,
  /// periods, pain entries, medications and doses, sign-up answers — and
  /// then their account itself, signing them out everywhere. Nothing is
  /// kept, not even anonymously.
  ///
  /// Runs in one transaction, so either everything is deleted or nothing is.
  _ida.Future<void> deleteAllMyData() => caller.callServerEndpoint<void>(
    'privacy',
    'deleteAllMyData',
    {},
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
    insight = EndpointInsight(this);
    log = EndpointLog(this);
    pain = EndpointPain(this);
    period = EndpointPeriod(this);
    privacy = EndpointPrivacy(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointInsight insight;

  late final EndpointLog log;

  late final EndpointPain pain;

  late final EndpointPeriod period;

  late final EndpointPrivacy privacy;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'insight': insight,
    'log': log,
    'pain': pain,
    'period': period,
    'privacy': privacy,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
