module ResqueWorkersNag
  class Query
    attr_reader :exit_code, :msg

    def self.work! resque_queues, queue_list, warning, critical
      @msg = []
      @exit_code = 0

      queue_list = resque_queues.queues  if queue_list.length == 1 and queue_list.first == 'all'
      queue_list.each do |q|
        @working_length = resque_queues.length q
        @working_queue = q

        if @working_length >= critical
          critical!
        elsif @working_length >= warning
          warning!
        else
          ok!
        end
      end
      return @exit_code, @msg
    end

    private
    def self.message
      "Queue #{@working_queue} has a length of #{@working_length}"
    end

    def self.ok!
      @msg << "OK: #{message}"
    end

    def self.critical!
      @msg << "Critical: #{message}"
      @exit_code = 2
    end

    def self.warning!
      @msg << "Warning: #{message}"
      @exit_code = 1 unless @exit_code == 2
    end
  end
end
