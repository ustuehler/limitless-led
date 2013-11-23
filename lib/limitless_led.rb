require 'socket'

# hex_colors = (0..255).map {|n| n.to_s(16)}.map{|hs| [hs].pack('*H')}
# color_packets = hex_colors.map {|color_str| "\x40" + color_str + "\x55" }

class LimitlessLed

  COLOR_PACKETS = 
    ["@\u0000U", "@\u0010U", "@ U", "@0U", "@@U", "@PU", "@`U", "@pU", "@\x80U", "@\x90U", "@\xA0U", "@\xB0U", "@\xC0U", "@\xD0U", "@\xE0U", "@\xF0U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@\u0010U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@ U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@0U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@@U", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@PU", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@`U", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@pU", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x80U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\x90U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xA0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xB0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xC0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xD0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xE0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U", "@\xF0U"] 

  COMMANDS = {
    all_off: "\x41",
    all_on: "\x42",
    disco: "\x4d",
    disco_slower: "\x43",
    disco_faster: "\x44"
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

  def command(command_key)
    send_packet COMMANDS[command_key] + "\x00" + "\x55"
  end

  def go_crazy
    while true
      send_packet(COLOR_PACKETS.sample)
    end
  end

  def color(color)
    send_packet "\x40#{color.to_s(16).hex.chr}\x55"
  end

  def smooth_and_fast
    COLOR_PACKETS.cycle do |color_packet|
      send_packet(color_packet)
      sleep 1/100.0
    end
  end
end
