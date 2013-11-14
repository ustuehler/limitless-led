require 'socket'

class LimitlessLed

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

  private

  def send_packet(packet)
    socket.send packet, 0
  end

  def command(command_key)
    send_packet COMMANDS[command_key] + "\x00" + "\x55"
  end

end