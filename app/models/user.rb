class User < ApplicationRecord
  has_secure_password
  has_many :twists, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :favorite_twists, through: :favorites, source: :twist
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true
  validates :name, presence: true
  validates :handle, presence: true

  def self.authenticate_with_credentials(email, password)
    stripped = email.strip
    @user = self.where("email = ?",stripped.downcase).first
    if @user && @user.authenticate(password)
      return @user
    end
    nil
  end

  def self.getTwists(id, recipe_id)
    
    # attempts to pull a twist from our random user id for the respective recipe
    twists = Twist.joins('join recipes on recipes.id = twists.recipe_id').select('*').where(recipe_id: recipe_id, user_id: id)

    #if this pull is unsucessful we need to pull all records with recipe id and select a random one that exists 
   if twists.blank?
    puts "No twists were found for user #{id} for recipe id #{recipe_id}"
    twists = Twist.where(recipe_id: recipe_id).order("random()").limit(1)
    puts twists.inspect
   end



    return twists
  end
end


  
