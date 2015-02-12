require 'test_helper'

describe Enlace::Fiscal::Receptor do
  let(:receptor) { Enlace::Fiscal::Receptor.new }

  describe 'has attributes' do
    [:name, :rfc, :street, :ext_number, :int_number, :neighborhood, :locality,
     :municipality, :state, :country, :postal_code].each do |attribute|
      it "##{attribute.to_s}" do
        receptor.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do
      receptor.tap do |r|
        r.name = 'Company'
        r.rfc = 'ARTR890102TR5'
        r.street = 'Main St.'
        r.state = 'Baja California'
      end

      receptor.must_be :valid?
    end

    it 'is invalid' do
      receptor.wont_be :valid?
    end
  end
end
