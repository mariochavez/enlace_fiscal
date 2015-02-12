require 'test_helper'

describe Enlace::Fiscal::Client do
  before do
    Enlace::Fiscal.username = 'sample'
    Enlace::Fiscal.password = 'password'
  end

  it 'should be true' do
    client = Enlace::Fiscal::Client.new

  end
end
