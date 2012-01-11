class Country < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    code :string
    region_label :string
    timestamps
  end

  has_many :regions

  has_many :projects

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
