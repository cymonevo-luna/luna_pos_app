const kTestOrderOptionId = '11111111-1111-1111-1111-111111111111';

const kTestOrderOptionsResponse = {
  'success': true,
  'data': {
    'options': [
      {
        'id': kTestOrderOptionId,
        'name': 'Take Away',
        'priority': 10,
      },
    ],
  },
};

const kTestOrderOptionIdBodyField = {
  'order_option_id': kTestOrderOptionId,
};
