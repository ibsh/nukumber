class String
  def nukesym
    self.downcase.gsub(/\W/, '_').to_sym
  end
end
