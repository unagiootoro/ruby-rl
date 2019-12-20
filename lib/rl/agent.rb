module RL
  class Agent
    attr_accessor :model
    attr_accessor :gamma
    attr_reader :last_log

    def initialize(model, env,
                   max_memory_size: 1024,
                   train_memory_size: nil,
                   batch_size: 64,
                   gamma: 0.99,
                   policy: Policies::EpsGreedy.new)
      @model = model
      @env = env
      @memory = Memory.new(max_memory_size, train_memory_size || batch_size)
      @batch_size = batch_size
      @gamma = gamma
      @callbacks = []
      @target_model = nil
      @last_log = {}
      @policy = policy
    end

    def replay
      raise NotImplementedError, "Class '#{self.class.name}' has implement method 'replay'"
    end

    def compute_q_value(reward, next_state)
      raise NotImplementedError, "Class '#{self.class.name}' has implement method 'compute_q_value'"
    end

    # def pre_epispde; end
    # def post_episode; end

    def train(epochs)
      (1..epochs).each do |episode|
        puts "episode: #{episode}"
        pre_epispde if respond_to?(:pre_epispde)
        observation = nil
        @env.max_step.times do |step|
          if step == 0
            observation, reward, done = *@env.step(nil)
          else
            action = get_action(observation, episode)
            next_observation, reward, done = *@env.step(action)
            next_observation = nil if done
            @memory.add([observation, action, reward, next_observation])
            observation = next_observation unless done
          end
          if done
            @last_log[:step] = step
            @last_log[:observation] = observation
            @last_log[:action] = action
            @last_log[:reward] = reward
            call_callbacks(:before_replay)
            loss = replay if @memory.can_train?
            @last_log[:loss] = loss
            call_callbacks(:after_replay)
            @env.reset
            break
          end
        end
        post_episode if respond_to?(:post_episode)
      end
    end

    def run(max_steps: 200)
      call_callbacks(:before_run)
      observation = nil
      logging = true
      max_steps.times do |step|
        call_callbacks(:before_running)
        action = if step == 0
          rand(@env.action_size)
        else
          result = @model.predict1(Numo::SFloat.cast(observation))
          result.max_index
        end
        observation, reward, done, info = *@env.step(action)
        if logging
          @last_log[:step] = step
          @last_log[:observation] = observation
          @last_log[:action] = action
          @last_log[:reward] = reward
          call_callbacks(:after_running)
        end
        logging = false if done
        @env.render
      end
      call_callbacks(:after_run)
    end

    def add_callback(callback)
      callback.model = @model
      callback.agent = self
      callback.env = @env
      @callbacks << callback
    end

    def clear_callbacks
      @callbacks = []
    end

    def call_callbacks(event)
      @callbacks.each do |callback|
        callback.send(event) if callback.respond_to?(event)
      end
    end

    def make_batch(memory_batch)
      x = Numo::SFloat.zeros(@batch_size, @env.state_size)
      y = Numo::SFloat.zeros(@batch_size, @env.action_size)
      memory_batch.each.with_index do |(state, action, reward, next_state), i|
        x[i, false] = state
        q_value = compute_q_value(@model, @target_model, reward, next_state)
        q_values = @model.predict1(state)
        q_values[action] = q_value
        y[i, false] = q_values
      end
      [x, y]
    end

    def get_action(observation, episode)
      if @policy.predict?(episode) && observation
        res = @model.predict1(observation)
        action = res.max_index
      else
        action = rand(@env.action_size)
      end
      action
    end
  end
end
