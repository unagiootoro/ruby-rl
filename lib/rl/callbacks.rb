module RL
  module Callbacks

    class Callback
      attr_accessor :model
      attr_accessor :env
      attr_accessor :agent
    end

    class LambdaCallback < Callback
      def initialize(event, lambda = nil, &block)
        lambda = block if block
        instance_eval do
          define_singleton_method(event) { lambda.call }
        end
      end
    end
    
  end
end
