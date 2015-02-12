require 'test_helper'

describe 'Configuration' do
  it 'receives a username' do
    Enlace::Fiscal.username = 'sample'

    Enlace::Fiscal.username.must_equal 'sample'
  end

  it 'receives a password' do
    Enlace::Fiscal.password = 'password'

    Enlace::Fiscal.password.must_equal 'password'
  end

  it 'mode is debug by default' do
    Enlace::Fiscal.mode = nil

    Enlace::Fiscal.mode.must_equal 'debug'
  end

  it 'receives a mode' do
    Enlace::Fiscal.mode = 'production'

    Enlace::Fiscal.mode.must_equal 'production'
  end

  it 'version is 5.0 by default' do
    Enlace::Fiscal.version = nil

    Enlace::Fiscal.version.must_equal 5.0
  end

  it 'receives a version' do
    Enlace::Fiscal.version = 5.5

    Enlace::Fiscal.version.must_equal 5.5
  end
end
