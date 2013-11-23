require 'spec_helper'

describe LimitlessLed do

  let(:params) { {} }

  subject { LimitlessLed.new(params) }

  describe 'can be initialized with default values' do
    its(:host) { should == 'localhost' }
    its(:port) { should == 8899 }
  end

  describe 'can be initialized with a host and port' do
    let(:params) { { host: '192.168.100.100', port: 6666 } }

    its(:host) { should == '192.168.100.100' }
    its(:port) { should == 6666 }
  end

  describe '#all_on' do
    it 'turns on all groups' do
      subject.should_receive(:send_packet).with("\x42\x00\x55")
      subject.all_on
    end
  end

  describe '#all_off' do
    it 'turns off all groups' do
      subject.should_receive(:send_packet).with("\x41\x00\x55")
      subject.all_off
    end
  end

  describe '#white' do
    it 'should set the color to white' do
      subject.should_receive(:all_on)
      subject.should_receive(:send_packet).with("\xc2\x00\x55")
      subject.white
    end
  end

  describe '#color' do
    it 'changes the color to 255' do
      subject.should_receive(:send_packet).with("\x40\xFF\x55")
      subject.color(255)
    end

    it 'changes the color to 255' do
      subject.should_receive(:send_packet).with("\x40\x55")
      subject.color(89)
    end
  end

  describe '#send_packet' do
    it 'should create a new socket and send the packet' do
      fake_socket = double(:fake_udp_socket)
      fake_socket.should_receive(:connect).with( subject.host, subject.port )
      fake_socket.should_receive(:send).with("stuff", 0)
      UDPSocket.should_receive(:new) { fake_socket }
      subject.send(:send_packet, "stuff")
    end
  end

end

