require 'spec_helper'

describe LimitlessLed::Group do
  let(:group_number) { 1 }

  subject { LimitlessLed::Group.new(group_number, LimitlessLed::Bridge.new) }

  its(:bridge) { should be_a(LimitlessLed::Bridge) }

  describe '#on' do
    [[1, "\x45"], [2, "\x47"], [3, "\x49"], [4, "\x4B"]].each do |pair|
      it "turns on group #{pair[0]}" do
        group = LimitlessLed::Group.new(pair[0], LimitlessLed::Bridge.new)
        group.bridge.should_receive(:send_packet).with(pair[1] + "\x00\x55")
        group.on
      end
    end
  end

  describe '#off' do
    [[1, "\x46"], [2, "\x48"], [3, "\x4A"], [4, "\x4C"]].each do |pair|
      it "turns off group #{pair[0]}" do
        group = LimitlessLed::Group.new(pair[0], LimitlessLed::Bridge.new)
        group.bridge.should_receive(:send_packet).with(pair[1] + "\x00\x55")
        group.off
      end
    end
  end

  describe '#color' do
    it 'turns on the group and change its color' do
      subject.should_receive(:on)
      subject.should_receive(:sleep).with(0.1)
      subject.bridge.should_receive(:color).with(255)
      subject.color(255)
    end
  end

  describe '#brightness' do
    it 'turns on the group and change its brightness' do
      subject.should_receive(:on)
      subject.should_receive(:sleep).with(0.1)
      subject.bridge.should_receive(:brightness).with(255)
      subject.brightness(255)
    end
  end

  describe '#white' do
    it 'turns on the group and changes it to white' do
      subject.should_receive(:on)
      subject.should_receive(:sleep).with(0.1)
      subject.bridge.should_receive(:send_packet).with("\xc2\x00\x55")
      subject.white
    end
  end

end

