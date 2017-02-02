class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.set_record_id(recordid)
    hv_recordid = recordid
    save
  end

  def self.retrieve(username)
    find_by username: username
  end

  def active_for_authentication?
    #super && approved?

    super
  end

  def inactive_message
    # if !approved?
    #   :not_approved
    # else
    #   super # Use whatever other message
    # end

    super
  end

  # def self.send_reset_password_instructions(attributes={})
  #   recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
  #   if !recoverable.approved?
  #     recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
  #   elsif recoverable.persisted?
  #     recoverable.send_reset_password_instructions
  #   end
  #   recoverable
  # end


end
