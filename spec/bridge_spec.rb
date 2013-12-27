require 'spec_helper'

describe LimitlessLed do

  let(:params) { {} }

  subject { LimitlessLed::Bridge.new(params) }

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
    context 'when given an integer 0 - 255' do
      it 'changes the color to 255 (blue)' do
        subject.should_receive(:send_packet).with("\x40" + 255.chr + "\x55")
        subject.color(255)
      end

      it 'changes the color to 89' do
        subject.should_receive(:send_packet).with("\x40" + 89.chr + "\x55")
        subject.color(89)
      end
    end

    context 'when given a ruby Color object' do
      it 'it changes the color to 0 (blue)' do
        subject.should_receive(:send_packet).with("\x40" + 0.chr + "\x55")
        subject.color(Color::RGB::Blue)
      end

      it 'it changes the color to 170 (red)' do
        subject.should_receive(:send_packet).with("\x40" + 170.chr + "\x55")
        subject.color(Color::RGB::Red)
      end
    end

    context 'when given a string' do
      it 'it changes the color to 0 (blue)' do
        subject.should_receive(:send_packet).with("\x40" + 0.chr + "\x55")
        subject.color('blue')
      end

      it 'it changes the color to 192 (pink)' do
        subject.should_receive(:send_packet).with("\x40" + 192.chr + "\x55")
        subject.color('DeepPink')
      end

      it 'it changes the color to 85 (green)' do
        subject.should_receive(:send_packet).with("\x40" + 85.chr + "\x55")
        subject.color('green')
      end

      it 'it changes the color to 170 (red)' do
        subject.should_receive(:send_packet).with("\x40" + 170.chr + "\x55")
        subject.color('red')
      end
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

