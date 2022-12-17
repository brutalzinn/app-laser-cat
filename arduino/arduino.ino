/***
Exemplo de https://josecintra.com/blog/comunicacao-websockets-nodemcu-esp8266/
***/

#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include "config.h"

//Correção nivel lógico invertido
#define ON LOW
#define OFF HIGH

WebSocketsServer webSocket = WebSocketsServer(SOCK_PORT); // Recebe dados do cliente

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t lenght) {

  switch (type) {
    case WStype_DISCONNECTED:
      break;

    case WStype_CONNECTED:
      { IPAddress ip = webSocket.remoteIP(num);
        Serial.println(ip);
      }
      break;

    case WStype_TEXT:
      { String text = String((char *) &payload[0]);
        Serial.println(text);
        Serial.println(num);
        Serial.println(type);

        if (text == "ON") {
          digitalWrite(LED_BUILTIN, ON);
        } else {
          digitalWrite(LED_BUILTIN, OFF);
        }
      }
      break;

  }

}

void setup() {
  
  // Inicialização do LED
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, OFF);
  // Conexões wi-fi e websocket
  WiFi.begin(SSID, PASSWD);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(". ");
    delay(100);
  }
  Serial.println(WiFi.localIP());
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

}

void loop() {
  webSocket.loop();
}
