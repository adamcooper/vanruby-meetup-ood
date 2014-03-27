class Service::ServiceDescription
  attr :name, :klass, :arguments

  def create(options)
    service = klass.new
    inject_arguments(service, options)
    service
  end

  private

  def verify_arguments!(options)
    missing_keys = arguments.select { |arg| !options.has_key?(arg) }
    raise ArgumentError, "Missing the following arguments: #{missing_keys.join(', ')}" if missing_keys.present?
  end

  def inject_arguments(service, options)
    verify_arguments!(options)

    # strong coupling between the service, argument, and hash names
    arguments.each do |argument|
      service.send("#{argument}=", options[argument])
    end
  end
end







class Service::ServiceResult
  attr_accessor :code, :object, :error
  def import(service_result)
    self.object = service_result.object
    if service_result.error.present?
      record_error(service_result.error)
    else
      self.code = service_result.code
    end
    # more symmetrical
    # self.object = service_result.object
    # self.code = service_result.code
    # self.error = service_result.error
  end

  def record_error(error)
    self.error = error
    self.code = :error
  end
end






class Service::Base
  class_attribute :all_services
  self.all_services = {}

  class_attribute :service_description

  class << self
    # hooks into the inheritance and setups the name by default
    def inherited(base)
      name = base.name.split('::').last.gsub('Service', '').underscore
      base.send(:service_name, name) rescue DuplicateNameError nil
    end

    def service_name(name)
      verify_subclass!
      key_name = name.to_sym
      raise DuplicateNameError, "The service #{self.name} is trying to define a service_name of #{name} when it has already been defined by #{all_services[key_name].klass.name}" if all_services.has_key?(key_name)

      # remove the old entry
      all_services.delete(service_description.name) if service_description.present?

      self.service_description ||= ServiceDescription.new
      service_description.update(key_name, self)

      # save off reference
      all_services[service_description.name] = service_description
    end

    def service(name, options = {})
      return defaults[:injected_services][name] if defaults[:injected_services].has_key?(name)

      description = all_services[name]

      # if the description isn't there then load the class and try again
      if description.blank?
        service_klass = "#{name}_service".classify
        service_klass.constantize rescue nil
        description = all_services[name]
      end

      # actually instantiate the service if it is found
      if description.present?
        initialize_params = (defaults[:init] || {}).merge(options)
        description.create(initialize_params)
      else
        nil
      end
    end
end


