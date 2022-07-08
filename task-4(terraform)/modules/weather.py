import python_weather
import json

def getweather(city):

  client = python_weather.Client(format=python_weather.IMPERIAL)

  weather = client.find(city)
 
  client.close()

  return json.dumps({"city":city,"temperature":weather.current.temperature})