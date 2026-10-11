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
import 'package:tidal_server/src/generated/insights/temperature_unit.dart'
    as _ixj5uu5w;
import 'package:tidal_server/src/generated/insights/weight_unit.dart'
    as _igx9991w;
import 'package:tidal_server/src/generated/journal/self_care_activity.dart'
    as _iq27cpnk;
import 'package:tidal_server/src/generated/log/drink_type.dart' as _iunt34pp;
import 'package:tidal_server/src/generated/log/flow_level.dart' as _idptobfz;
import 'package:tidal_server/src/generated/log/love_type.dart' as _i495j52x;
import 'package:tidal_server/src/generated/log/mood.dart' as _ij0gfvc4;
import 'package:tidal_server/src/generated/log/mucus_type.dart' as _iilodfy8;
import 'package:tidal_server/src/generated/log/severity.dart' as _inu6v1qs;
import 'package:tidal_server/src/generated/pain/dose_log.dart' as _ixayhju8;
import 'package:tidal_server/src/generated/pain/medication_type.dart'
    as _i4gcwlpe;
import 'package:tidal_server/src/generated/pain/pain_location.dart'
    as _iv8cvxsn;
import 'package:tidal_server/src/generated/period/period_change.dart'
    as _iwmr2amj;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../digestion/digestion_endpoint.dart' as _i635llya;
