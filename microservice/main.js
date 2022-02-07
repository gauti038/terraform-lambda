module.exports.getAPI = async (event) => {
    console.log('Event: ', event);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        "username":"xyz", 
        "password":"xyz"
      }),
    }
}

module.exports.postAPI = (event, context, callback) => {
  console.log(event.body)
  callback(null,{
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: event.body
  })
};