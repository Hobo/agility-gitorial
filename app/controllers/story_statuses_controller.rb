class StoryStatusesController < ApplicationController

  hobo_model_controller

  auto_actions :write_only, :new, :index

  index_action :index2, :index3, :index4

  autocomplete

  def create
    hobo_create do
      if valid?
        respond_to do |wants|
          wants.html { redirect_after_submit }
          wants.js   {
            self.this = StoryStatus.all.paginate
            hobo_ajax_response
          }
        end
      else
        respond_to do |wants|
          # errors is used by the translation helper, ht, below.
          errors = this.errors.full_messages.join("\n")
          wants.html { re_render_form(new_action) }
          wants.js   { render(:status => 500,
                              :text => ht( :"#{this.class.to_s.underscore}.messages.create.error", :errors=>errors,:default=>["Couldn't create the #{this.class.name.titleize.downcase}.\n #{errors}"])
                               )}
        end
      end
    end
  end

  def destroy
    hobo_destroy do
      respond_to do |wants|
        wants.html { redirect_after_submit(this, true) }
        wants.js   {
          self.this = StoryStatus.all.paginate
          hobo_ajax_response || render(:nothing => true)
        }
      end
    end
  end

end
