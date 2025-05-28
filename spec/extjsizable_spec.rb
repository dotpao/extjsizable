require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Extjsizable" do

  describe Category do

    describe "valid" do
      before do
        @category = Category.new :name => 'The category'
      end

      it "should return success : true and a data section when not ActiveRecord::Base.include_root_in_json" do
        ActiveRecord::Base.include_root_in_json = false

        expect(@category).to be_valid

        json_hash = @category.to_extjs

        expect(json_hash).not_to be_empty
        expect(json_hash).to have_key(:success)
        expect(json_hash[:success]).to be true
        expect(json_hash).to have_key(:data)
      end

      it "should return success : true and a category section when ActiveRecord::Base.include_root_in_json" do
        ActiveRecord::Base.include_root_in_json = true
        expect(@category).to be_valid

        json_hash = @category.to_extjs

        expect(json_hash).not_to be_empty
        expect(json_hash).to have_key(:success)
        expect(json_hash[:success]).to be true
        expect(json_hash).to have_key(:category)
      end

      it "should return a category section with category[name] key when ActiveRecord::Base.wrap_with_brackets?" do
        ActiveRecord::Base.wrap_with_brackets = true

        json_hash = @category.to_extjs
        expect(json_hash[:category]).to have_key('category[name]')
      end

      it "should return the attribute name of category when not ActiveRecord::Base.wrap_with_brackets?" do
        ActiveRecord::Base.wrap_with_brackets = false

        json_hash = @category.to_extjs
        expect(json_hash[:category]).to have_key(:name)
      end

      it "should return all atributes and the result of the methods specified when called with :methods => [...]" do
        json_hash = @category.to_extjs(:methods => :my_method)

        expect(json_hash[:category]).to have_key(:name)
        expect(json_hash[:category]).to have_key(:my_method)
      end

      it "should return success : false and an empty errors section when called with :success => false" do
        json_hash = @category.to_extjs(:success => false)

        expect(json_hash).to have_key(:success)
        expect(json_hash[:success]).to be false

        expect(json_hash).to_not have_key(:data)
        expect(json_hash).to_not have_key(:category)

        expect(json_hash).to have_key(:errors)
        expect(json_hash[:errors]).to be_empty
      end
    end

    describe "not valid" do
      before do
        Category.delete_all
        @category = Category.new
        @category.save
      end

      it "should return success : false and an errors section" do
        expect(@category).to_not be_valid

        json_hash = @category.to_extjs

        expect(json_hash).to_not be_empty
        expect(json_hash).to have_key(:success)
        expect(json_hash[:success]).to be false

        expect(json_hash).to have_key(:errors)
      end

      it "should return the failed attribute name" do
        json_hash = @category.to_extjs
        expect(json_hash[:errors]).to have_key(:name)
      end
    end
  end

  describe Array do
    before(:all) { ActiveRecord::Base.include_root_in_json = false }

    describe 'empty' do
      before do
        @array = []
      end

      it 'should return { total => 0, data => [] }' do
        json_hash = @array.to_extjs
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(0)
        expect(json_hash).to have_key(:data)
        expect(json_hash[:data]).to be_empty
      end
    end

    describe 'with 4 categories with some products each' do
      before do
        Product.delete_all
        Category.delete_all

        4.times do |i|
          c = Category.new :name => "Category #{i}"
          c.products = Array.new(2) { |j| Product.new :name => "Product #{j}" }
          c.save
        end

        @array = Category.all
      end

      it 'should return { :total => 4, :data => [{ "id" => ..., "name" => "Category ..."}, ...] }' do
        json_hash = @array.to_extjs
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(4)

        expect(json_hash).to have_key(:data)
        expect(json_hash[:data].size).to eq(4)
        json_hash[:data].each do |h|
          expect(h).to have_key('id')
          expect(h).to have_key('name')
        end
      end

      it 'should return only id attributes when called with :only => :id ' do
        json_hash = @array.to_extjs :only => :id
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(4)

        expect(json_hash).to have_key(:data)
        expect(json_hash[:data].size).to eq(4)
        json_hash[:data].each do |h|
          expect(h).to have_key('id')
          expect(h).to_not have_key('name')
        end
      end

      it 'should return only name attributes when called with :except => :id ' do
        json_hash = @array.to_extjs :except => :id
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(4)

        expect(json_hash).to have_key(:data)
        expect(json_hash[:data].size).to eq(4)
        json_hash[:data].each do |h|
          expect(h).to have_key('name')
          expect(h).to_not have_key('id')
        end
      end

      it 'should return only related data attributes with :include => :products ' do
        json_hash = @array.to_extjs :include => :products
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(4)

        expect(json_hash).to have_key(:data)
        expect(json_hash[:data].size).to eq(4)
        json_hash[:data].each do |h|
          expect(h).to have_key('name')
          expect(h).to have_key('id')
          expect(h).to have_key('products')
          expect(h['products'].size).to eq(2)
        end
      end

      it 'should return only related data attributes with :include => :category and dasherize all keys' do
        Array.dasherize_keys = true
        json_hash = Product.all.to_extjs :include => :category
        expect(json_hash).to have_key(:total)
        expect(json_hash[:total]).to eq(8)

        expect(json_hash).to have_key(:data)
        expect(json_hash[:data].size).to eq(8)
        json_hash[:data].each do |h|
          expect(h).to have_key('name')
          expect(h).to have_key('id')
          expect(h).to have_key('category_name')
        end
      end

    end
  end


end
