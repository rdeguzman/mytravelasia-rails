require 'spec_helper'

describe 'APN Management' do
  include_context 'login'

  context 'when creating a notification' do
    it 'has country field' do
      login_user(:admin)

      visit admin_new_apn_path
      page.should have_field('apn_app_id')

      logout_user
    end
  end

end