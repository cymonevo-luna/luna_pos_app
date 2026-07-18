import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/network/api_exception.dart';

DioException _badResponse({
  required int statusCode,
  required Map<String, dynamic> data,
}) {
  final requestOptions = RequestOptions(path: '/api/v1/test');
  return DioException(
    requestOptions: requestOptions,
    response: Response(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  test('422 field error surfaces is required in message', () {
    final exception = ApiException.fromDio(
      _badResponse(
        statusCode: 422,
        data: {
          'success': false,
          'error': {
            'code': 'validation_error',
            'message': 'validation failed: order_option_id is required',
            'fields': {'order_option_id': 'is required'},
          },
        },
      ),
    );

    expect(exception.type, ApiErrorType.badRequest);
    expect(exception.statusCode, 422);
    expect(exception.message, contains('is required'));
    expect(exception.message, isNot('Something went wrong.'));
  });

  test('400 with error.message surfaces that message', () {
    final exception = ApiException.fromDio(
      _badResponse(
        statusCode: 400,
        data: {
          'success': false,
          'error': {
            'message': 'amount must be positive',
          },
        },
      ),
    );

    expect(exception.type, ApiErrorType.badRequest);
    expect(exception.message, 'amount must be positive');
  });

  test('422 without error.message keeps default bad request message', () {
    final exception = ApiException.fromDio(
      _badResponse(
        statusCode: 422,
        data: {
          'success': false,
          'error': {
            'fields': {'order_option_id': 'is required'},
          },
        },
      ),
    );

    expect(exception.type, ApiErrorType.badRequest);
    expect(exception.message, 'Invalid request.');
    expect(exception.data, isNotNull);
  });

  test('existing status mappings are preserved', () {
    expect(
      ApiException.fromDio(_badResponse(statusCode: 401, data: {})).type,
      ApiErrorType.unauthorized,
    );
    expect(
      ApiException.fromDio(_badResponse(statusCode: 403, data: {})).type,
      ApiErrorType.forbidden,
    );
    expect(
      ApiException.fromDio(_badResponse(statusCode: 404, data: {})).type,
      ApiErrorType.notFound,
    );
    expect(
      ApiException.fromDio(_badResponse(statusCode: 409, data: {})).type,
      ApiErrorType.conflict,
    );
    expect(
      ApiException.fromDio(
        _badResponse(
          statusCode: 500,
          data: {'error': {'message': 'db down'}},
        ),
      ).message,
      'db down',
    );
  });
}
