require "dnn"
require "rl"
require_relative "dqn_model"
require_relative "cart_pole_env"

include RL::Callbacks

env = CartPole.new
model = DQN.load("trained_cart_pole.marshal")

agent = RL::DQNAgent.new(model, env)
agent.add_callback(LambdaCallback.new(:after_run) { puts "last step = #{agent.last_log[:step]}" })

agent.run
