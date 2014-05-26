module Codeqa
  class Runner
    @@registered_checkers = [] # I want this to be inheritable

    def self.register_checker(checker_class)
      @@registered_checkers << checker_class
    end

    # run the checks on source
    def self.run(sourcefile)
      runner = new(sourcefile)
      runner.run
      runner
    end

    def initialize(sourcefile)
      @sourcefile = sourcefile
      @results = []
    end
    attr_reader :sourcefile

    def matching_checkers
      @matching_checkers ||= @@registered_checkers.select do |checker_class|
        checker_class.check?(sourcefile)
      end
    end

    def run
      return @results unless @results.empty?
      @results = matching_checkers.map do |checker_class|
        checker = checker_class.new(sourcefile)

        checker.before_check if checker.respond_to?(:before_check)
        checker.check
        checker.after_check if checker.respond_to?(:after_check)
        checker
      end
    end

    # the results (checker instances of the run)
    attr_reader :results

    def failures
      @failures ||= @results.reject{ |checker| checker.success? }
    end

    def success?
      failures.empty?
    end

    def display_result(options={})
      RunnerDecorator.new(self, options)
    end
  end
end
