class Patient < User

  validates :agreement, acceptance: true

  # makes the username case insensitive for patient
  before_save do
    self.username.downcase! if self.username
  end

  def self.find_for_authentication(conditions)
    conditions[:username].downcase!
    super(conditions)
  end

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

  def myPhysician
    @myPhysician
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

  def myPhysician=(val)
    @myPhysician = val
  end
  
end
