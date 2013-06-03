class Story < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title  :string
    body   :markdown # or :textile
    tasks_count :integer, :default => 0, :null => false
    timestamps
  end
  attr_accessible :title, :body, :status, :status_id, :project, :project_id, :tasks

  belongs_to :project, :inverse_of => :stories, :counter_cache => true
  belongs_to :status, :class_name => "StoryStatus", :inverse_of => :stories
  has_many :tasks, :dependent => :destroy, :inverse_of => :story, :order => :position

  children :tasks

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.signed_up? && !project_changed?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
