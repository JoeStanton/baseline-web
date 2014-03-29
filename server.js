var express = require('express');
var app = express();
app.use(express.logger('dev'));

// App Express Setup
app.use(express.static(__dirname));

app.get('*', function(req, res) {
  return res.sendfile('index.html');
});

app.listen(process.env.PORT || 8000);
