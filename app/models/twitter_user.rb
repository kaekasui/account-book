class TwitterUser < User
  def self.find_for_oauth(auth)
    where(uid: auth.uid).first
  end

  def self.create_with_oauth(auth)
    create!(provider: auth.provider, uid: auth.uid,
      name: auth.info.name, nickname: auth.info.nickname,
      confirmed_at: Time.now(), token: auth.credentials.token)
  end 

  def update_with_oauth(auth)
    update_attributes!(name: auth.info.name, nickname: auth.info.nickname, 
      token: auth.credentials.token)
  end
end
