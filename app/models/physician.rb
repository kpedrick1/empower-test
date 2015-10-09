class Physician < User
  
  validates :agreement, acceptance: true
  
  def firstname
    @firstname
  end
  
  def lastname
    @lastname
  end

  def phone
    @phone
  end  
  
  def agreement
    @agreement
  end

  def practiceZip
    @practiceZip
  end
  
  def firstname=(val)
    @firstname = val
  end
  
  def lastname=(val)
    @lastname = val
  end
  
  def phone=(val)
    @phone = val
  end  
  
  def agreement=(val)
    @agreement = val
  end

  def practiceZip=(val)
    @practiceZip = val
  end

end
