class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    stories_count :integer, :default => 0, :null => false
    timestamps
  end
  attr_accessible :name, :stories

  has_many :stories, :dependent => :destroy, :inverse_of => :project

  children :stories

  belongs_to :owner, :class_name => "User", :creator => true, :inverse_of => :projects

  # --- Permissions --- #

  def create_permitted?
    owner_is? acting_user
  end

  def update_permitted?
    acting_user.administrator? || (owner_is?(acting_user) && !owner_changed?)
  end

  def destroy_permitted?
    acting_user.administrator? || owner_is?(acting_user)
  end

  def view_permitted?(field)
    true
  end

end
