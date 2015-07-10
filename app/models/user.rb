class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :leave_requests
  has_and_belongs_to_many :roles

  CV_STORE = File.join Rails.root.to_s, 'public', 'CVs'

  def role?(role)
  	return !!self.roles.find_by_name(role.to_s)
  end

  def upload_cv(upload)
    name =  upload['datafile'].original_filename
    self.filename = name
    self.save!
    # create the file path
    path = File.join(CV_STORE, self.filename)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

end
