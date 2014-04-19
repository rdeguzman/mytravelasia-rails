module JavascriptHelpers
  def accept_confirmation_dialog
    page.driver.browser.switch_to.alert.accept
  end

  def dismiss_confirmation_dialog
    page.driver.browser.switch_to.alert.dismiss
  end

  def wait_for_javascript
    wait_until do
      page.evaluate_script('$.active') == 0
    end
  end

end