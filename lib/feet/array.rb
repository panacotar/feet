class Array
  def deeply_empty?
    empty? || all?(&:empty?)
  end

  def present?
    !blank?
  end

  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def all_strings?
    all?(String)
  end
end
