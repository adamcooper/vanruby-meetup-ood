class User < ActiveRecord::Base; end

# This layer uses the ActiveRecord adapter which pulls in several other pieces
class UserLayer
  include ActiveLayer::ActiveRecord

  attr_accessible :name, :email, :address

  validates :name, :email, :presence => true
  validates :address_validation

  before_validate :normalize_address

  def normalize_address; end
  def address_validation
    errors.add(:address, :invalid) if address.blank?
  end
end

# Now how to use it:
user = User.find(1)
layer = UserLayer.new(user)
layer.update_attributes( {:name => '', :admin => true, :address => 'on a busy road'} )   # => false
layer.errors[:name].present # => true
user.errors[:name].present => true
user.admin  # => false   - was filtered out


