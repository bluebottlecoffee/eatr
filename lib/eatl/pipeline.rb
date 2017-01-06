module Eatl
  class Pipeline
    def initialize(steps)
      @steps = steps
    end

    def call(row)
      @steps.reduce(row) { |memo, step| step.call(memo) }
    end
  end
end
