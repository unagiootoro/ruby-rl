require "pycall/import"

include PyCall::Import

class CartPole < RL::Env
  pyimport :numpy, as: :np
  pyimport :gym

  def self.gym_make
    gym.make("CartPole-v0")
  end

  def initialize
    super(4, 2, 200)
    @env = self.class.gym_make
    @last_step = 0
    @env.reset
  end

  def step(action)
    action ||= rand(@action_size)
    _observation, _reward, done, _info = *@env.step(action)
    observation = @state_size.times.map { |i| _observation[i] }
    observation = Numo::SFloat.cast(observation)
    if done
      if @last_step >= 199
        reward = 1
      else
        reward = -1
      end
    else
      reward = 0
      @last_step += 1
    end
    [observation, reward, done]
  end

  def reset
    @last_step = 0
    @env.reset
  end

  def render
    @env.render
  end
end
