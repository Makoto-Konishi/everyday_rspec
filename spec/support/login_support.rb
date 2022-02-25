module LoginSupport
  def sign_in_as(user)
    visit root_path # root_pathに移動する
    click_link 'Sign in' # Sign inボタンを押す
    fill_in 'Email', with: user.email # emailを入力する
    fill_in 'Password', with: user.password # passwordを入力する
    click_button 'Log in' # Log inボタンを押す
  end
end
