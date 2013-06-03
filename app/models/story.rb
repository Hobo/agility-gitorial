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
    project.creatable_by?(acting_user)
  end

  def update_permitted?
    project.updatable_by?(acting_user)
  end

  def destroy_permitted?
    project.destroyable_by?(acting_user)
  end

  def view_permitted?(field)
    project.viewable_by?(acting_user)
  end

end
