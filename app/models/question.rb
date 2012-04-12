class Question < ActiveRecord::Base
  belongs_to :user
  
  #before_save :capitalize_fields
  before_create :randomize_file_name
  
  has_attached_file :opt1_image, 
                    :styles => { :medium => "180x180>", :thumb => "32x32>" },
                    :default_url => '/assets/missing.png',
                    :url=>"/system/:class_images/:basename_:style.:extension"
  has_attached_file :opt2_image, 
                    :styles => { :medium => "180x180>", :thumb => "32x32>" },
                    :default_url => '/assets/missing.png',
                    :url=>"/system/:class_images/:basename_:style.:extension"
  
  STATUSES = %w(wapproval approved deleted)
  
  validates_uniqueness_of :opt1, :scope => [:opt2]
  validates_presence_of :status , :opt1, :opt2
  validates_inclusion_of :status, :in => STATUSES
  
  scope :nopicture, where('opt1_image_file_name is null or opt2_image_file_name is null')
  scope :active, where("status='approved'")
  scope :fresh, lambda { |user| where('id not in (select distinct question_id from answers where user_id= ?)',user.id) }
  scope :pictured, where('opt1_image_file_name is not null and opt2_image_file_name is not null')
  
  def randomize_file_name
    if !opt1_image_file_name.blank?
      extension = File.extname(opt1_image_file_name).downcase
      self.opt1_image.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
    end
    
    if !opt2_image_file_name.blank?
      extension = File.extname(opt2_image_file_name).downcase
      self.opt2_image.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
    end
  end
  
  def user_email
    self.user.email if !self.user.nil?
  end
  
  
  def capitalize_fields
    self.opt1=UnicodeUtils.titlecase(self.opt1)
    self.opt2=UnicodeUtils.titlecase(self.opt2)
  end
  
  
  class << self 
    STATUSES.each do |status_name|
      define_method "all_#{status_name}" do
        where(:status => status_name)
      end 
    end
  end
  
  # Status Accessors
  STATUSES.each do |status_name| 
    define_method "#{status_name}?" do
      status == status_name 
    end
  end
  
  def approve
    self.update_attribute(:status,STATUSES[1])
  end
  
  
  attr_accessor :opt1_image_client,:opt2_image_client
  
  def points_for_create 
    10
  end
  
  before_validation :decode_client_images

  def cover_image_data_provided?
    !self.cover_image_data.blank?
  end

  def decode_client_images
    # If cover_image_data is set, decode it and hand it over to Paperclip
    if !self.opt1_image_client.blank?
      data = StringIO.new(Base64.decode64(self.opt1_image_client))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "cover.jpg"
      data.content_type = "image/jpeg"
      self.opt1_image = data
    end
    
    if !self.opt2_image_client.blank?
      data = StringIO.new(Base64.decode64(self.opt2_image_client))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "cover.jpg"
      data.content_type = "image/jpeg"
      self.opt2_image = data
    end
     
  end
  
  
end