# Rake Instrumentation

DependencyDetection.defer do
  @name = :rake

  depends_on do
    defined?(::Rake)
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Rake instrumentation'
  end

  executes do
    ::Rake::Task.class_eval do

      def execute_with_newrelic_trace(*args)
        NewRelic::Agent.trace_execution_scoped "Rake/#{self.name}" do
          NewRelic::Agent::Instrumentation::MetricFrame.current(true).start_transaction
          execute_without_newrelic_trace(*args)
        end
      end

      alias_method :execute_without_newrelic_trace, :execute
      alias_method :execute, :execute_with_newrelic_trace
    end
  end
end
