require 'test_helper'

describe Enlace::Fiscal::Line do
  let(:line) { Enlace::Fiscal::Line.new }
  let(:valid_line) {
    Enlace::Fiscal::Line.new.tap do |l|
      l.quantity = 1
      l.unit = :piece
      l.description = 'super glue'
      l.unit_price = 1
      l.total = 1
    end
  }

  describe 'has attributes' do
    [:quantity, :unit, :sku, :description, :unit_price, :total].each do |attribute|
      it "##{attribute.to_s}" do
        line.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do
      line.tap do |l|
        l.quantity = 1
        l.unit = :piece
        l.description = 'super glue'
        l.unit_price = 1
        l.total = 1
      end

      line.must_be :valid?
    end

    it 'is invalid' do
      line.wont_be :valid?
    end

    it 'is invalid with quantity or unit_price equals zero or negative' do
      valid_line.quantity = 0
      valid_line.unit_price = 0

      valid_line.wont_be :valid?
      valid_line.errors.length.must_equal 2
    end

    it 'is invalid when unit has invalid value' do
      valid_line.unit = :unknown

      valid_line.wont_be :valid?
      valid_line.errors.length.must_equal 1
    end
  end
end
