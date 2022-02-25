RSpec::Matchers.define :have_content_type do |expected|
  # TODO: ブロック引数actualを無くして確認してみる
  match do |actual|
    content_types = {
      html: 'text/html',
      json: 'application/json'
    }
    actual.include? content_types[expected.to_sym]
  end
end
