module LimitlessLed
  class Group
    attr_reader :bridge

    def initialize(number, bridge)
      raise(ArgumentError.new('Group number must be 1, 2, 3 or 4')) unless (1..4).include?(number)
      @number = number
      @bridge = bridge
    end

    def on
      bridge.command "group_#{@number}_on".to_sym
    end

    def off
      bridge.command "group_#{@number}_off".to_sym
    end

    %w{ color brightness white }.each do |cmd|
      define_method cmd do |arg = nil|
        on
        sleep(0.1)
        bridge.send(*[cmd, arg].compact)
      end
    end
  end
end