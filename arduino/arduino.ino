// https://www.dobitaobyte.com.br/socket-server-com-esp8266/
#include <ESP8266WiFi.h>
#include "config.h"

WiFiServer sockServer(SOCK_PORT);

void setup()
{
    Serial.begin(9600);
    delay(1000);
    WiFi.begin(SSID, PASSWD);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(100);
    }

    Serial.print("IP: ");
    Serial.println(WiFi.localIP());

    sockServer.begin();

    void loop()
    {
        WiFiClient client = sockServer.available();
        if (client)
        {
            while (client.connected())
            {
                while (client.available() > 0)
                {
                    uint8_t value = client.read();
                    Serial.write(value);
                }
                delay(10);
            }
            client.stop();
        }
    }