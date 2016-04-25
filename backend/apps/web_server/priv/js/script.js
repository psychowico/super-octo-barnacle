var SocketHandler = (function(){
  var my = {},
    websocket,
    messages = 0;

  my.init = function(){
    connect();
  };

  function connect() {
    websocket = new WebSocket('ws://localhost:8080/ws');
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
  };

  function onMessage(evt) {
    console.log('message incoming');
    console.log(evt);
  };

  function sendMessage(){
    message = { 'message': value};
    websocket.send(JSON.stringify(message));
  };

  function disconnect() {
    websocket.close();
  };

  function onOpen(evt) {
    console.log('open');
    console.log(evt);
  };

  function onClose(evt) {
    console.log('close');
    console.log(evt);
  };


  return my;
}());

SocketHandler.init();
