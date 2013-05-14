class RSpec::Core::ExampleGroup
  def not_for_null(&block)
    unless defined?(null) && null
      yield
    end
  end
end
