module OnlineNic::Transaction::Helpers
  def get_action
    category = document.root.elements['category'].text
    action = document.root.elements['action'].text
    "#{category}/#{action}"
  end
end
