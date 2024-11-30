ActiveSupport.on_load(:action_text_rich_text) do
  class ActionText::RichText < ActionText::Record
    def self.ransackable_attributes(auth_object = nil)
      authorizable_ransackable_attributes
    end
  end
end