import '../insights/insight_endpoint.dart' as _irr87mt6;
import '../journal/journal_endpoint.dart' as _iz3uglki;
import '../log/log_endpoint.dart' as _iyqvybpl;
import '../pain/pain_endpoint.dart' as _i9flen3s;
import '../period/period_endpoint.dart' as _ivapd1ri;
import '../privacy/privacy_endpoint.dart' as _icoyrnl0;
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
      'digestion': _i635llya.DigestionEndpoint()
        ..initialize(
          server,
          'digestion',
          null,
        ),
      'insight': _irr87mt6.InsightEndpoint()
        ..initialize(
          server,
          'insight',
          null,
        ),
      'journal': _iz3uglki.JournalEndpoint()
        ..initialize(
          server,
          'journal',
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
      'period': _ivapd1ri.PeriodEndpoint()
        ..initialize(
          server,
          'period',
          null,
        ),
      'privacy': _icoyrnl0.PrivacyEndpoint()
        ..initialize(
          server,
          'privacy',
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
    connectors['digestion'] = _is.EndpointConnector(
      name: 'digestion',
      endpoint: endpoints['digestion']!,
      methodConnectors: {
        'logBowelMovement': _is.MethodConnector(
          name: 'logBowelMovement',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'timestamp': _is.ParameterDescription(
              name: 'timestamp',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'bristolType': _is.ParameterDescription(
              name: 'bristolType',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['digestion'] as _i635llya.DigestionEndpoint)
                  .logBowelMovement(
                    session,
                    params['date'],
                    params['timestamp'],
                    params['bristolType'],
                  ),
        ),
        'getBowelMovementRange': _is.MethodConnector(
          name: 'getBowelMovementRange',
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
              ) async => (endpoints['digestion'] as _i635llya.DigestionEndpoint)
                  .getBowelMovementRange(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
      },
    );
    connectors['insight'] = _is.EndpointConnector(
      name: 'insight',
      endpoint: endpoints['insight']!,
      methodConnectors: {
        'getPrediction': _is.MethodConnector(
          name: 'getPrediction',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getPrediction(session),
        ),
        'getCycleSummary': _is.MethodConnector(
          name: 'getCycleSummary',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getCycleSummary(session),
        ),
        'hasCycleSettings': _is.MethodConnector(
          name: 'hasCycleSettings',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .hasCycleSettings(session),
        ),
        'getBirthYear': _is.MethodConnector(
          name: 'getBirthYear',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getBirthYear(session),
        ),
        'saveBirthYear': _is.MethodConnector(
          name: 'saveBirthYear',
          params: {
            'year': _is.ParameterDescription(
              name: 'year',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .saveBirthYear(
                    session,
                    params['year'],
                  ),
        ),
        'getAge': _is.MethodConnector(
          name: 'getAge',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getAge(session),
        ),
        'getCycleLength': _is.MethodConnector(
          name: 'getCycleLength',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getCycleLength(session),
        ),
        'saveCycleLength': _is.MethodConnector(
          name: 'saveCycleLength',
          params: {
            'days': _is.ParameterDescription(
              name: 'days',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .saveCycleLength(
                    session,
                    params['days'],
                  ),
        ),
        'getPeriodLength': _is.MethodConnector(
          name: 'getPeriodLength',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getPeriodLength(session),
        ),
        'savePeriodLength': _is.MethodConnector(
          name: 'savePeriodLength',
          params: {
            'days': _is.ParameterDescription(
              name: 'days',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .savePeriodLength(
                    session,
                    params['days'],
                  ),
        ),
        'getUnitPreferences': _is.MethodConnector(
          name: 'getUnitPreferences',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .getUnitPreferences(session),
        ),
        'saveWeightUnit': _is.MethodConnector(
          name: 'saveWeightUnit',
          params: {
            'unit': _is.ParameterDescription(
              name: 'unit',
              type: _is.getType<_igx9991w.WeightUnit>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .saveWeightUnit(
                    session,
                    params['unit'],
                  ),
        ),
        'saveTemperatureUnit': _is.MethodConnector(
          name: 'saveTemperatureUnit',
          params: {
            'unit': _is.ParameterDescription(
              name: 'unit',
              type: _is.getType<_ixj5uu5w.TemperatureUnit>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insight'] as _irr87mt6.InsightEndpoint)
                  .saveTemperatureUnit(
                    session,
                    params['unit'],
                  ),
        ),
      },
    );
    connectors['journal'] = _is.EndpointConnector(
      name: 'journal',
      endpoint: endpoints['journal']!,
      methodConnectors: {
        'getDay': _is.MethodConnector(
          name: 'getDay',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journal'] as _iz3uglki.JournalEndpoint).getDay(
                    session,
                    params['date'],
                  ),
        ),
        'saveDay': _is.MethodConnector(
          name: 'saveDay',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'activities': _is.ParameterDescription(
              name: 'activities',
              type: _is.getType<List<_iq27cpnk.SelfCareActivity>>(),
              nullable: false,
            ),
            'bestMoment': _is.ParameterDescription(
              name: 'bestMoment',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['journal'] as _iz3uglki.JournalEndpoint).saveDay(
                    session,
                    params['date'],
                    params['activities'],
                    params['bestMoment'],
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
        'saveDrinkCount': _is.MethodConnector(
          name: 'saveDrinkCount',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'drink': _is.ParameterDescription(
              name: 'drink',
              type: _is.getType<_iunt34pp.DrinkType>(),
              nullable: false,
            ),
            'count': _is.ParameterDescription(
              name: 'count',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['log'] as _iyqvybpl.LogEndpoint).saveDrinkCount(
                    session,
                    params['date'],
                    params['drink'],
                    params['count'],
                  ),
        ),
        'saveSleep': _is.MethodConnector(
          name: 'saveSleep',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'quality': _is.ParameterDescription(
              name: 'quality',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'hours': _is.ParameterDescription(
              name: 'hours',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).saveSleep(
                session,
                params['date'],
                params['quality'],
                params['hours'],
              ),
        ),
        'saveDigestionDay': _is.MethodConnector(
          name: 'saveDigestionDay',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'bloating': _is.ParameterDescription(
              name: 'bloating',
              type: _is.getType<_inu6v1qs.Severity?>(),
              nullable: true,
            ),
            'acidReflux': _is.ParameterDescription(
              name: 'acidReflux',
              type: _is.getType<_inu6v1qs.Severity?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['log'] as _iyqvybpl.LogEndpoint).saveDigestionDay(
                    session,
                    params['date'],
                    params['bloating'],
                    params['acidReflux'],
                  ),
        ),
        'saveWeight': _is.MethodConnector(
          name: 'saveWeight',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'kg': _is.ParameterDescription(
              name: 'kg',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).saveWeight(
                session,
                params['date'],
                params['kg'],
              ),
        ),
        'saveTemperature': _is.MethodConnector(
          name: 'saveTemperature',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'celsius': _is.ParameterDescription(
              name: 'celsius',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['log'] as _iyqvybpl.LogEndpoint).saveTemperature(
                    session,
                    params['date'],
                    params['celsius'],
                  ),
        ),
        'saveMucus': _is.MethodConnector(
          name: 'saveMucus',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'mucus': _is.ParameterDescription(
              name: 'mucus',
              type: _is.getType<_iilodfy8.MucusType?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).saveMucus(
                session,
                params['date'],
                params['mucus'],
              ),
        ),
        'saveLove': _is.MethodConnector(
          name: 'saveLove',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'love': _is.ParameterDescription(
              name: 'love',
              type: _is.getType<_i495j52x.LoveType?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['log'] as _iyqvybpl.LogEndpoint).saveLove(
                session,
                params['date'],
                params['love'],
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
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'timestamp': _is.ParameterDescription(
              name: 'timestamp',
              type: _is.getType<DateTime>(),
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
                params['date'],
                params['timestamp'],
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
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_i4gcwlpe.MedicationType?>(),
              nullable: true,
            ),
            'reminderEveryHours': _is.ParameterDescription(
              name: 'reminderEveryHours',
              type: _is.getType<int?>(),
              nullable: true,
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
                    type: params['type'],
                    reminderEveryHours: params['reminderEveryHours'],
                  ),
        ),
        'setReminder': _is.MethodConnector(
          name: 'setReminder',
          params: {
            'medicationId': _is.ParameterDescription(
              name: 'medicationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'hours': _is.ParameterDescription(
              name: 'hours',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).setReminder(
                    session,
                    params['medicationId'],
                    params['hours'],
                  ),
        ),
        'getReminders': _is.MethodConnector(
          name: 'getReminders',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint)
                  .getReminders(session),
        ),
        'dismissReminder': _is.MethodConnector(
          name: 'dismissReminder',
          params: {
            'reminderId': _is.ParameterDescription(
              name: 'reminderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).dismissReminder(
                    session,
                    params['reminderId'],
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
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'timestamp': _is.ParameterDescription(
              name: 'timestamp',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint).logDose(
                session,
                params['medicationId'],
                params['date'],
                params['timestamp'],
              ),
        ),
        'deleteDose': _is.MethodConnector(
          name: 'deleteDose',
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
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).deleteDose(
                    session,
                    params['doseLogId'],
                  ),
        ),
        'restoreDose': _is.MethodConnector(
          name: 'restoreDose',
          params: {
            'dose': _is.ParameterDescription(
              name: 'dose',
              type: _is.getType<_ixayhju8.DoseLog>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pain'] as _i9flen3s.PainEndpoint).restoreDose(
                    session,
                    params['dose'],
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
        'getLastDosePerMedication': _is.MethodConnector(
          name: 'getLastDosePerMedication',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pain'] as _i9flen3s.PainEndpoint)
                  .getLastDosePerMedication(session),
        ),
      },
    );
    connectors['period'] = _is.EndpointConnector(
      name: 'period',
      endpoint: endpoints['period']!,
      methodConnectors: {
        'longPress': _is.MethodConnector(
          name: 'longPress',
          params: {
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['period'] as _ivapd1ri.PeriodEndpoint).longPress(
                    session,
                    params['date'],
                  ),
        ),
        'undo': _is.MethodConnector(
          name: 'undo',
          params: {
            'change': _is.ParameterDescription(
              name: 'change',
              type: _is.getType<_iwmr2amj.PeriodChange>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['period'] as _ivapd1ri.PeriodEndpoint).undo(
                session,
                params['change'],
              ),
        ),
        'getPeriods': _is.MethodConnector(
          name: 'getPeriods',
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
                  (endpoints['period'] as _ivapd1ri.PeriodEndpoint).getPeriods(
                    session,
                    params['start'],
                    params['end'],
                  ),
        ),
        'getDefaultPeriodLength': _is.MethodConnector(
          name: 'getDefaultPeriodLength',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['period'] as _ivapd1ri.PeriodEndpoint)
                  .getDefaultPeriodLength(session),
        ),
      },
    );
    connectors['privacy'] = _is.EndpointConnector(
      name: 'privacy',
      endpoint: endpoints['privacy']!,
      methodConnectors: {
        'deleteAllMyData': _is.MethodConnector(
          name: 'deleteAllMyData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['privacy'] as _icoyrnl0.PrivacyEndpoint)
                  .deleteAllMyData(session),
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
