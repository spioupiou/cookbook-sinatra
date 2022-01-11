class Recipe < ActiveRecord::Base
  belongs_to :user
  before_save :init

  validates_presence_of :name, :description

  def init
    self.img_url ||= build_img
  end

  private

  def build_img
    num = rand(1..11)
    self.img_url ||= "img/food#{num}.jpg"
  end
end
