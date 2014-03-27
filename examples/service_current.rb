class SignupUser < Service::Call

  attribute :name, String
  attribute :email, String
  attribute :wants_email, Boolean, default: ->(signup_user, attribute) { true }

  class Result < Service::Result
    attribute :user, User
  end

  def call
    user = User.new(name: name, email: email, accepts_email: wants_email)
    result.user = user

    if user.save
      UserMailer.welcome_email(user.email).deliver
      result.successful!
    else
      result.add_errors(user)
    end

    result
  end
end







class Service::Call
  include Virtus.model

  attribute :result, Service::Result, default: ->(service,_) { service.build_result }

  def self.call(*args)
    new(*args).call
  end

  protected

  def build_result
    klass = self.class.const_get("Result") rescue Service::Result
    klass.new
  end

  def with_exception_catching
    begin
      yield
    rescue StandardError => exception
      result.exception = exception
      result.add_errors(exception.record) if exception.respond_to?(:record)
    end
  end

end
