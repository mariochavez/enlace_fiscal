require 'test_helper'

describe Enlace::Fiscal::Tax do
  let(:tax) { Enlace::Fiscal::Tax.new }
  let(:valid_tax) {
    Enlace::Fiscal::Tax.new.tap do |tax|
      tax.type = :iva
      tax.kind = :retained
      tax.rate = 16
      tax.total = 100
    end
  }

  describe 'has attributes' do
    [:type, :rate, :total, :kind].each do |attribute|
      it "##{attribute.to_s}" do
        tax.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do
      tax.tap do |t|
        t.type = :iva
        t.kind = :retained
        t.rate = 16
        t.total = 100
      end

      tax.must_be :valid?
    end

    it 'is invalid' do
      tax.wont_be :valid?
    end

    it 'is invalid when tax type is invalid option' do
      valid_tax.type = :unknown

      valid_tax.wont_be :valid?
      valid_tax.errors.length.must_equal 1
    end

    it 'is invalid when tax kind is invalid option' do
      valid_tax.kind = :unknown

      valid_tax.wont_be :valid?
      valid_tax.errors.length.must_equal 1
    end

    it 'is invaid when total or rate is less than zero' do
      valid_tax.total = -1.0
      valid_tax.rate = -1.0

      valid_tax.wont_be :valid?
      valid_tax.errors.length.must_equal 2
    end
  end
end
