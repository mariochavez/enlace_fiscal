require 'test_helper'

describe Enlace::Fiscal::Invoice do
  let(:invoice) {
    Enlace::Fiscal::Invoice.new.tap do |i|
      i.serie = 'GA'
      i.folio = 1
      i.date = Date.today
      i.subtotal = 1.0
      i.total = 1.0
      i.tax_translated_total = 0
      i.tax_retained_total = 0
      i.rfc = 'RFCT800101TR4'
    end
  }

  describe 'has attributes' do
    [:serie, :folio, :date, :subtotal, :total, :rfc, :valid?,
     :payment, :receptor, :lines, :taxes, :tax_retained_total,
     :tax_translated_total].each do |attribute|
      it "##{attribute.to_s}" do
        invoice.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do

      invoice.must_be :valid?
    end

    it 'is invalid' do
      Enlace::Fiscal::Invoice.new.wont_be :valid?
    end

    it 'is invalid when subtotal or total is less than zero' do
      invoice.tap do |i|
        i.subtotal = -1.0
        i.total = -1.0
        i.tax_translated_total = -1.0
        i.tax_retained_total = -1.0
      end

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 4
    end

    it 'is invalid if rfc format is invalid' do
      invoice.rfc = 'RFC'

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end

    it 'is invalid if rfc length is invalid' do
      invoice.rfc = 'RFCT800101TR478'

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end
  end

  describe 'lines' do
    it 'add' do
      invoice.add_line

      invoice.lines.length.must_equal 2
    end

    it 'delete' do
      invoice.add_line
      invoice.delete_line_at(1)

      invoice.lines.length.must_equal 1
    end
  end

  describe 'taxes' do
    it 'add' do
      invoice.add_tax

      invoice.taxes.length.must_equal 2
    end

    it 'delete' do
      invoice.add_tax
      invoice.delete_tax_at(1)

      invoice.taxes.length.must_equal 1
    end
  end
end
