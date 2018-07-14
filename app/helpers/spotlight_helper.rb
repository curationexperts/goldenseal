##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def admin_set_link opts={}
    if @exhibit.exhibitable
      link_to t(:'spotlight.curration.sidebar.collection'), @exhibit.exhibitable
    end
  end
end
