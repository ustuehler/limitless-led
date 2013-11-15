require './limitless_led'

bridge = LimitlessLed.new(host: '172.16.0.7', port: 8899)
#bridge.all_on
bridge.disco_faster
