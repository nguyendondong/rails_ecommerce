class ApplicationRecord < ActiveRecord::Base
  extend RansackAction

  self.abstract_class = true
end
