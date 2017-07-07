class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_at_least_one_admin_remains

  class Error < StandardError
  end

  private

  def ensure_at_least_one_admin_remains
    raise Error.new "Can't delete last user" if User.count.zero?
  end
end
