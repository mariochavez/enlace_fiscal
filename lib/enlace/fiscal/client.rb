require 'weary'

module Enlace
  module Fiscal
    class Client < Weary::Client
      domain 'https://api.enlacefiscal.com'
      headers 'ACCEPT' => 'application/json'

      post :create_cdfi, '/rest/v1/comprobantes/emitir' do |resource|
        resource.basic_auth!
      end
    end
  end
end
