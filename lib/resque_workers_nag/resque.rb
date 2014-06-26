require 'resque'

module ResqueWorkersNag
  class NoSuchQueue < RuntimeError; end

  class ResqueQueues
    attr_reader :queues

    def initialize hostname='localhost', port=6379
      Resque.redis = "#{hostname}:#{port}"
      @queues = Resque.queues
    end

    def length queue
      q = @queues.include?(queue) or raise NoSuchQueue, "Queue #{queue} does not exist"
      Resque.queue(q).length
    end

  end
end
