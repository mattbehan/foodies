class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid

  def self.find_for_oauth(auth)
  	# raise auth.info.inspect
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = new(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity.accesstoken = auth.credentials.token
    identity.name = auth.info.name
    identity.email = auth.info.email
    identity.nickname = auth.info.nickname
    identity.image = auth.info.image
    identity.phone = auth.info.phone
    # identity.save
    identity
  end


  # def name_from_provider provider, auth
  # 	case provider
  # 	when "twitter"
  # 		return auth.nickname

  # 	end
  # end

  def twitter
    identities.where( :provider => "twitter" ).first
  end

  def twitter_client
    @twitter_client ||= Twitter.client( access_token: twitter.accesstoken )
  end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  def instagram
    identities.where( :provider => "instagram" ).first
  end

  def instagram_client
    @instagram_client ||= Instagram.client( access_token: instagram.accesstoken )
  end

end
