require "dnn"
require "rl"
require "numo/linalg/autoloader"
require_relative "dqn_model"
require_relative "cart_pole_env"

include RL::Callbacks

env = CartPole.new
model = DQN.create(env.state_size, env.action_size)

agent = RL::DQNAgent.new(model, env, max_memory_size: 8192, ddqn: true)
cbk = LambdaCallback.new(:after_replay) do
  puts "step = #{agent.last_log[:step]}, reward = #{agent.last_log[:reward]}"
end
agent.add_callback(cbk)

agent.train(300)
model.save("trained_cart_pole.marshal")
