module LimitlessLed
  class Bridge

    COMMANDS = {
      all_off: 65,
      all_on: 66,
      disco: 77,
      disco_slower: 67,
      disco_faster: 68,
      color: 64
    }

    attr_accessor :host, :port

    def initialize(host: 'localhost', port: 8899)
      @host = host
      @port = port
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
      all_on
      sleep 0.1
      send_packet "\xc2\x00\x55"
    end

    def send_packet(packet)
      socket.send packet, 0
    end

    def command(command_key, command_param = 0)
      send_packet COMMANDS[command_key].chr + command_param.chr + 85.chr
    end

    def go_crazy
      while true
        send_packet(COLOR_PACKETS.sample)
      end
    end

    def color(color)
      command :color, color
    end

    def smooth_and_fast
      COLOR_PACKETS.cycle do |color_packet|
        send_packet(color_packet)
        sleep 1/100.0
      end
    end
  end
end
