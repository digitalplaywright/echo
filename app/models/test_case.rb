class TestCase
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks

  cattr_reader :per_page
  @@per_page = 100

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  def self.build_new
    TestCase.destroy_all
    TestCase.tire.index.delete

    for i in 1..100
      tk = TestCase.new(:name => "foobar")
      tk.save!
    end

    TestCase.tire.index.delete
    TestCase.create_elasticsearch_index
    TestCase.tire.import
  end

  field :name, :type => String

  mapping do
    indexes :name,  :type => 'string'
  end

end