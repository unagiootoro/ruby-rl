include DNN::Models
include DNN::Layers
include DNN::Optimizers
include DNN::Losses

class DQN < Model
  def self.create(state_size, action_size)
    model = self.new(state_size, action_size)
    model.setup(RMSPropGraves.new(lr: 0.01), HuberLoss.new)
    model
  end

  def initialize(state_size, action_size)
    super()
    @input = InputLayer.new(state_size)
    @l1 = Dense.new(32)
    @l2 = Dense.new(32)
    @l3 = Dense.new(32)
    @l4 = Dense.new(action_size)
  end

  def call(x)
    x = @input.(x)
    x = @l1.(x)
    x = ReLU.(x)
    
    x = @l2.(x)
    x = ReLU.(x)

    x = @l3.(x)
    x = ReLU.(x)

    x = @l4.(x)
    x
  end
end
