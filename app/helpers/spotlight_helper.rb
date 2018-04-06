##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def admin_set_link opts={}
    if @exhibit && @exhibit.admin_set_id
      link_to t(:'spotlight.curration.sidebar.collection'), admin_set_path(@exhibit.admin_set_id)
    end
  end
end
