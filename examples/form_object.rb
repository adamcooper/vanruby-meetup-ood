class EditUserForm < FormObject

  attribute :first_name, String
  attribute :last_name, String
  attribute :email, String
  attribute :age, Fixnum

  attribute :contacts, Array[UserContacts]

  validates :first_name, :last_name, presence: true
  validates :age, numericality: { greater_than_zero: true }
  validates :email, email: true, presence: true

  validate :nested_objects_are_valid

  private

  def nested_objects_are_valid
    [contacts].each do |nested_obj|
      add_errors(nested_obj) unless nested_obj.valid?
    end
  end
end




class UserContacts < FormObject

  attribute :full_name, String
  attribute :relationship, String
  attribute :email, String

  validates :full_name, :relationship, presence: true
  validates :email, email: true, presence: true

end




class FormObject
  extend ActiveModel::Naming, ActiveModel::Translation
  include ActiveModel::Conversion, ActiveModel::Validations
  include Virtus.model

  def persisted?
    false
  end

  def add_errors(objs_with_errors)
    Array(objs_with_errors).each do |object|
      self.errors.messages.merge!(object.errors)
    end
  end

end
