module RansackAction
  def ransackable_attributes(auth_object = nil)
    self::RANSACABLE_ATTRIBUTES
  end

  def ransackable_associations(auth_object = nil)
    self::RANSACABLE_ASSOCIATIONS
  end
end
