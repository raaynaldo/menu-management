data = File.open("restaurant_data.json")
json = JSON.load(data)

puts InsertingDataService.new.import(json)
