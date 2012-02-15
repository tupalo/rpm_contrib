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
      include NewRelic::Agent::MethodTracer

      add_method_tracer :execute, 'Rake/execute'
    end
  end
end
