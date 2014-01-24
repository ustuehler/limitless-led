module LimitlessLed
  class Bridge
    include Colors

    COMMANDS = {
      all_off: 65,
      all_on: 66,
      disco: 77,
      disco_slower: 67,
      disco_faster: 68,
      color: 64,
      brightness: 78,
      group_1_on: 69,
      group_1_off: 70,
      group_2_on: 71,
      group_2_off: 72,
      group_3_on: 73,
      group_3_off: 74,
      group_4_on: 75,
      group_4_off: 76
    }

    attr_accessor :host, :port

    def initialize(host: 'localhost', port: 8899)
      @host = host
      @port = port
    end

    def group(number)
      LimitlessLed::Group.new(number, self)
    end

    def socket
      @socket ||= begin
        UDPSocket.new.tap do |socket|
          socket.connect host, port
        end
      end
    end

    COMMANDS.each do |cmd, _|
      define_method(cmd) { command cmd }
    end

    def white
      send_packet "\xc2\x00\x55"
    end

    def color(color)
      color_code = if color.is_a?(Color::RGB)
         color_code_from_color(color)
       elsif color.is_a?(Integer)
         color
       elsif color.is_a?(String)
         color_code_from_color Color::RGB.const_get(color.camelize)
       end

      command :color, color_code
    end

    def brightness(amount)
      raise(ArgumentError.new('Brightness must be within 2 - 27')) unless (2..27).include?(amount)
      command :brightness, amount
    end

    def send_packet(packet)
      socket.send packet, 0
    end

    def command(command_key, command_param = 0)
      send_packet COMMANDS[command_key].chr + command_param.chr + 85.chr
    end

    def go_crazy
      while true
        color rand(256)
      end
    end

    def smooth_and_fast
      0..255.cycle do |color_code|
        color color_code
        sleep 1/100.0
      end
    end
  end
end
