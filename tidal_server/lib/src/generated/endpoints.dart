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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:tidal_server/src/generated/future_calls.dart' as _i0nkkjyq;
import 'package:tidal_server/src/generated/log/flow_level.dart' as _idptobfz;
import 'package:tidal_server/src/generated/log/mood.dart' as _ij0gfvc4;
import 'package:tidal_server/src/generated/pain/pain_location.dart'
    as _iv8cvxsn;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../log/log_endpoint.dart' as _iyqvybpl;
import '../pain/pain_endpoint.dart' as _i9flen3s;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'log': _iyqvybpl.LogEndpoint()
        ..initialize(
          server,
          'log',
          null,
        ),
      'pain': _i9flen3s.PainEndpoint()
        ..initialize(
          server,
          'pain',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['log'] = _is.EndpointConnector(
      name: 'log',
      endpoint: endpoints['log']!,
      methodConnectors: {
        'saveDay': _is.MethodConnector(
          name: 'saveDay',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'flow': _is.ParameterDescription(
              name: 'flow',
              type: _is.getType<_idptobfz.FlowLevel?>(),
              nullable: true,
            ),
            'mood': _is.ParameterDescription(
              name: 'mood',
              type: _is.getType<_ij0gfvc4.Mood?>(),
              nullable: true,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).saveDay(
                session,
                params['date'],
                flow: params['flow'],
                mood: params['mood'],
                note: params['note'],
              ),
        ),
        'getRange': _is.MethodConnector(
          name: 'getRange',
          params: {
            'start': _is.ParameterDescription(
              name: 'start',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'end': _is.ParameterDescription(
              name: 'end',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).getRange(
                session,
                params['start'],
                params['end'],
              ),
        ),
        'deleteAll': _is.MethodConnector(
          name: 'deleteAll',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).deleteAll(
                session,
              ),
        ),
      },
    );
    connectors['pain'] = _is.EndpointConnector(
      name: 'pain',
      endpoint: endpoints['pain']!,
      methodConnectors: {
        'logPain': _is.MethodConnector(
          name: 'logPain',
          params: {
            'level': _is.ParameterDescription(
              name: 'level',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'locations': _is.ParameterDescription(
              name: 'locations',
              type: _is.getType<List<_iv8cvxsn.PainLocation>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint).logPain(
                session,
                params['level'],
                params['locations'],
              ),
        ),
        'getPainRange': _is.MethodConnector(
          name: 'getPainRange',
          params: {
            'start': _is.ParameterDescription(
              name: 'start',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'end': _is.ParameterDescription(
              name: 'end',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).getPainRange(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
        'myMeds': _is.MethodConnector(
          name: 'myMeds',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).myMeds(session),
        ),
        'addMedication': _is.MethodConnector(
          name: 'addMedication',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'usualDose': _is.ParameterDescription(
              name: 'usualDose',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).addMedication(
                    session,
                    params['name'],
                    params['usualDose'],
                  ),
        ),
        'logDose': _is.MethodConnector(
          name: 'logDose',
          params: {
            'medicationId': _is.ParameterDescription(
              name: 'medicationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'painBefore': _is.ParameterDescription(
              name: 'painBefore',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint).logDose(
                session,
                params['medicationId'],
                painBefore: params['painBefore'],
              ),
        ),
        'getDoseRange': _is.MethodConnector(
          name: 'getDoseRange',
          params: {
            'start': _is.ParameterDescription(
              name: 'start',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'end': _is.ParameterDescription(
              name: 'end',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).getDoseRange(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
        'getLastDose': _is.MethodConnector(
          name: 'getLastDose',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint)
                  .getLastDose(session),
        ),
        'getPendingCheckIn': _is.MethodConnector(
          name: 'getPendingCheckIn',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint)
                  .getPendingCheckIn(session),
        ),
        'recordRelief': _is.MethodConnector(
          name: 'recordRelief',
          params: {
            'doseLogId': _is.ParameterDescription(
              name: 'doseLogId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'painAfter': _is.ParameterDescription(
              name: 'painAfter',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).recordRelief(
                    session,
                    params['doseLogId'],
                    params['painAfter'],
                  ),
        ),
        'snoozeCheckIn': _is.MethodConnector(
          name: 'snoozeCheckIn',
          params: {
            'doseLogId': _is.ParameterDescription(
              name: 'doseLogId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).snoozeCheckIn(
                    session,
                    params['doseLogId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i0nkkjyq.FutureCalls();
  }
}
